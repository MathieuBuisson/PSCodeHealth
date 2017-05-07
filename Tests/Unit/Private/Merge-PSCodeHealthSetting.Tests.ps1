$ModuleName = 'PSCodeHealth'
Import-Module "$PSScriptRoot\..\..\..\$ModuleName\$($ModuleName).psd1" -Force

Describe 'Merge-PSCodeHealthSetting' {
    InModuleScope $ModuleName {

        $DefaultSettings = ConvertFrom-Json (Get-Content -Path "$PSScriptRoot\..\..\..\PSCodeHealth\PSCodeHealthSettings.json" -Raw)

        Context 'Custom settings do not contain any data' {

            $CustomSettings = ConvertFrom-Json (Get-Content -Path "$PSScriptRoot\..\TestData\Empty.json" -Raw )
            $Result = Merge-PSCodeHealthSetting -DefaultSettings $DefaultSettings -CustomSettings $CustomSettings

            It 'Should return an object of the type [PSCustomObject]' {
                $Result | Should BeOfType [PSCustomObject]
            }
            It 'Should return an object with the expected property "FunctionHealthRecordMetricsRules"' {
                $Result.FunctionHealthRecordMetricsRules | Should Be $DefaultSettings.FunctionHealthRecordMetricsRules
            }
            It 'Should return an object with the expected property "OverallHealthReportMetricsRules"' {
                $Result.OverallHealthReportMetricsRules | Should Be $DefaultSettings.OverallHealthReportMetricsRules
            }
        }
        Context 'Custom settings do not contain any of the expected settings groups' {

            $CustomSettings = ConvertFrom-Json (Get-Content -Path "$PSScriptRoot\..\TestData\NoSettingsGroup.json" -Raw )
            $Result = Merge-PSCodeHealthSetting -DefaultSettings $DefaultSettings -CustomSettings $CustomSettings
            
            It 'Should return an object of the type [PSCustomObject]' {
                $Result | Should BeOfType [PSCustomObject]
            }
            It 'Should return an object with the expected property "FunctionHealthRecordMetricsRules"' {
                $Result.FunctionHealthRecordMetricsRules | Should Be $DefaultSettings.FunctionHealthRecordMetricsRules
            }
            It 'Should return an object with the expected property "OverallHealthReportMetricsRules"' {
                $Result.OverallHealthReportMetricsRules | Should Be $DefaultSettings.OverallHealthReportMetricsRules
            }
        }
        Context 'Custom settings contains only expected settings groups and metrics' {

            $CustomSettings = ConvertFrom-Json (Get-Content -Path "$PSScriptRoot\..\TestData\2SettingsGroups4Metrics.json" -Raw )
            $Result = Merge-PSCodeHealthSetting -DefaultSettings $DefaultSettings -CustomSettings $CustomSettings
            
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
        Context 'Custom settings contains expected settings groups but contains metrics absent from the defaults' {

            $DefaultSettings = ConvertFrom-Json (Get-Content -Path "$PSScriptRoot\..\..\..\PSCodeHealth\PSCodeHealthSettings.json" -Raw)
            $CustomSettings = ConvertFrom-Json (Get-Content -Path "$PSScriptRoot\..\TestData\NewMetrics.json" -Raw )
            $Result = Merge-PSCodeHealthSetting -DefaultSettings $DefaultSettings -CustomSettings $CustomSettings
            
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
            It 'Resulting settings are the same as the defaults for metric "CommandsMissedTotal"' {
                $Result.OverallHealthReportMetricsRules.CommandsMissedTotal.WarningThreshold | Should Be 20
                $Result.OverallHealthReportMetricsRules.CommandsMissedTotal.FailThreshold | Should Be 40
            }
            It 'Resulting settings are the same as the defaults for metric "LinesOfCodeTotal"' {
                $Result.OverallHealthReportMetricsRules.LinesOfCodeTotal.WarningThreshold | Should Be 1000
                $Result.OverallHealthReportMetricsRules.LinesOfCodeTotal.FailThreshold | Should Be 2000
            }
            It 'Resulting settings are the same as the defaults for metric "LinesOfCodeAverage"' {
                $Result.OverallHealthReportMetricsRules.LinesOfCodeAverage.WarningThreshold | Should Be 20
                $Result.OverallHealthReportMetricsRules.LinesOfCodeAverage.FailThreshold | Should Be 40
            }
            It 'Resulting settings have metric absent from the defaults : "DummyMetric"' {
                $Result.FunctionHealthRecordMetricsRules.DummyMetric.WarningThreshold | Should Be 2
                $Result.FunctionHealthRecordMetricsRules.DummyMetric.FailThreshold | Should Be 4
            }
            It 'Resulting settings have metric absent from the defaults : "DummyMetric2"' {
                $Result.OverallHealthReportMetricsRules.DummyMetric2.WarningThreshold | Should Be 7
                $Result.OverallHealthReportMetricsRules.DummyMetric2.FailThreshold | Should Be 8
            }
        }
    }
}