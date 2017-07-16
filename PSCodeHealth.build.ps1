#Requires -Modules 'InvokeBuild'

# Importing all build settings into the current scope
. '.\PSCodeHealth.BuildSettings.ps1'

Function Write-TaskBanner ( [string]$TaskName ) {
    "`n" + ('-' * 79) + "`n" + "`t`t`t $($TaskName.ToUpper()) `n" + ('-' * 79) + "`n"
}

Function Get-ModulePrivateFunction {
    [CmdletBinding()]
    [OutputType([System.Management.Automation.FunctionInfo])]
    Param (
        [Parameter(Mandatory)]
        [string]$ModuleName
    )
    
    $ModuleInfo = $Null
    $ModuleInfo = Get-Module -Name $ModuleName -ErrorAction SilentlyContinue
    If ( -not $ModuleInfo ) {
        Write-Error "Module '$ModuleName' not found"
    }
    $ScriptBlock = { $ExecutionContext.InvokeCommand.GetCommands('*', 'Function', $true) }
    $PublicFunctions = ($ModuleInfo.ExportedCommands.GetEnumerator() | Select-Object -ExpandProperty Value).Name

    & $ModuleInfo $ScriptBlock | Where-Object { $_.Source -eq $ModuleName -and $_.Name -notin $PublicFunctions }
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
        If ( $Depend -eq 'Selenium.WebDriver' ) {
            Install-Package $Depend -Source nuget.org -Force
        }
        Else {
            Install-Module $Depend -Scope CurrentUser -Force -SkipPublisherCheck
            Import-Module $Depend -Force
        }
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

task Upload_Test_Screenshots_To_Appveyor {
    Write-TaskBanner -TaskName $Task.Name

    $ScreenShots = Get-ChildItem -Path $Settings.ScreenshotPath
    Foreach ( $ScreenShot in $ScreenShots ) {
        "Uploading file $($Screenshot.Name) as an Appveyor artifact"
        Push-AppveyorArtifact $ScreenShot.FullName
    }
}

task Test Unit_Tests,
    Fail_If_Failed_Unit_Test,
    Publish_Unit_Tests_Coverage,
    Integration_Tests,
    Fail_If_Failed_Integration_Test,
    Upload_Test_Results_To_AppVeyor,
    Upload_Test_Screenshots_To_Appveyor

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

Task Build_Documentation {
    Write-TaskBanner -TaskName $Task.Name
    
    Remove-Module -Name $Settings.ModuleName -Force -ErrorAction SilentlyContinue
    # platyPS + AppVeyor requires the module to be loaded in Global scope
    Import-Module $Settings.ManifestPath -Force -Global
    
    $HeaderContent = Get-Content -Path $Settings.HeaderPath -Raw
    $HeaderContent += "  - Public Functions:`n"
    If (Test-Path -Path $Settings.PublicFunctionDocsPath) {
        Get-ChildItem $Settings.PublicFunctionDocsPath | Remove-Item -Force -Recurse
    }
    Else {
        $Null = New-Item -ItemType Directory -Path $Settings.PublicFunctionDocsPath
    }

    $PlatyPSSettings = $Settings.PlatyPSParams
    New-MarkdownHelp @PlatyPSSettings | Foreach-Object {
        $Part = '    - {0}: PublicFunctions/{1}' -f $_.BaseName, $_.Name
        "Created markdown documentation file : $($_.FullName)"
        $HeaderContent += "{0}`n" -f $Part
    }
    $HeaderContent | Set-Content -Path $Settings.MkdocsPath -Force

    # Building the docs for the private functions
    $MkdocsContent = Get-Content -Path $Settings.MkdocsPath -Raw
    $MkdocsContent += "  - Internal Functions:`n"
    $PrivateFunctions = Get-ModulePrivateFunction -ModuleName $Settings.ModuleName | Where-Object Name -NotIn $Settings.FunctionsToExclude
    If (Test-Path -Path $Settings.PrivateFunctionDocsPath) {
        Get-ChildItem $Settings.PrivateFunctionDocsPath | Remove-Item -Force -Recurse
    }
    Else {
        $Null = New-Item -ItemType Directory -Path $Settings.PrivateFunctionDocsPath
    }
    Foreach ( $PrivateFunction in $PrivateFunctions ) {
        $FunctionDefinition = 'Function Global:{0} {{ {1} }}' -f $PrivateFunction.Name, $PrivateFunction.Definition
        . ([scriptblock]::Create($FunctionDefinition))
        $InternalDocsSettings = $Settings.InternalDocsPlatyPSParams
        $NewMarkdownFile = New-MarkdownHelp @InternalDocsSettings -Command $PrivateFunction.Name
        "Created markdown documentation file : $($NewMarkdownFile.FullName)"
        $Part = '    - {0}: InternalFunctions/{1}' -f $NewMarkdownFile.BaseName, $NewMarkdownFile.Name
        $MkdocsContent += "{0}`n" -f $Part
    }
    $MkdocsContent | Set-Content -Path $Settings.MkdocsPath -Force
    Remove-Item "Function:\$($PrivateFunction.Name)" -ErrorAction SilentlyContinue
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

task Push_Build_Changes_To_Repo {
    Write-TaskBanner -TaskName $Task.Name  
    
    cmd /c "git config --global credential.helper store 2>&1"    
    Add-Content "$env:USERPROFILE\.git-credentials" "https://$($Settings.GitHubKey):x-oauth-basic@github.com`n"
    cmd /c "git config --global user.email ""$($Settings.Email)"" 2>&1"
    cmd /c "git config --global user.name ""$($Settings.Name)"" 2>&1"
    cmd /c "git config --global core.autocrlf true 2>&1"
    cmd /c "git checkout $($Settings.Branch) 2>&1"
    cmd /c "git add -A 2>&1"
    cmd /c "git commit -m ""Commit build changes [ci skip]"" 2>&1"
    cmd /c "git status 2>&1"
    cmd /c "git push origin $($Settings.Branch) 2>&1"
}

task Copy_Source_To_Build_Output {
    Write-TaskBanner -TaskName $Task.Name

    "Copying the source folder [$($Settings.SourceFolder)] into the build output folder : [$($Settings.BuildOutput)]"
    Copy-Item -Path $Settings.SourceFolder -Destination $Settings.BuildOutput -Recurse
}

# Default task :
task . Clean,
    Install_Dependencies,
    Test,
    Analyze,
    Fail_If_Analyze_Findings,
    Build_Documentation,
    Set_Module_Version,
    Push_Build_Changes_To_Repo,
    Copy_Source_To_Build_Output
