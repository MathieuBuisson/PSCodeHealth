$ModuleName = 'PSCodeHealth'
Import-Module "$PSScriptRoot\..\..\..\$ModuleName\$($ModuleName).psd1" -Force

Describe 'Get-PSCodeHealthComplianceRule' {
    InModuleScope $ModuleName {

        Context 'The file specified via the CustomSettingsPath parameter does not contain valid JSON' {

            $InvalidJsonPath = "$PSScriptRoot\..\..\TestData\InvalidSettings.json"

            It 'Should throw "An error occurred when attempting to convert JSON data"' {
                { Get-PSCodeHealthComplianceRule -CustomSettingsPath $InvalidJsonPath } |
                Should Throw "An error occurred when attempting to convert JSON data "
            }
        }
        Context 'The file specified via the CustomSettingsPath parameter does not contain any data' {

            $EmptyJsonPath = "$PSScriptRoot\..\..\TestData\Empty.json"
            $Results = Get-PSCodeHealthComplianceRule -CustomSettingsPath $EmptyJsonPath

            It 'Should return objects of the type [PSCodeHealth.Compliance.Rule]' {
                Foreach ( $Result in $Results ) {
                    $Result | Should BeOfType [PSCustomObject]
                    ($Result | Get-Member).TypeName[0] | Should Be 'PSCodeHealth.Compliance.Rule'
                }
            }
            It 'Should return 5 objects where the SettingsGroup property is equal to "PerFunctionMetrics"' {
                ($Results | Where-Object SettingsGroup -eq 'PerFunctionMetrics').Count |
                Should Be 6
            }
            It 'Should return 13 objects where the SettingsGroup property is equal to "OverallMetrics"' {
                ($Results | Where-Object SettingsGroup -eq 'OverallMetrics').Count |
                Should Be 13
            }
            It 'Resulting compliance rules are the same as the defaults for metric "LinesOfCode"' {
                $LinesOfCodeResult = $Results | Where-Object MetricName -eq 'LinesOfCode'
                $LinesOfCodeResult.WarningThreshold | Should Be 30
                $LinesOfCodeResult.FailThreshold | Should Be 60
                $LinesOfCodeResult.HigherIsBetter | Should Be $False
            }
            It 'Resulting compliance rules are the same as the defaults for metric "TestCoverage"' {
                $TestCoverageResult = $Results | Where-Object MetricName -eq 'TestCoverage' | Where-Object SettingsGroup -eq 'PerFunctionMetrics'
                $TestCoverageResult.WarningThreshold | Should Be 80
                $TestCoverageResult.FailThreshold | Should Be 70
                $TestCoverageResult.HigherIsBetter | Should Be $True
            }
            It 'Resulting compliance rules are the same as the defaults for metric "CommandsMissed"' {
                $CommandsMissedResult = $Results | Where-Object MetricName -eq CommandsMissed
                $CommandsMissedResult.WarningThreshold | Should Be 6
                $CommandsMissedResult.FailThreshold | Should Be 12
                $CommandsMissedResult.HigherIsBetter | Should Be $False
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
            It 'Should return 2 objects for the MetricName "TestCoverage" because this metric is present in both groups' {
                ($Results | Where-Object MetricName -eq 'TestCoverage').Count |
                Should Be 2
            }
        }
        Context 'No custom settings file is specified' {

            $Results = Get-PSCodeHealthComplianceRule

            It 'Should return objects of the type [PSCodeHealth.Compliance.Rule]' {
                Foreach ( $Result in $Results ) {
                    $Result | Should BeOfType [PSCustomObject]
                    ($Result | Get-Member).TypeName[0] | Should Be 'PSCodeHealth.Compliance.Rule'
                }
            }
            It 'Should return 5 objects where the SettingsGroup property is equal to "PerFunctionMetrics"' {
                ($Results | Where-Object SettingsGroup -eq 'PerFunctionMetrics').Count |
                Should Be 6
            }
            It 'Should return 13 objects where the SettingsGroup property is equal to "OverallMetrics"' {
                ($Results | Where-Object SettingsGroup -eq 'OverallMetrics').Count |
                Should Be 13
            }
            It 'Resulting compliance rules are the same as the defaults for metric "LinesOfCode"' {
                $LinesOfCodeResult = $Results | Where-Object MetricName -eq 'LinesOfCode'
                $LinesOfCodeResult.WarningThreshold | Should Be 30
                $LinesOfCodeResult.FailThreshold | Should Be 60
                $LinesOfCodeResult.HigherIsBetter | Should Be $False
            }
            It 'Resulting compliance rules are the same as the defaults for metric "TestCoverage"' {
                $TestCoverageResult = $Results | Where-Object MetricName -eq 'TestCoverage' | Where-Object SettingsGroup -eq 'PerFunctionMetrics'
                $TestCoverageResult.WarningThreshold | Should Be 80
                $TestCoverageResult.FailThreshold | Should Be 70
                $TestCoverageResult.HigherIsBetter | Should Be $True
            }
            It 'Resulting compliance rules are the same as the defaults for metric "CommandsMissed"' {
                $CommandsMissedResult = $Results | Where-Object MetricName -eq CommandsMissed
                $CommandsMissedResult.WarningThreshold | Should Be 6
                $CommandsMissedResult.FailThreshold | Should Be 12
                $CommandsMissedResult.HigherIsBetter | Should Be $False
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
            It 'Should return 2 objects for the MetricName "TestCoverage" because this metric is present in both groups' {
                ($Results | Where-Object MetricName -eq 'TestCoverage').Count |
                Should Be 2
            }
        }
        Context 'The value of the SettingsGroup parameter is "OverallMetrics"' {

            $Results = Get-PSCodeHealthComplianceRule -SettingsGroup 'OverallMetrics'

            It 'Should return objects of the type [PSCodeHealth.Compliance.Rule]' {
                Foreach ( $Result in $Results ) {
                    $Result | Should BeOfType [PSCustomObject]
                    ($Result | Get-Member).TypeName[0] | Should Be 'PSCodeHealth.Compliance.Rule'
                }
            }
            It 'Should return 13 objects' {
                $Results.Count | Should Be 13
            }
            It 'Should return only objects with the SettingsGroup property equal to "OverallMetrics"' {
                Foreach ( $Result in $Results ) {
                    $Result.SettingsGroup | Should Be 'OverallMetrics'
                }
            }
            It 'Should return an object with the MetricName property equal to "LinesOfCodeTotal"' {
                (($Results | Where-Object MetricName -eq 'LinesOfCodeTotal' | Measure-Object )).Count |
                Should Be 1
            }
            It 'Should return an object with the MetricName property equal to "LinesOfCodeAverage"' {
                (($Results | Where-Object MetricName -eq 'LinesOfCodeAverage' | Measure-Object )).Count |
                Should Be 1
            }
            It 'Should return an object with the MetricName property equal to "ScriptAnalyzerFindingsTotal"' {
                (($Results | Where-Object MetricName -eq 'ScriptAnalyzerFindingsTotal' | Measure-Object )).Count |
                Should Be 1
            }
            It 'Should return an object with the MetricName property equal to "ScriptAnalyzerErrors"' {
                (($Results | Where-Object MetricName -eq 'ScriptAnalyzerErrors' | Measure-Object )).Count |
                Should Be 1
            }
            It 'Should return an object with the MetricName property equal to "ScriptAnalyzerWarnings"' {
                (($Results | Where-Object MetricName -eq 'ScriptAnalyzerWarnings' | Measure-Object )).Count |
                Should Be 1
            }
            It 'Should return an object with the MetricName property equal to "ScriptAnalyzerInformation"' {
                (($Results | Where-Object MetricName -eq 'ScriptAnalyzerInformation' | Measure-Object )).Count |
                Should Be 1
            }
            It 'Should return an object with the MetricName property equal to "ScriptAnalyzerFindingsAverage"' {
                (($Results | Where-Object MetricName -eq 'ScriptAnalyzerFindingsAverage' | Measure-Object )).Count |
                Should Be 1
            }
            It 'Should return an object with the MetricName property equal to "NumberOfFailedTests"' {
                (($Results | Where-Object MetricName -eq 'NumberOfFailedTests' | Measure-Object )).Count |
                Should Be 1
            }
            It 'Should return an object with the MetricName property equal to "TestsPassRate"' {
                (($Results | Where-Object MetricName -eq 'TestsPassRate' | Measure-Object )).Count |
                Should Be 1
            }
            It 'Should return an object with the MetricName property equal to "TestCoverage"' {
                (($Results | Where-Object MetricName -eq 'TestCoverage' | Measure-Object )).Count |
                Should Be 1
            }
            It 'Should return an object with the MetricName property equal to "CommandsMissedTotal"' {
                (($Results | Where-Object MetricName -eq 'CommandsMissedTotal' | Measure-Object )).Count |
                Should Be 1
            }
            It 'Should return an object with the MetricName property equal to "ComplexityAverage"' {
                (($Results | Where-Object MetricName -eq 'ComplexityAverage' | Measure-Object )).Count |
                Should Be 1
            }
            It 'Should return an object with the MetricName property equal to "NestingDepthAverage"' {
                (($Results | Where-Object MetricName -eq 'NestingDepthAverage' | Measure-Object )).Count |
                Should Be 1
            }
        }
        Context 'The SettingsGroup and the MetricName parameters are both specified' {

            $Result = Get-PSCodeHealthComplianceRule -SettingsGroup OverallMetrics -MetricName TestCoverage

            It 'Should return an object of the type [PSCodeHealth.Compliance.Rule]' {
                $Result | Should BeOfType [PSCustomObject]
                ($Result | Get-Member).TypeName[0] | Should Be 'PSCodeHealth.Compliance.Rule'
            }
            It 'Should return 1 object' {
                ($Result | Measure-Object).Count | Should Be 1
            }
            It 'Should return an object with the expected "WarningThreshold" property' {
                $Result.WarningThreshold | Should Be 80
            }
            It 'Should return an object with the expected "FailThreshold" property' {
                $Result.FailThreshold | Should Be 70
            }
            It 'Should return an object with the expected "HigherIsBetter" property' {
                $Result.HigherIsBetter | Should Be $True
            }
        }
        Context 'The MetricName parameter is specified, but not the SettingsGroup parameter' {

            $Results = Get-PSCodeHealthComplianceRule -MetricName TestCoverage

            It 'Should return objects of the type [PSCodeHealth.Compliance.Rule]' {
                Foreach ( $Result in $Results ) {
                    $Result | Should BeOfType [PSCustomObject]
                    ($Result | Get-Member).TypeName[0] | Should Be 'PSCodeHealth.Compliance.Rule'
                }
            }
            It 'Should return 2 objects' {
                $Results.Count | Should Be 2
            }
            It 'Should return only objects with the MetricName property equal to "TestCoverage"' {
                Foreach ( $Result in $Results ) {
                    $Result.MetricName | Should Be 'TestCoverage'
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
            It 'Should return objects with the expected "HigherIsBetter" property' {
                Foreach ( $Result in $Results ) {
                    $Result.HigherIsBetter | Should Be $True
                }
            }
        }
        Context 'The MetricName parameter contains multiple values' {
            $MetricsSet = @('TestCoverage','Complexity','MaximumNestingDepth')
            $Results = Get-PSCodeHealthComplianceRule -MetricName $MetricsSet

            It 'Should return objects of the type [PSCodeHealth.Compliance.Rule]' {
                Foreach ( $Result in $Results ) {
                    $Result | Should BeOfType [PSCustomObject]
                    ($Result | Get-Member).TypeName[0] | Should Be 'PSCodeHealth.Compliance.Rule'
                }
            }
            It 'Should return 4 objects' {
                $Results.Count | Should Be 4
            }
            It 'Should return 1 object with the MetricName property equal to "Complexity"' {
                (($Results | Where-Object MetricName -eq 'Complexity' | Measure-Object )).Count |
                Should Be 1
            }
            It 'Should return 1 object with the MetricName property equal to "MaximumNestingDepth"' {
                (($Results | Where-Object MetricName -eq 'MaximumNestingDepth' | Measure-Object )).Count |
                Should Be 1
            }
            It 'Should return 2 object with the MetricName property equal to "TestCoverage"' {
                (($Results | Where-Object MetricName -eq 'TestCoverage' | Measure-Object )).Count |
                Should Be 2
            }
        }
        Context 'The custom settings file contains 2 metrics in both settings groups' {

            $MetricsInBothGroups = "$PSScriptRoot\..\..\TestData\2SettingsGroups4Metrics.json"
            $Results = Get-PSCodeHealthComplianceRule -CustomSettingsPath $MetricsInBothGroups

            It 'Should return objects of the type [PSCodeHealth.Compliance.Rule]' {
                Foreach ( $Result in $Results ) {
                    $Result | Should BeOfType [PSCustomObject]
                    ($Result | Get-Member).TypeName[0] | Should Be 'PSCodeHealth.Compliance.Rule'
                }
            }
            It 'Should return 5 objects where the SettingsGroup property is equal to "PerFunctionMetrics"' {
                ($Results | Where-Object SettingsGroup -eq 'PerFunctionMetrics').Count |
                Should Be 6
            }
            It 'Should return 13 objects where the SettingsGroup property is equal to "OverallMetrics"' {
                ($Results | Where-Object SettingsGroup -eq 'OverallMetrics').Count |
                Should Be 13
            }
            It 'Resulting compliance rules are the same as the defaults for metric "LinesOfCode"' {
                $LinesOfCodeResult = $Results | Where-Object MetricName -eq 'LinesOfCode'
                $LinesOfCodeResult.WarningThreshold | Should Be 30
                $LinesOfCodeResult.FailThreshold | Should Be 60
                $LinesOfCodeResult.HigherIsBetter | Should Be $False
            }
            It 'Resulting compliance rules are the same as the defaults for metric "TestCoverage"' {
                $TestCoverageResult = $Results | Where-Object MetricName -eq 'TestCoverage' | Where-Object SettingsGroup -eq 'PerFunctionMetrics'
                $TestCoverageResult.WarningThreshold | Should Be 80
                $TestCoverageResult.FailThreshold | Should Be 70
                $TestCoverageResult.HigherIsBetter | Should Be $True
            }
            It 'Resulting compliance rules override the defaults for metric "Complexity"' {
                $ComplexityResult = $Results | Where-Object MetricName -eq Complexity
                $ComplexityResult.WarningThreshold | Should Be 17
                $ComplexityResult.FailThreshold | Should Be 33
                $ComplexityResult.HigherIsBetter | Should Be $False
            }
            It 'Resulting compliance rules override the defaults for metric "MaximumNestingDepth"' {
                $MaximumNestingDepthResult = $Results | Where-Object MetricName -eq MaximumNestingDepth
                $MaximumNestingDepthResult.WarningThreshold | Should Be 6
                $MaximumNestingDepthResult.FailThreshold | Should Be 12
                $MaximumNestingDepthResult.HigherIsBetter | Should Be $False
            }
            It 'Resulting compliance rules are the same as the defaults for metric "TestsPassRate"' {
                $TestsPassRateResult = $Results | Where-Object MetricName -eq TestsPassRate
                $TestsPassRateResult.WarningThreshold | Should Be 99
                $TestsPassRateResult.FailThreshold | Should Be 97
                $TestsPassRateResult.HigherIsBetter | Should Be $True
            }
            It 'Resulting compliance rules are the same as the defaults for metric "CommandsMissedTotal"' {
                $CommandsMissedTotalResult = $Results | Where-Object MetricName -eq CommandsMissedTotal
                $CommandsMissedTotalResult.WarningThreshold | Should Be 200
                $CommandsMissedTotalResult.FailThreshold | Should Be 400
                $CommandsMissedTotalResult.HigherIsBetter | Should Be $False
            }
            It 'Resulting compliance rules override the defaults for metric "LinesOfCodeTotal"' {
                $LinesOfCodeTotalResult = $Results | Where-Object MetricName -eq LinesOfCodeTotal
                $LinesOfCodeTotalResult.WarningThreshold | Should Be 1500
                $LinesOfCodeTotalResult.FailThreshold | Should Be 3000
                $LinesOfCodeTotalResult.HigherIsBetter | Should Be $False
            }
            It 'Resulting compliance rules override the defaults for metric "LinesOfCodeAverage"' {
                $LinesOfCodeAverageResult = $Results | Where-Object MetricName -eq LinesOfCodeAverage
                $LinesOfCodeAverageResult.WarningThreshold | Should Be 21
                $LinesOfCodeAverageResult.FailThreshold | Should Be 42
                $LinesOfCodeAverageResult.HigherIsBetter | Should Be $False
            }
            It 'Should return 2 objects for the MetricName "TestCoverage" because this metric is present in both groups' {
                ($Results | Where-Object MetricName -eq 'TestCoverage').Count |
                Should Be 2
            }
        }
    }
}