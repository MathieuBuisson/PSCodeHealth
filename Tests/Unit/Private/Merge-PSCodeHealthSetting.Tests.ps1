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
            It 'Should return an object with the expected property "PerFunctionMetrics"' {
                $Result.PerFunctionMetrics | Should Be $DefaultSettings.PerFunctionMetrics
            }
            It 'Should return an object with the expected property "OverallMetrics"' {
                $Result.OverallMetrics | Should Be $DefaultSettings.OverallMetrics
            }
        }
        Context 'Custom settings do not contain any of the expected settings groups' {

            $CustomSettings = ConvertFrom-Json (Get-Content -Path "$PSScriptRoot\..\TestData\NoSettingsGroup.json" -Raw )
            $Result = Merge-PSCodeHealthSetting -DefaultSettings $DefaultSettings -CustomSettings $CustomSettings
            
            It 'Should return an object of the type [PSCustomObject]' {
                $Result | Should BeOfType [PSCustomObject]
            }
            It 'Should return an object with the expected property "PerFunctionMetrics"' {
                $Result.PerFunctionMetrics | Should Be $DefaultSettings.PerFunctionMetrics
            }
            It 'Should return an object with the expected property "OverallMetrics"' {
                $Result.OverallMetrics | Should Be $DefaultSettings.OverallMetrics
            }
        }
        Context 'Custom settings contains only expected settings groups and metrics' {

            $CustomSettings = ConvertFrom-Json (Get-Content -Path "$PSScriptRoot\..\TestData\2SettingsGroups4Metrics.json" -Raw )
            $Result = Merge-PSCodeHealthSetting -DefaultSettings $DefaultSettings -CustomSettings $CustomSettings
            
            It 'Should return an object of the type [PSCustomObject]' {
                $Result | Should BeOfType [PSCustomObject]
            }
            It 'Resulting settings are the same as the defaults for metric "LinesOfCode"' {
                $Result.PerFunctionMetrics.LinesOfCode.WarningThreshold | Should Be 20
                $Result.PerFunctionMetrics.LinesOfCode.FailThreshold | Should Be 40
            }
            It 'Resulting settings are the same as the defaults for metric "TestCoverage"' {
                $Result.PerFunctionMetrics.TestCoverage.WarningThreshold | Should Be 80
                $Result.PerFunctionMetrics.TestCoverage.FailThreshold | Should Be 70
            }
            It 'Resulting settings override the defaults for metric "Complexity"' {
                $Result.PerFunctionMetrics.Complexity.WarningThreshold | Should Be 17
                $Result.PerFunctionMetrics.Complexity.FailThreshold | Should Be 33
            }
            It 'Resulting settings override the defaults for metric "MaximumNestingDepth"' {
                $Result.PerFunctionMetrics.MaximumNestingDepth.WarningThreshold | Should Be 6
                $Result.PerFunctionMetrics.MaximumNestingDepth.FailThreshold | Should Be 12
            }
            It 'Resulting settings are the same as the defaults for metric "TestsPassRate"' {
                $Result.OverallMetrics.TestsPassRate.WarningThreshold | Should Be 99
                $Result.OverallMetrics.TestsPassRate.FailThreshold | Should Be 97
            }
            It 'Resulting settings are the same as the defaults for metric "CommandsMissedTotal"' {
                $Result.OverallMetrics.CommandsMissedTotal.WarningThreshold | Should Be 20
                $Result.OverallMetrics.CommandsMissedTotal.FailThreshold | Should Be 40
            }
            It 'Resulting settings override the defaults for metric "LinesOfCodeTotal"' {
                $Result.OverallMetrics.LinesOfCodeTotal.WarningThreshold | Should Be 1500
                $Result.OverallMetrics.LinesOfCodeTotal.FailThreshold | Should Be 3000
            }
            It 'Resulting settings override the defaults for metric "LinesOfCodeAverage"' {
                $Result.OverallMetrics.LinesOfCodeAverage.WarningThreshold | Should Be 21
                $Result.OverallMetrics.LinesOfCodeAverage.FailThreshold | Should Be 42
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
                $Result.PerFunctionMetrics.LinesOfCode.WarningThreshold | Should Be 20
                $Result.PerFunctionMetrics.LinesOfCode.FailThreshold | Should Be 40
            }
            It 'Resulting settings are the same as the defaults for metric "TestCoverage"' {
                $Result.PerFunctionMetrics.TestCoverage.WarningThreshold | Should Be 80
                $Result.PerFunctionMetrics.TestCoverage.FailThreshold | Should Be 70
            }
            It 'Resulting settings are the same as the defaults for metric "Complexity"' {
                $Result.PerFunctionMetrics.Complexity.WarningThreshold | Should Be 15
                $Result.PerFunctionMetrics.Complexity.FailThreshold | Should Be 30
            }
            It 'Resulting settings are the same as the defaults for metric "MaximumNestingDepth"' {
                $Result.PerFunctionMetrics.MaximumNestingDepth.WarningThreshold | Should Be 4
                $Result.PerFunctionMetrics.MaximumNestingDepth.FailThreshold | Should Be 8
            }
            It 'Resulting settings are the same as the defaults for metric "TestsPassRate"' {
                $Result.OverallMetrics.TestsPassRate.WarningThreshold | Should Be 99
                $Result.OverallMetrics.TestsPassRate.FailThreshold | Should Be 97
            }
            It 'Resulting settings are the same as the defaults for metric "CommandsMissedTotal"' {
                $Result.OverallMetrics.CommandsMissedTotal.WarningThreshold | Should Be 20
                $Result.OverallMetrics.CommandsMissedTotal.FailThreshold | Should Be 40
            }
            It 'Resulting settings are the same as the defaults for metric "LinesOfCodeTotal"' {
                $Result.OverallMetrics.LinesOfCodeTotal.WarningThreshold | Should Be 1000
                $Result.OverallMetrics.LinesOfCodeTotal.FailThreshold | Should Be 2000
            }
            It 'Resulting settings are the same as the defaults for metric "LinesOfCodeAverage"' {
                $Result.OverallMetrics.LinesOfCodeAverage.WarningThreshold | Should Be 20
                $Result.OverallMetrics.LinesOfCodeAverage.FailThreshold | Should Be 40
            }
            It 'Resulting settings have metric absent from the defaults : "DummyMetric"' {
                $Result.PerFunctionMetrics.DummyMetric.WarningThreshold | Should Be 2
                $Result.PerFunctionMetrics.DummyMetric.FailThreshold | Should Be 4
            }
            It 'Resulting settings have metric absent from the defaults : "DummyMetric2"' {
                $Result.OverallMetrics.DummyMetric2.WarningThreshold | Should Be 7
                $Result.OverallMetrics.DummyMetric2.FailThreshold | Should Be 8
            }
        }
        Remove-Variable -Name 'DefaultSettings' -Force -ErrorAction SilentlyContinue
    }
}