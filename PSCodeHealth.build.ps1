#Requires -Modules 'InvokeBuild'

# Importing all build settings into the current scope
. '.\PSCodeHealth.BuildSettings.ps1'

Function Write-TaskBanner ( [string]$TaskName ) {
    "`n" + ('-' * 79) + "`n" + "`t`t`t $($TaskName.ToUpper()) `n" + ('-' * 79) + "`n"
}

task Clean {
    Write-TaskBanner -TaskName $Task.Name

    If (Test-Path -Path $Settings.BuildOutput) {
        "Removing existing files and folders in $($Settings.BuildOutput)\"
        Get-ChildItem $Settings.BuildOutput | Remove-Item -Force -Recurse
    }
    Else {
        "$($Settings.BuildOutput) is not present, nothing to clean up."
        $Null = New-Item -ItemType Directory -Path $Settings.BuildOutput
    }
}

task Install_Dependencies {
    Write-TaskBanner -TaskName $Task.Name

    Foreach ( $Depend in $Settings.Dependency ) {
        "Installing build dependency : $Depend"
        Install-Module $Depend -Scope CurrentUser -Force
        Import-Module $Depend -Force
    }
}

task Unit_Tests {
    Write-TaskBanner -TaskName $Task.Name

    $UnitTestSettings = $Settings.UnitTestParams
    $Script:UnitTestsResult = Invoke-Pester @UnitTestSettings
}

task Fail_If_Failed_Unit_Test {
    Write-TaskBanner -TaskName $Task.Name

    $FailureMessage = '{0} Unit test(s) failed. Aborting build' -f $UnitTestsResult.FailedCount
    assert ($UnitTestsResult.FailedCount -eq 0) $FailureMessage
}

task Publish_Unit_Tests_Coverage {
    Write-TaskBanner -TaskName $Task.Name

    $Coverage = Format-Coverage -PesterResults $UnitTestsResult -CoverallsApiToken $Settings.CoverallsKey -BranchName $Settings.Branch
    Publish-Coverage -Coverage $Coverage
}

task Integration_Tests {
    Write-TaskBanner -TaskName $Task.Name

    $IntegrationTestSettings = $Settings.IntegrationTestParams
    $Script:IntegrationTestsResult = Invoke-Pester @IntegrationTestSettings
}

task Fail_If_Failed_Integration_Test {
    Write-TaskBanner -TaskName $Task.Name

    $FailureMessage = '{0} Integration test(s) failed. Aborting build' -f $IntegrationTestsResult.FailedCount
    assert ($IntegrationTestsResult.FailedCount -eq 0) $FailureMessage
}

task Upload_Test_Results_To_AppVeyor {
    Write-TaskBanner -TaskName $Task.Name

    $TestResultFiles = (Get-ChildItem -Path $Settings.BuildOutput -Filter '*TestsResult.xml').FullName
    Foreach ( $TestResultFile in $TestResultFiles ) {
        "Uploading test result file : $TestResultFile"
        (New-Object 'System.Net.WebClient').UploadFile($Settings.TestUploadUrl, $TestResultFile)
    }
}

task Test Unit_Tests,
    Fail_If_Failed_Unit_Test,
    Publish_Unit_Tests_Coverage,
    # There are no integration tests at the moment
    # Integration_Tests,
    # Fail_If_Failed_Integration_Test,
    Upload_Test_Results_To_AppVeyor

task Analyze {
    Write-TaskBanner -TaskName $Task.Name

    Add-AppveyorTest -Name 'Code Analysis' -Outcome Running
    $AnalyzeSettings = $Settings.AnalyzeParams
    $Script:AnalyzeFindings = Invoke-ScriptAnalyzer @AnalyzeSettings

    If ( $AnalyzeFindings ) {
        $FindingsString = $AnalyzeFindings | Out-String
        Write-Warning $FindingsString
        Update-AppveyorTest -Name 'Code Analysis' -Outcome Failed -ErrorMessage $FindingsString
    }
    Else {
        Update-AppveyorTest -Name 'Code Analysis' -Outcome Passed
    }
}

task Fail_If_Analyze_Findings {
    Write-TaskBanner -TaskName $Task.Name

    $FailureMessage = 'PSScriptAnalyzer found {0} issues. Aborting build' -f $AnalyzeFindings.Count
    assert ( -not($AnalyzeFindings) ) $FailureMessage
}

task Copy_Source_To_Build_Output {
    Write-TaskBanner -TaskName $Task.Name

    "Copying the source folder [$($Settings.SourceFolder)] into the build output folder : [$($Settings.BuildOutput)]"
    Copy-Item -Path $Settings.SourceFolder -Destination $Settings.BuildOutput -Recurse
}

task Set_Module_Version {
    Write-TaskBanner -TaskName $Task.Name

    $ManifestContent = Get-Content -Path $Settings.ManifestPath
    $CurrentVersion = $Settings.VersionRegex.Match($ManifestContent).Groups['ModuleVersion'].Value
    "Current module version in the manifest : $CurrentVersion"

    $ManifestContent -replace $CurrentVersion,$Settings.Version | Set-Content -Path $Settings.ManifestPath -Force
    $NewManifestContent = Get-Content -Path $Settings.ManifestPath
    $NewVersion = $Settings.VersionRegex.Match($NewManifestContent).Groups['ModuleVersion'].Value
    "Updated module version in the manifest : $NewVersion"

    If ( $NewVersion -ne $Settings.Version ) {
        Throw "Module version was not updated correctly to $($Settings.Version) in the manifest."
    }
}

# Default task :
task . Clean,
    Install_Dependencies,
    Test,
    Analyze,
    Fail_If_Analyze_Findings,
    Copy_Source_To_Build_Output,
    Set_Module_Version
