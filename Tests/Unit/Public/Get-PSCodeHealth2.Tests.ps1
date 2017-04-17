# Separate tests file to force Pester to cleanup its Mock table and avoid this error :
# Internal error detected:  Mock for '63f5f595-6121-429f-bf3f-8633bbaf7057' in module 'PSCodeHealth' was called, but does not exist in the mock table. At C:\Program Files\WindowsPowerShell\Modules\Pester\4.0.3\Functions\Mock.ps1:940 char:9
$ModuleName = 'PSCodeHealth'
Import-Module "$PSScriptRoot\..\..\..\$ModuleName\$($ModuleName).psd1" -Force

Describe 'Get-PSCodeHealth (again)' {
    InModuleScope $ModuleName {

        Copy-Item -Path (Get-ChildItem -Path "$($PSScriptRoot)\..\TestData\" -Filter '*.psm1').FullName -Destination TestDrive:\
            
        Context 'Get-PowerShellFile returns 2 files and TestsPath parameter is specified' {

            $Result = Get-PSCodeHealth -Path $TestDrive -TestsPath $TestDrive

            It 'Should return an object with the expected property "Files"' {
                $Result.Files | Should Be 2
            }
            It 'Should return an object with the expected property "Functions"' {
                $Result.Functions | Should Be 4
            }
            It 'Should return an object with the expected property "LinesOfCodeTotal"' {
                $Result.LinesOfCodeTotal | Should Be 40
            }
            It 'Should return an object with the expected property "LinesOfCodePerFunction"' {
                $Result.LinesOfCodePerFunction | Should Be 10
            }
            It 'Should return an object with the expected property "ScriptAnalyzerFindingsTotal"' {
                $Result.ScriptAnalyzerFindingsTotal | Should Be 1
            }
            It 'Should return an object with the expected property "ScriptAnalyzerFindingsPerFunction"' {
                $Result.ScriptAnalyzerFindingsPerFunction | Should Be 0.25
            }
            It 'Should return an object with the expected property "TestCoverage"' {
                $Result.TestCoverage | Should Be 0
            }
            It 'Should return an object with the expected property "CommandsMissedTotal"' {
                $Result.CommandsMissedTotal | Should Be 3
            }
            It 'Should return an object with the expected property "ComplexityPerFunction"' {
                $Result.ComplexityPerFunction | Should Be 1
            }
            It 'Should return an object with the expected property "NestingDepthPerFunction"' {
                $Result.NestingDepthPerFunction | Should Be 0.75
            }
            It 'Should return 2 objects in the property "FunctionHealthRecords"' {
                $Result.FunctionHealthRecords.Count | Should Be 4
            }
            It 'Should return only [PSCodeHealth.Function.HealthRecord] objects in the property "FunctionHealthRecords"' {
                $ResultTypeNames = ($Result.FunctionHealthRecords | Get-Member).TypeName
                Foreach ( $TypeName in $ResultTypeNames ) {
                    $TypeName | Should Be 'PSCodeHealth.Function.HealthRecord'
                }
            }
        }
        Context 'The value for the Path parameter is a file' {

            $Result = Get-PSCodeHealth -Path "$TestDrive\2PublicFunctions.psm1"

            It 'Should return an object of the type [PSCodeHealth.Overall.HealthReport]' {
                $Result | Should BeOfType [PSCustomObject]
                ($Result | Get-Member).TypeName[0] | Should Be 'PSCodeHealth.Overall.HealthReport'
            }
            It 'Should return an object with the expected property "Files"' {
                $Result.Files | Should Be 1
            }
            It 'Should return an object with the expected property "Functions"' {
                $Result.Functions | Should Be 2
            }
            It 'Should return an object with the expected property "LinesOfCodeTotal"' {
                $Result.LinesOfCodeTotal | Should Be 31
            }
            It 'Should return an object with the expected property "LinesOfCodePerFunction"' {
                $Result.LinesOfCodePerFunction | Should Be 15.5
            }
            It 'Should return an object with the expected property "ScriptAnalyzerFindingsTotal"' {
                $Result.ScriptAnalyzerFindingsTotal | Should Be 1
            }
            It 'Should return an object with the expected property "ScriptAnalyzerFindingsPerFunction"' {
                $Result.ScriptAnalyzerFindingsPerFunction | Should Be 0.5
            }
            It 'Should return an object with the expected property "TestCoverage"' {
                $Result.TestCoverage | Should Be 0
            }
            It 'Should return an object with the expected property "CommandsMissedTotal"' {
                $Result.CommandsMissedTotal | Should Be 1
            }
            It 'Should return an object with the expected property "ComplexityPerFunction"' {
                $Result.ComplexityPerFunction | Should Be 1
            }
            It 'Should return an object with the expected property "NestingDepthPerFunction"' {
                $Result.NestingDepthPerFunction | Should Be 1
            }
            It 'Should return 2 objects in the property "FunctionHealthRecords"' {
                $Result.FunctionHealthRecords.Count | Should Be 2
            }
            It 'Should return only [PSCodeHealth.Function.HealthRecord] objects in the property "FunctionHealthRecords"' {
                $ResultTypeNames = ($Result.FunctionHealthRecords | Get-Member).TypeName
                Foreach ( $TypeName in $ResultTypeNames ) {
                    $TypeName | Should Be 'PSCodeHealth.Function.HealthRecord'
                }
            }
        }
    }
}