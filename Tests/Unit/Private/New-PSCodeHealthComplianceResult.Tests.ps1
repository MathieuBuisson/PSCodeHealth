$ModuleName = 'PSCodeHealth'
Import-Module "$PSScriptRoot\..\..\..\$ModuleName\$($ModuleName).psd1" -Force

Describe 'New-PSCodeHealthComplianceResult' {
    InModuleScope $ModuleName {

    $ComplianceRule = Get-PSCodeHealthComplianceRule -MetricName Complexity

        Context 'The specified Value is Null' {

            It 'Should throw' {
                { New-PSCodeHealthComplianceResult -ComplianceRule $ComplianceRule -Value $Null -Result 'Pass' } |
                Should Throw
            }
        }
        Context 'The specified value is an [int32]' {

            $Result = New-PSCodeHealthComplianceResult -ComplianceRule $ComplianceRule -Value (10 -as [int32]) -Result 'Pass'

            It 'Should return an object of the type [PSCodeHealth.Compliance.Result]' {
                $Result | Should BeOfType [PSCustomObject]
                ($Result | Get-Member).TypeName[0] | Should Be 'PSCodeHealth.Compliance.Result'
            }
            It 'Should return an object with the expected property "SettingsGroup"' {
                $Result.SettingsGroup | Should Be 'PerFunctionMetrics'
            }
            It 'Should return an object with the expected property "MetricName"' {
                $Result.MetricName | Should Be 'Complexity'
            }
            It 'Should return an object with the expected property "WarningThreshold"' {
                $Result.WarningThreshold | Should Be 15
            }
            It 'Should return an object with the expected property "FailThreshold"' {
                $Result.FailThreshold | Should Be 30
            }
            It 'Should return an object with the expected property "HigherIsBetter"' {
                $Result.HigherIsBetter | Should Be $False
            }
            It 'Should return an object with the expected property "Value"' {
                $Result.Value | Should Be 10
            }
            It 'Should return an object with the expected property "Result"' {
                $Result.Result | Should Be 'Pass'
            }
        }
        Context 'The specified value is an [double]' {

            $Result = New-PSCodeHealthComplianceResult -ComplianceRule $ComplianceRule -Value (89.17 -as [double]) -Result 'Fail'

            It 'Should return an object of the type [PSCodeHealth.Compliance.Result]' {
                $Result | Should BeOfType [PSCustomObject]
                ($Result | Get-Member).TypeName[0] | Should Be 'PSCodeHealth.Compliance.Result'
            }
            It 'Should return an object with the expected property "SettingsGroup"' {
                $Result.SettingsGroup | Should Be 'PerFunctionMetrics'
            }
            It 'Should return an object with the expected property "MetricName"' {
                $Result.MetricName | Should Be 'Complexity'
            }
            It 'Should return an object with the expected property "WarningThreshold"' {
                $Result.WarningThreshold | Should Be 15
            }
            It 'Should return an object with the expected property "FailThreshold"' {
                $Result.FailThreshold | Should Be 30
            }
            It 'Should return an object with the expected property "HigherIsBetter"' {
                $Result.HigherIsBetter | Should Be $False
            }
            It 'Should return an object with the expected property "Value"' {
                $Result.Value | Should Be 89.17
            }
            It 'Should return an object with the expected property "Result"' {
                $Result.Result | Should Be 'Fail'
            }
        }
        Context 'The specified value is an [string] and the specified result is "Warning"' {

            $Result = New-PSCodeHealthComplianceResult -ComplianceRule $ComplianceRule -Value (89.17 -as [string]) -Result 'Warning'

            It 'Should return an object of the type [PSCodeHealth.Compliance.Result]' {
                $Result | Should BeOfType [PSCustomObject]
                ($Result | Get-Member).TypeName[0] | Should Be 'PSCodeHealth.Compliance.Result'
            }
            It 'Should return an object with the expected property "SettingsGroup"' {
                $Result.SettingsGroup | Should Be 'PerFunctionMetrics'
            }
            It 'Should return an object with the expected property "MetricName"' {
                $Result.MetricName | Should Be 'Complexity'
            }
            It 'Should return an object with the expected property "WarningThreshold"' {
                $Result.WarningThreshold | Should Be 15
            }
            It 'Should return an object with the expected property "FailThreshold"' {
                $Result.FailThreshold | Should Be 30
            }
            It 'Should return an object with the expected property "HigherIsBetter"' {
                $Result.HigherIsBetter | Should Be $False
            }
            It 'Should return an object with the expected property "Value"' {
                $Result.Value | Should Be '89.17'
            }
            It 'Should return an object with the expected property "Result"' {
                $Result.Result | Should Be 'Warning'
            }
        }
    }
}