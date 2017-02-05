$ModuleName = 'PSCodeHealthMetrics'
Import-Module "$($PSScriptRoot)\..\..\$($ModuleName).psd1" -Force

Describe 'General Module behaviour' {
       
    $ModuleInfo = Get-Module -Name $ModuleName

    It 'The required modules should be Pester and PSScriptAnalyzer' {
        
        Foreach ( $RequiredModule in $ModuleInfo.RequiredModules.Name ) {
            $RequiredModule -in @('Pester','PSScriptAnalyzer') | Should Be $True
        }
    }
}

Describe 'Get-ModulePowerShellScripts' {

    InModuleScope $ModuleName {
        
        New-Item -Path TestDrive:\Module -ItemType Directory
        New-Item -Path TestDrive:\Module\Module.psd1 -ItemType File
        New-Item -Path TestDrive:\Module\SubFolder -ItemType Directory
        New-Item -Path TestDrive:\Module\SubFolder\Module.psm1 -ItemType File
        New-Item -Path TestDrive:\Module\SubFolder\Module.ps1 -ItemType File
        New-Item -Path TestDrive:\Module\SubFolder\Module.Tests.ps1 -ItemType File
        Mock Import-Module { [PSCustomObject]@{ ModuleBase = 'TestDrive:\Module' } }

        $Results = Get-ModulePowerShellScripts -Name 'Module'

        It 'Should return strings' {
            Foreach ( $Result in $Results ) {
                $Result | Should BeOfType [string]
            }
        }
        It 'Should return only files with a .ps*1 extension' {
            Foreach ( $Result in $Results ) {
                $Result | Should BeLike '*.ps*1'
            }
        }
        It 'Should not return any script with "*Tests*" in their name or path' {
            $Results | Where { $_ -like "*Tests*" } | Should BeNullOrEmpty
        }
        It 'Should not return any file with the .psd1 extension' {
            $Results | Where { $_ -like "*psd1" } | Should BeNullOrEmpty
        }
    }
}