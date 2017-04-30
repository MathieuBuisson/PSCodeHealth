#Requires -Modules 'InvokeBuild'
Param (
    [string]$BuildOutput = "$PSScriptRoot\BuildOutput",

    [string[]]$Dependency = @('Coveralls','Pester','PsScriptAnalyzer'),

    [string]$SourceFolder = "$PSScriptRoot\$($env:APPVEYOR_PROJECT_NAME)"
)

Function Write-TaskBanner ( [string]$TaskName )
{
    "`n" + ('-' * 79) + "`n" + "`t`t`t $($TaskName.ToUpper()) `n" + ('-' * 79) + "`n"
}

task Clean {
    Write-TaskBanner -TaskName $Task.Name

    If (Test-Path -Path $Script:BuildOutput) {
        "Removing existing files and folders in $($Script:BuildOutput)\"
        Get-ChildItem .\BuildOutput\ | Remove-Item -Force -Recurse
    }
    Else {
        "$Script:BuildOutput is not present, nothing to clean up."
        $Null = New-Item -ItemType Directory -Path $Script:BuildOutput
    }
}

task Install_Dependencies {
    Write-TaskBanner -TaskName $Task.Name

    Foreach ( $Depend in $Script:Dependency ) {
        Install-Module $Depend -Scope CurrentUser -Force
        Import-Module $Depend -Force
    }
}

task Unit_Tests {
    Write-TaskBanner -TaskName $Task.Name

    $UnitTestParams = @{
        Script = '.\Tests\Unit'
        CodeCoverage = '.\PSCodeHealth\P*\*'
        OutputFile = 'UnitTestsResult.xml'
        PassThru = $True
    }
    $Script:UnitTestsResult = Invoke-Pester @UnitTestParams
}

task Fail_If_Failed_Unit_Test -If ( $Script:UnitTestsResult.FailedCount -ne 0 ) {
    Write-TaskBanner -TaskName $Task.Name

    assert ($Script:UnitTestsResult.FailedCount -eq 0) ('{0} Unit test(s) failed. Aborting build' -f $Script:UnitTestsResult.FailedCount)
}

Task Copy_Source_To_Build_Output {
    Write-TaskBanner -TaskName $Task.Name

    "Copying the source directory [$Script:SourceFolder] into the build output folder : [$Script:BuildOutput]"
    Copy-Item -Path $Script:SourceFolder -Destination $Script:BuildOutput -Recurse
}


# Default task :
task . Clean, Install_Dependencies, Unit_Tests, Fail_If_Failed_Unit_Test, Copy_Source_To_Build_Output