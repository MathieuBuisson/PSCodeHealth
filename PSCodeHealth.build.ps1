#Requires -Modules 'InvokeBuild'
Param (
    [string]$BuildOutput = "$PSScriptRoot\BuildOutput",

    [string[]]$Dependency = @('Coveralls','Pester','PsScriptAnalyzer')
)

Function Write-TaskBanner ( [string]$TaskName )
{
    "`n" + ('-' * 79) + "`n" + "`t`t`t $TaskName `n" + ('-' * 79) + "`n"
}

task Clean {
    Write-TaskBanner -TaskName $Task.Name

    If (Test-Path -Path $BuildOutput) {
        "Removing existing files and folders in $BuildOutput\"
        Get-ChildItem .\BuildOutput\ | Remove-Item -Force -Recurse
    }
    Else {
        "$BuildOutput is not present, nothing to clean up."
    }
}

task InstallDependencies {
    Write-TaskBanner -TaskName $Task.Name

    Foreach ( $Depend in $Script:Dependency ) {
        Install-Module $Depend -Scope CurrentUser -Force
        Import-Module $Depend -Force
    }
}

# Default task : runs all tasks
task . Clean, InstallDependencies