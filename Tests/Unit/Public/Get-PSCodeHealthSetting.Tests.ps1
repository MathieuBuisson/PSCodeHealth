$ModuleName = 'PSCodeHealth'
Import-Module "$PSScriptRoot\..\..\..\$ModuleName\$($ModuleName).psd1" -Force

Describe 'Get-PSCodeHealthSetting' {
    InModuleScope $ModuleName {

        $DefaultSettings = ConvertFrom-Json (Get-Content -Path "$PSScriptRoot\..\..\..\PSCodeHealth\PSCodeHealthSettings.json" -Raw)

        Context 'The file specified via the CustomSettingsPath parameter does not contain valid JSON' {

            $InvalidJsonPath = "$PSScriptRoot\..\TestData\InvalidSettings.json"

            It 'Should throw "An error occurred when attempting to convert JSON data"' {
                { Get-PSCodeHealthSetting -CustomSettingsPath $InvalidJsonPath } |
                Should Throw "An error occurred when attempting to convert JSON data "
            }
        }
        Context 'The file specified via the CustomSettingsPath parameter does not contain any data' {

            $EmptyJsonPath = "$PSScriptRoot\..\TestData\Empty.json"
            $Result = Get-PSCodeHealthSetting -CustomSettingsPath $EmptyJsonPath

            It 'Should return an object of the type [PSCustomObject]' {
                $Result | Should BeOfType [PSCustomObject]
            }
            It 'Resulting settings are the same as the defaults for metric "LinesOfCode"' {
                $Result.FunctionHealthRecordMetricsRules.LinesOfCode.WarningThreshold | Should Be 20
                $Result.FunctionHealthRecordMetricsRules.LinesOfCode.FailThreshold | Should Be 40
            }
            It 'Resulting settings are the same as the defaults for metric "TestCoverage"' {
                $Result.FunctionHealthRecordMetricsRules.TestCoverage.WarningThreshold | Should Be 80
                $Result.FunctionHealthRecordMetricsRules.TestCoverage.FailThreshold | Should Be 70
            }
            It 'Resulting settings are the same as the defaults for metric "Complexity"' {
                $Result.FunctionHealthRecordMetricsRules.Complexity.WarningThreshold | Should Be 15
                $Result.FunctionHealthRecordMetricsRules.Complexity.FailThreshold | Should Be 30
            }
            It 'Resulting settings are the same as the defaults for metric "MaximumNestingDepth"' {
                $Result.FunctionHealthRecordMetricsRules.MaximumNestingDepth.WarningThreshold | Should Be 4
                $Result.FunctionHealthRecordMetricsRules.MaximumNestingDepth.FailThreshold | Should Be 8
            }
            It 'Resulting settings are the same as the defaults for metric "TestsPassRate"' {
                $Result.OverallHealthReportMetricsRules.TestsPassRate.WarningThreshold | Should Be 99
                $Result.OverallHealthReportMetricsRules.TestsPassRate.FailThreshold | Should Be 97
            }
            It 'Resulting settings are the same as the defaults for metric "LinesOfCodeTotal"' {
                $Result.OverallHealthReportMetricsRules.LinesOfCodeTotal.WarningThreshold | Should Be 1000
                $Result.OverallHealthReportMetricsRules.LinesOfCodeTotal.FailThreshold | Should Be 2000
            }
        }
        Context 'The custom settings file contains 2 metrics in both settings groups' {

            $MetricsInBothGroups = "$PSScriptRoot\..\TestData\2SettingsGroups4Metrics.json"
            $Result = Get-PSCodeHealthSetting -CustomSettingsPath $MetricsInBothGroups

            It 'Should return an object of the type [PSCustomObject]' {
                $Result | Should BeOfType [PSCustomObject]
            }
            It 'Resulting settings are the same as the defaults for metric "LinesOfCode"' {
                $Result.FunctionHealthRecordMetricsRules.LinesOfCode.WarningThreshold | Should Be 20
                $Result.FunctionHealthRecordMetricsRules.LinesOfCode.FailThreshold | Should Be 40
            }
            It 'Resulting settings are the same as the defaults for metric "TestCoverage"' {
                $Result.FunctionHealthRecordMetricsRules.TestCoverage.WarningThreshold | Should Be 80
                $Result.FunctionHealthRecordMetricsRules.TestCoverage.FailThreshold | Should Be 70
            }
            It 'Resulting settings override the defaults for metric "Complexity"' {
                $Result.FunctionHealthRecordMetricsRules.Complexity.WarningThreshold | Should Be 17
                $Result.FunctionHealthRecordMetricsRules.Complexity.FailThreshold | Should Be 33
            }
            It 'Resulting settings override the defaults for metric "MaximumNestingDepth"' {
                $Result.FunctionHealthRecordMetricsRules.MaximumNestingDepth.WarningThreshold | Should Be 6
                $Result.FunctionHealthRecordMetricsRules.MaximumNestingDepth.FailThreshold | Should Be 12
            }
            It 'Resulting settings are the same as the defaults for metric "TestsPassRate"' {
                $Result.OverallHealthReportMetricsRules.TestsPassRate.WarningThreshold | Should Be 99
                $Result.OverallHealthReportMetricsRules.TestsPassRate.FailThreshold | Should Be 97
            }
            It 'Resulting settings are the same as the defaults for metric "CommandsMissedTotal"' {
                $Result.OverallHealthReportMetricsRules.CommandsMissedTotal.WarningThreshold | Should Be 20
                $Result.OverallHealthReportMetricsRules.CommandsMissedTotal.FailThreshold | Should Be 40
            }
            It 'Resulting settings override the defaults for metric "LinesOfCodeTotal"' {
                $Result.OverallHealthReportMetricsRules.LinesOfCodeTotal.WarningThreshold | Should Be 1500
                $Result.OverallHealthReportMetricsRules.LinesOfCodeTotal.FailThreshold | Should Be 3000
            }
            It 'Resulting settings override the defaults for metric "LinesOfCodeAverage"' {
                $Result.OverallHealthReportMetricsRules.LinesOfCodeAverage.WarningThreshold | Should Be 21
                $Result.OverallHealthReportMetricsRules.LinesOfCodeAverage.FailThreshold | Should Be 42
            }
        }
        Remove-Variable -Name 'DefaultSettings' -Force -ErrorAction SilentlyContinue
    }
}