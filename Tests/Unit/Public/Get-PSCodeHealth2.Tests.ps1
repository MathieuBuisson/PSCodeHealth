# Separate tests file to force Pester to cleanup its Mock table and avoid this error :
# Internal error detected:  Mock for '63f5f595-6121-429f-bf3f-8633bbaf7057' in module 'PSCodeHealth' was called, but does not exist in the mock table. At C:\Program Files\WindowsPowerShell\Modules\Pester\4.0.3\Functions\Mock.ps1:940 char:9
$ModuleName = 'PSCodeHealth'
Import-Module "$PSScriptRoot\..\..\..\$ModuleName\$($ModuleName).psd1" -Force

Describe 'Get-PSCodeHealth (again)' {

    $InitialLocation = $PWD.ProviderPath
    AfterEach {
        Set-Location $InitialLocation
    }

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
            It 'Should return an object with the expected property "LinesOfCodeAverage"' {
                $Result.LinesOfCodeAverage | Should Be 10
            }
            It 'Should return an object with the expected property "ScriptAnalyzerFindingsTotal"' {
                $Result.ScriptAnalyzerFindingsTotal | Should Be 1
            }
            It 'Should return an object with the expected property "ScriptAnalyzerErrors"' {
                $Result.ScriptAnalyzerErrors | Should Be 0
            }
            It 'Should return an object with the expected property "ScriptAnalyzerWarnings"' {
                $Result.ScriptAnalyzerWarnings | Should Be 1
            }
            It 'Should return an object with the expected property "ScriptAnalyzerInformation"' {
                $Result.ScriptAnalyzerInformation | Should Be 0
            }
            It 'Should return an object with the expected property "ScriptAnalyzerFindingsAverage"' {
                $Result.ScriptAnalyzerFindingsAverage | Should Be 0.25
            }
            It 'Should return an object with the expected property "TestCoverage"' {
                $Result.TestCoverage | Should Be 0
            }
            It 'Should return an object with the expected property "CommandsMissedTotal"' {
                $Result.CommandsMissedTotal | Should Be 3
            }
            It 'Should return an object with the expected property "ComplexityAverage"' {
                $Result.ComplexityAverage | Should Be 1
            }
            It 'Should return an object with the expected property "NestingDepthAverage"' {
                $Result.NestingDepthAverage | Should Be 0.75
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
            It 'Should return an object with the expected property "LinesOfCodeAverage"' {
                $Result.LinesOfCodeAverage | Should Be 15.5
            }
            It 'Should return an object with the expected property "ScriptAnalyzerFindingsTotal"' {
                $Result.ScriptAnalyzerFindingsTotal | Should Be 1
            }
            It 'Should return an object with the expected property "ScriptAnalyzerErrors"' {
                $Result.ScriptAnalyzerErrors | Should Be 0
            }
            It 'Should return an object with the expected property "ScriptAnalyzerWarnings"' {
                $Result.ScriptAnalyzerWarnings | Should Be 1
            }
            It 'Should return an object with the expected property "ScriptAnalyzerInformation"' {
                $Result.ScriptAnalyzerInformation | Should Be 0
            }
            It 'Should return an object with the expected property "ScriptAnalyzerFindingsAverage"' {
                $Result.ScriptAnalyzerFindingsAverage | Should Be 0.5
            }
            It 'Should return an object with the expected property "TestCoverage"' {
                $Result.TestCoverage | Should Be 0
            }
            It 'Should return an object with the expected property "CommandsMissedTotal"' {
                $Result.CommandsMissedTotal | Should Be 1
            }
            It 'Should return an object with the expected property "ComplexityAverage"' {
                $Result.ComplexityAverage | Should Be 1
            }
            It 'Should return an object with the expected property "NestingDepthAverage"' {
                $Result.NestingDepthAverage | Should Be 1
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
        Context 'No value is specified for the Path parameter' {

            Mock Get-PowerShellFile { } -ParameterFilter { $Path  -eq $TestDrive }

            It 'Should default to the current directory if we are in a FileSystem PowerShell drive' {
                Set-Location $TestDrive
                $Null = Get-PSCodeHealth -Recurse
                Assert-MockCalled -CommandName Get-PowerShellFile -Scope It -ParameterFilter { $Path  -eq $TestDrive }
            }
            It 'Should throw if we are in a PowerShell drive other than the FileSystem provider' {
                { Set-Location HKLM:\ ; Get-PSCodeHealth } |
                Should Throw 'The current location is from the Registry provider, please provide a value for the Path parameter or change to a FileSystem location.'
            }
        }
    }
}