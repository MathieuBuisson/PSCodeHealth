$ModuleName = 'PSCodeHealth'
Import-Module "$PSScriptRoot\..\..\..\$ModuleName\$($ModuleName).psd1" -Force

Describe 'New-PSCodeHealthComplianceRule' {
    InModuleScope $ModuleName {

    $MetricsRules = ConvertFrom-Json (Get-Content -Path "$PSScriptRoot\..\TestData\2SettingsGroups4Metrics.json" -Raw) | Where-Object { $_ }
    $FunctionMetricMaximumNestingDepth = $MetricsRules.PerFunctionMetrics | Where-Object { $_.MaximumNestingDepth }
    $OverallMetricLinesOfCodeTotal = $MetricsRules.OverallMetrics | Where-Object { $_.LinesOfCodeTotal }

        Context 'The specified SettingsGroup is PerFunctionMetrics' {

            $Result = New-PSCodeHealthComplianceRule -MetricRule $FunctionMetricMaximumNestingDepth -SettingsGroup PerFunctionMetrics

            It 'Should return an object of the type [PSCodeHealth.Compliance.Rule]' {
                $Result | Should BeOfType [PSCustomObject]
                ($Result | Get-Member).TypeName[0] | Should Be 'PSCodeHealth.Compliance.Rule'
            }
            It 'Should return an object with the expected property "SettingsGroup"' {
                $Result.SettingsGroup | Should Be 'PerFunctionMetrics'
            }
            It 'Should return an object with the expected property "MetricName"' {
                $Result.MetricName | Should Be 'MaximumNestingDepth'
            }
            It 'Should return an object with the expected property "WarningThreshold"' {
                $Result.WarningThreshold | Should Be 6
            }
            It 'Should return an object with the expected property "FailThreshold"' {
                $Result.FailThreshold | Should Be 12
            }
            It 'Should return an object with the expected property "HigherIsBetter"' {
                $Result.HigherIsBetter | Should Be $False
            }
        }
        Context 'The specified SettingsGroup is PerFunctionMetrics' {

            $Result = New-PSCodeHealthComplianceRule -MetricRule $OverallMetricLinesOfCodeTotal -SettingsGroup OverallMetrics

            It 'Should return an object of the type [PSCodeHealth.Compliance.Rule]' {
                $Result | Should BeOfType [PSCustomObject]
                ($Result | Get-Member).TypeName[0] | Should Be 'PSCodeHealth.Compliance.Rule'
            }
            It 'Should return an object with the expected property "SettingsGroup"' {
                $Result.SettingsGroup | Should Be 'OverallMetrics'
            }
            It 'Should return an object with the expected property "MetricName"' {
                $Result.MetricName | Should Be 'LinesOfCodeTotal'
            }
            It 'Should return an object with the expected property "WarningThreshold"' {
                $Result.WarningThreshold | Should Be 1500
            }
            It 'Should return an object with the expected property "FailThreshold"' {
                $Result.FailThreshold | Should Be 3000
            }
            It 'Should return an object with the expected property "HigherIsBetter"' {
                $Result.HigherIsBetter | Should Be $False
            }
        }
    }
}