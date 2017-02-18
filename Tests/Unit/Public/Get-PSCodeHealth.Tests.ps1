$ModuleName = 'PSCodeHealth'
Import-Module "$($PSScriptRoot)\..\..\..\$($ModuleName).psd1" -Force

Describe 'Get-PSCodeHealth' {
    InModuleScope $ModuleName {

        $Mocks = ConvertFrom-Json (Get-Content -Path "$($PSScriptRoot)\..\TestData\MockObjects.json" -Raw )
        $ScriptPath = $PSScriptRoot

        Context 'Get-PowerShellFile return 0 file' {

            Mock Get-PowerShellFile { $Null }
            $Results = Get-PSCodeHealth -Path "$PSScriptRoot\..\TestData"

            It 'Should not throw and return $Null' {
                $Results | Should Be $Null
            }
        }

        Context 'Get-PowerShellFile returns 1 file' {

            Mock Get-PowerShellFile { "$ScriptPath\..\TestData\2PublicFunctions.psm1" }
            $Results = Get-PSCodeHealth -Path "$PSScriptRoot\..\TestData"

            It 'Should return objects of the type [PSCodeHealth.Function.HealthRecord]' {
                Foreach ( $Result in $Results ) {
                    $Result | Should BeOfType [PSCustomObject]
                    ($Result | Get-Member).TypeName | Should Be 'PSCodeHealth.Function.HealthRecord'
                }
            }
            It 'Should throw if the specified Path does not exist'  {
                { Get-PSCodeHealth -Path 'Any' } |
                Should Throw
            }
            It 'Should remove TestsPath from $PSBoundParameters before calling Get-PowerShellFile' {
                Mock Get-PowerShellFile { "$ScriptPath\..\TestData\2PublicFunctions.psm1" }
                { Get-PSCodeHealth -Path "$PSScriptRoot\..\TestData" -TestsPath "$PSScriptRoot\..\TestData" } |
                Should Not Throw
            }
        }

        Context 'Get-PowerShellFile returns 2 files' {

            Mock Get-PowerShellFile { (Get-ChildItem "$ScriptPath\..\TestData" -Filter '*.ps*1').FullName }
            $Results = Get-PSCodeHealth -Path "$PSScriptRoot\..\TestData"

            It 'Should return 1 object for every function in every file' {
                $Results.Count | Should Be 4
            }
        }
    }
}