$ModuleName = 'PSCodeHealth'
Import-Module "$PSScriptRoot\..\..\..\$ModuleName\$($ModuleName).psd1" -Force

Describe 'Get-PowerShellFile' {
    InModuleScope $ModuleName {
        
        New-Item -Path TestDrive:\Module -ItemType Directory
        New-Item -Path TestDrive:\Module\Module.psd1 -ItemType File
        New-Item -Path TestDrive:\Module\SubFolder -ItemType Directory
        New-Item -Path TestDrive:\Module\SubFolder\Module.psm1 -ItemType File
        New-Item -Path TestDrive:\Module\SubFolder\Module.psd1 -ItemType File
        New-Item -Path TestDrive:\Module\SubFolder\Module.ps1 -ItemType File
        New-Item -Path TestDrive:\Module\SubFolder\Module.Tests.ps1 -ItemType File
        New-Item -Path TestDrive:\Module\SubFolder\Exclude.ps1 -ItemType File

        Context 'Get-PowerShellFile without the Exclude Parameter' {

            $Results = Get-PowerShellFile -Path TestDrive:\Module -Recurse
            $PipelineInputResults = 'TestDrive:\Module' | Get-PowerShellFile

            It 'Should return strings' {
                Foreach ( $Result in $Results ) {
                    $Result | Should BeOfType [string]
                }
            }
            It 'Should work with the Path input from the pipeline' {
                Foreach ( $Result in $PipelineInputResults ) {
                    $PipelineInputResults | Should BeOfType [string]
                }
            }
            It 'Should return only files with a .ps*1 extension' {
                Foreach ( $Result in $Results ) {
                    $Result | Should BeLike '*.ps*1'
                }
            }
            It 'Should not return any script with "*Tests*" in their name or path' {
                $Results | Where-Object { $_ -like "*Tests*" } | Should BeNullOrEmpty
            }
            It 'Should not return any file from subdirectories without the Recurse parameter' {
                $PipelineInputResults.Count | Should Be 1
            }
            It 'Should return any file from directory and all subdirectories with the Recurse parameter' {
                $Results.Count | Should Be 5
            }
        }
        Context 'Get-PowerShellFile with the Exclude Parameter' {
            
            $Results = Get-PowerShellFile -Path TestDrive:\Module -Recurse -Exclude "Exclude*"

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
            It 'Should not return any file with "*Tests*" in their name or path' {
                $Results | Where-Object { $_ -like "*Tests*" } | Should BeNullOrEmpty
            }
            It 'Should return any file from directory and all subdirectories with the Recurse parameter' {
                $Results.Count | Should Be 4
            }
            It 'Should not return any file with the name starting with "Exclude"' {
                $Results | Where-Object { $_ -like "Exclude*" } | Should BeNullOrEmpty
            }
        }
    }
}
