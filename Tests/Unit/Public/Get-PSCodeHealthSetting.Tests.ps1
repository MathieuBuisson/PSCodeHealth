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
        Context 'No custom settings file is specified' {

            $Result = Get-PSCodeHealthSetting

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
        Context 'The value of the SettingsGroup parameter is "OverallHealthReportMetricsRules"' {

            $Result = Get-PSCodeHealthSetting -SettingsGroup OverallHealthReportMetricsRules

            It 'Should return an array of [PSCustomObject]' {
                ($Result | Get-Member).TypeName[0] | Should Be 'System.Management.Automation.PSCustomObject'
            }
            It 'Should return an object with "LinesOfCodeTotal" property' {
                $Result.LinesOfCodeTotal | Should Not BeNullOrEmpty
            }
            It 'Should return an object with "LinesOfCodeAverage" property' {
                $Result.LinesOfCodeAverage | Should Not BeNullOrEmpty
            }
            It 'Should return an object with "ScriptAnalyzerFindingsTotal" property' {
                $Result.ScriptAnalyzerFindingsTotal | Should Not BeNullOrEmpty
            }
            It 'Should return an object with "ScriptAnalyzerErrors" property' {
                $Result.ScriptAnalyzerErrors | Should Not BeNullOrEmpty
            }
            It 'Should return an object with "ScriptAnalyzerWarnings" property' {
                $Result.ScriptAnalyzerWarnings | Should Not BeNullOrEmpty
            }
            It 'Should return an object with "ScriptAnalyzerInformation" property' {
                $Result.ScriptAnalyzerInformation | Should Not BeNullOrEmpty
            }
            It 'Should return an object with "ScriptAnalyzerFindingsAverage" property' {
                $Result.ScriptAnalyzerFindingsAverage | Should Not BeNullOrEmpty
            }
            It 'Should return an object with "NumberOfFailedTests" property' {
                $Result.NumberOfFailedTests | Should Not BeNullOrEmpty
            }
            It 'Should return an object with "TestsPassRate" property' {
                $Result.TestsPassRate | Should Not BeNullOrEmpty
            }
            It 'Should return an object with "TestCoverage" property' {
                $Result.TestCoverage | Should Not BeNullOrEmpty
            }
            It 'Should return an object with "CommandsMissedTotal" property' {
                $Result.CommandsMissedTotal | Should Not BeNullOrEmpty
            }
            It 'Should return an object with "ComplexityAverage" property' {
                $Result.ComplexityAverage | Should Not BeNullOrEmpty
            }
            It 'Should return an object with "NestingDepthAverage" property' {
                $Result.NestingDepthAverage | Should Not BeNullOrEmpty
            }
        }
        Context 'The SettingsGroup and the MetricName parameters are both specified' {

            $Result = Get-PSCodeHealthSetting -SettingsGroup OverallHealthReportMetricsRules -MetricName TestCoverage

            It 'Should return 1 object of the type [PSCustomObject]' {
                $Result | Should BeOfType [PSCustomObject]
            }
            It 'Should return an object with the expected "WarningThreshold" property' {
                $Result.WarningThreshold | Should Be 80
            }
            It 'Should return an object with the expected "FailThreshold" property' {
                $Result.FailThreshold | Should Be 70
            }
        }
        Context 'The MetricName parameter is specified, but not the SettingsGroup parameter' {

            $Results = Get-PSCodeHealthSetting -MetricName TestCoverage

            It 'Should return 2 objects when the metric is present in both settings groups' {
                $Results.Count | Should Be 2
            }
            It 'Should return objects of the type [PSCustomObject]' {
                Foreach ( $Result in $Results ) {
                    $Result | Should BeOfType [PSCustomObject]
                }
            }
            It 'Should return objects with the expected "WarningThreshold" property' {
                Foreach ( $Result in $Results ) {
                    $Result.WarningThreshold | Should Be 80
                }
            }
            It 'Should return objects with the expected "FailThreshold" property' {
                Foreach ( $Result in $Results ) {
                    $Result.FailThreshold | Should Be 70
                }
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