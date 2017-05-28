$ModuleName = 'PSCodeHealth'
Import-Module "$PSScriptRoot\..\..\..\$ModuleName\$($ModuleName).psd1" -Force

Describe 'Get-SwitchCombination' {
    InModuleScope $ModuleName {

        Context 'The input integer is equal to 1' {

            $Result = Get-SwitchCombination -Integer 1

            It 'Should return an object of the type [System.Int32]' {
                $Result | Should BeOfType [System.Int32]
            }
            It 'Should return the value 1' {
                $Result | Should Be 1
            }
        }
        Context 'The input integer is equal to 5' {

            $Result = Get-SwitchCombination -Integer 5

            It 'Should return an object of the type [System.Int32]' {
                $Result | Should BeOfType [System.Int32]
            }
            It 'Should return the value 1' {
                $Result | Should Be 32
            }
        }
        Context 'The input integer is equal to 9' {

            $Result = Get-SwitchCombination -Integer 9

            It 'Should return an object of the type [System.Int32]' {
                $Result | Should BeOfType [System.Int32]
            }
            It 'Should return the value 1' {
                $Result | Should Be 512
            }
        }
        Context 'The factorial result is greater than the maximum Int32 value' {

            $Result = Get-SwitchCombination -Integer 31

            It 'Should return an object of the type [System.Int32]' {
                $Result | Should BeOfType [System.Int32]
            }
            It 'Should return the maximum Int32 value' {
                $Result | Should Be ([System.Int32]::MaxValue)
            }
        }
    }
}