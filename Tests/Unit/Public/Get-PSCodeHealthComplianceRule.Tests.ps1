$ModuleName = 'PSCodeHealth'
Import-Module "$PSScriptRoot\..\..\..\$ModuleName\$($ModuleName).psd1" -Force

Describe 'Get-PSCodeHealthComplianceRule' {
    InModuleScope $ModuleName {

        $DefaultSettings = ConvertFrom-Json (Get-Content -Path "$PSScriptRoot\..\..\..\PSCodeHealth\PSCodeHealthSettings.json" -Raw)

        Context 'The file specified via the CustomSettingsPath parameter does not contain valid JSON' {

            $InvalidJsonPath = "$PSScriptRoot\..\TestData\InvalidSettings.json"

            It 'Should throw "An error occurred when attempting to convert JSON data"' {
                { Get-PSCodeHealthComplianceRule -CustomSettingsPath $InvalidJsonPath } |
                Should Throw "An error occurred when attempting to convert JSON data "
            }
        }
        Context 'The file specified via the CustomSettingsPath parameter does not contain any data' {

            $EmptyJsonPath = "$PSScriptRoot\..\TestData\Empty.json"
            $Results = Get-PSCodeHealthComplianceRule -CustomSettingsPath $EmptyJsonPath

            It 'Should return objects of the type [PSCodeHealth.Compliance.Rule]' {
                Foreach ( $Result in $Results ) {
                    $Result | Should BeOfType [PSCustomObject]
                    ($Result | Get-Member).TypeName[0] | Should Be 'PSCodeHealth.Compliance.Rule'
                }
            }
            It 'Should return 5 objects where the SettingsGroup property is equal to "FunctionHealthRecordMetricsRules"' {
                $Results | Where-Object SettingsGroup -eq 'FunctionHealthRecordMetricsRules'
            }
            It 'Should return 13 objects where the SettingsGroup property is equal to "OverallHealthReportMetricsRules"' {
                $Results | Where-Object SettingsGroup -eq 'OverallHealthReportMetricsRules'
            }
            It 'Resulting compliance rules are the same as the defaults for metric "LinesOfCode"' {
                $LinesOfCodeResult = $Results | Where-Object MetricName -eq 'LinesOfCode'
                $LinesOfCodeResult.WarningThreshold | Should Be 20
                $LinesOfCodeResult.FailThreshold | Should Be 40
                $LinesOfCodeResult.HigherIsBetter | Should Be $False
            }
            It 'Resulting compliance rules are the same as the defaults for metric "TestCoverage"' {
                $TestCoverageResult = $Results | Where-Object MetricName -eq 'TestCoverage' | Where-Object SettingsGroup -eq 'FunctionHealthRecordMetricsRules'
                $TestCoverageResult.WarningThreshold | Should Be 80
                $TestCoverageResult.FailThreshold | Should Be 70
                $TestCoverageResult.HigherIsBetter | Should Be $True
            }
            It 'Resulting compliance rules are the same as the defaults for metric "Complexity"' {
                $ComplexityResult = $Results | Where-Object MetricName -eq Complexity
                $ComplexityResult.WarningThreshold | Should Be 15
                $ComplexityResult.FailThreshold | Should Be 30
                $ComplexityResult.HigherIsBetter | Should Be $False
            }
            It 'Resulting compliance rules are the same as the defaults for metric "TestsPassRate"' {
                $TestsPassRateResult = $Results | Where-Object MetricName -eq TestsPassRate
                $TestsPassRateResult.WarningThreshold | Should Be 99
                $TestsPassRateResult.FailThreshold | Should Be 97
                $TestsPassRateResult.HigherIsBetter | Should Be $True
            }
            It 'Resulting compliance rules are the same as the defaults for metric "LinesOfCodeTotal"' {
                $LinesOfCodeTotalResult = $Results | Where-Object MetricName -eq LinesOfCodeTotal
                $LinesOfCodeTotalResult.WarningThreshold | Should Be 1000
                $LinesOfCodeTotalResult.FailThreshold | Should Be 2000
                $LinesOfCodeTotalResult.HigherIsBetter | Should Be $False
            }
        }
        Context 'No custom settings file is specified' {

            $Results = Get-PSCodeHealthComplianceRule -CustomSettingsPath $EmptyJsonPath

            It 'Should return objects of the type [PSCodeHealth.Compliance.Rule]' {
                Foreach ( $Result in $Results ) {
                    $Result | Should BeOfType [PSCustomObject]
                    ($Result | Get-Member).TypeName[0] | Should Be 'PSCodeHealth.Compliance.Rule'
                }
            }
            It 'Should return 5 objects where the SettingsGroup property is equal to "FunctionHealthRecordMetricsRules"' {
                $Results | Where-Object SettingsGroup -eq 'FunctionHealthRecordMetricsRules'
            }
            It 'Should return 13 objects where the SettingsGroup property is equal to "OverallHealthReportMetricsRules"' {
                $Results | Where-Object SettingsGroup -eq 'OverallHealthReportMetricsRules'
            }
            It 'Resulting compliance rules are the same as the defaults for metric "LinesOfCode"' {
                $LinesOfCodeResult = $Results | Where-Object MetricName -eq 'LinesOfCode'
                $LinesOfCodeResult.WarningThreshold | Should Be 20
                $LinesOfCodeResult.FailThreshold | Should Be 40
                $LinesOfCodeResult.HigherIsBetter | Should Be $False
            }
            It 'Resulting compliance rules are the same as the defaults for metric "TestCoverage"' {
                $TestCoverageResult = $Results | Where-Object MetricName -eq 'TestCoverage' | Where-Object SettingsGroup -eq 'FunctionHealthRecordMetricsRules'
                $TestCoverageResult.WarningThreshold | Should Be 80
                $TestCoverageResult.FailThreshold | Should Be 70
                $TestCoverageResult.HigherIsBetter | Should Be $True
            }
            It 'Resulting compliance rules are the same as the defaults for metric "Complexity"' {
                $ComplexityResult = $Results | Where-Object MetricName -eq Complexity
                $ComplexityResult.WarningThreshold | Should Be 15
                $ComplexityResult.FailThreshold | Should Be 30
                $ComplexityResult.HigherIsBetter | Should Be $False
            }
            It 'Resulting compliance rules are the same as the defaults for metric "TestsPassRate"' {
                $TestsPassRateResult = $Results | Where-Object MetricName -eq TestsPassRate
                $TestsPassRateResult.WarningThreshold | Should Be 99
                $TestsPassRateResult.FailThreshold | Should Be 97
                $TestsPassRateResult.HigherIsBetter | Should Be $True
            }
            It 'Resulting compliance rules are the same as the defaults for metric "LinesOfCodeTotal"' {
                $LinesOfCodeTotalResult = $Results | Where-Object MetricName -eq LinesOfCodeTotal
                $LinesOfCodeTotalResult.WarningThreshold | Should Be 1000
                $LinesOfCodeTotalResult.FailThreshold | Should Be 2000
                $LinesOfCodeTotalResult.HigherIsBetter | Should Be $False
            }
        }
        <#Context 'The value of the SettingsGroup parameter is "OverallHealthReportMetricsRules"' {

            $Result = Get-PSCodeHealthComplianceRule -SettingsGroup OverallHealthReportMetricsRules

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

            $Result = Get-PSCodeHealthComplianceRule -SettingsGroup OverallHealthReportMetricsRules -MetricName TestCoverage

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

            $Results = Get-PSCodeHealthComplianceRule -MetricName TestCoverage

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
            $Result = Get-PSCodeHealthComplianceRule -CustomSettingsPath $MetricsInBothGroups

            It 'Should return an object of the type [PSCustomObject]' {
                $Result | Should BeOfType [PSCustomObject]
            }
            It 'Resulting compliance rules are the same as the defaults for metric "LinesOfCode"' {
                $Result.FunctionHealthRecordMetricsRules.LinesOfCode.WarningThreshold | Should Be 20
                $Result.FunctionHealthRecordMetricsRules.LinesOfCode.FailThreshold | Should Be 40
            }
            It 'Resulting compliance rules are the same as the defaults for metric "TestCoverage"' {
                $Result.FunctionHealthRecordMetricsRules.TestCoverage.WarningThreshold | Should Be 80
                $Result.FunctionHealthRecordMetricsRules.TestCoverage.FailThreshold | Should Be 70
            }
            It 'Resulting compliance rules override the defaults for metric "Complexity"' {
                $Result.FunctionHealthRecordMetricsRules.Complexity.WarningThreshold | Should Be 17
                $Result.FunctionHealthRecordMetricsRules.Complexity.FailThreshold | Should Be 33
            }
            It 'Resulting compliance rules override the defaults for metric "MaximumNestingDepth"' {
                $Result.FunctionHealthRecordMetricsRules.MaximumNestingDepth.WarningThreshold | Should Be 6
                $Result.FunctionHealthRecordMetricsRules.MaximumNestingDepth.FailThreshold | Should Be 12
            }
            It 'Resulting compliance rules are the same as the defaults for metric "TestsPassRate"' {
                $Result.OverallHealthReportMetricsRules.TestsPassRate.WarningThreshold | Should Be 99
                $Result.OverallHealthReportMetricsRules.TestsPassRate.FailThreshold | Should Be 97
            }
            It 'Resulting compliance rules are the same as the defaults for metric "CommandsMissedTotal"' {
                $Result.OverallHealthReportMetricsRules.CommandsMissedTotal.WarningThreshold | Should Be 20
                $Result.OverallHealthReportMetricsRules.CommandsMissedTotal.FailThreshold | Should Be 40
            }
            It 'Resulting compliance rules override the defaults for metric "LinesOfCodeTotal"' {
                $Result.OverallHealthReportMetricsRules.LinesOfCodeTotal.WarningThreshold | Should Be 1500
                $Result.OverallHealthReportMetricsRules.LinesOfCodeTotal.FailThreshold | Should Be 3000
            }
            It 'Resulting compliance rules override the defaults for metric "LinesOfCodeAverage"' {
                $Result.OverallHealthReportMetricsRules.LinesOfCodeAverage.WarningThreshold | Should Be 21
                $Result.OverallHealthReportMetricsRules.LinesOfCodeAverage.FailThreshold | Should Be 42
            }
        }#>
        Remove-Variable -Name 'DefaultSettings' -Force -ErrorAction SilentlyContinue
    }
}