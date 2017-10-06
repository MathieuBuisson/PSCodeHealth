$ModuleName = 'PSCodeHealth'
Import-Module "$PSScriptRoot\..\..\..\$ModuleName\$($ModuleName).psd1" -Force

Describe 'New-PSCodeHealthTableData' {
    InModuleScope $ModuleName {

        Context 'The health report contains failed tests' {

            $TestHealthReport = ConvertFrom-Json (Get-Content -Path "$PSScriptRoot\..\..\TestData\HealthReport.json" -Raw)
            $TestHealthReport.psobject.TypeNames.Insert(0, 'PSCodeHealth.Overall.HealthReport')
            $FunctionNames = $TestHealthReport.FunctionHealthRecords.FunctionName
            $Result = New-PSCodeHealthTableData -HealthReport $TestHealthReport

            It 'Should return an object with the 4 expected properties' {
                $Result.BestPracticesRows | Should Not BeNullOrEmpty
                $Result.MaintainabilityRows | Should Not BeNullOrEmpty
                $Result.FailedTestsRows | Should Not BeNullOrEmpty
                $Result.CoverageRows | Should Not BeNullOrEmpty
            }
            $Result.BestPracticesRows -split "`n" | Out-File -FilePath "$TestDrive\BestPracticesRows.txt"
            $Result.MaintainabilityRows -split "`n" | Out-File -FilePath "$TestDrive\MaintainabilityRows.txt"
            $Result.FailedTestsRows -split "`n" | Out-File -FilePath "$TestDrive\FailedTestsRows.txt"
            $Result.CoverageRows -split "`n" | Out-File -FilePath "$TestDrive\CoverageRows.txt"

            It 'Should have 1 best practices row for each function' {
                Foreach ( $Function in $FunctionNames ) {
                    "$TestDrive\BestPracticesRows.txt" | Should -FileContentMatch "<td>$Function</td>"
                }
            }
            It 'Should have 1 maintainability row for each function' {
                Foreach ( $Function in $FunctionNames ) {
                    "$TestDrive\MaintainabilityRows.txt" | Should -FileContentMatch "<td>$Function</td>"
                }
            }
            It 'Should have 1 failed test row for each failed test' {

                (Select-String -Path "$TestDrive\FailedTestsRows.txt" -Pattern '<tr>').Count |
                Should Be $TestHealthReport.NumberOfFailedTests
            }
            It 'Should have 1 test coverage row for each function' {
                Foreach ( $Function in $FunctionNames ) {
                    "$TestDrive\CoverageRows.txt" | Should -FileContentMatch "<td>$Function</td>"
                }
            }
        }
        Context 'The health report contains failed tests' {

            $TestHealthReport = ConvertFrom-Json (Get-Content -Path "$PSScriptRoot\..\..\TestData\HealthReport.json" -Raw)
            $TestHealthReport.psobject.TypeNames.Insert(0, 'PSCodeHealth.Overall.HealthReport')
            $TestHealthReport.NumberOfFailedTests = 0
            $Result = New-PSCodeHealthTableData -HealthReport $TestHealthReport

            It 'Has a FailedTestsRows property which is an empty string' {
                $Result.FailedTestsRows | Should Be ''
            }
        }
    }
}