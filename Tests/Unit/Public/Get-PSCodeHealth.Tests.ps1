$ModuleName = 'PSCodeHealth'
Import-Module "$PSScriptRoot\..\..\..\$ModuleName\$($ModuleName).psd1" -Force

Describe 'Get-PSCodeHealth' {
    InModuleScope $ModuleName {

        $ScriptPath = $PSScriptRoot
        $Mocks = ConvertFrom-Json (Get-Content -Path "$($PSScriptRoot)\..\TestData\MockObjects.json" -Raw )
        
        Context 'Get-PowerShellFile returns 0 file' {

            Mock Get-PowerShellFile { }
            $Result = Get-PSCodeHealth -Path "$PSScriptRoot\..\TestData"

            It 'Should not throw but return $Null' {
                $Result | Should Be $Null
            }
        }

        Context 'Get-PowerShellFile returns 1 file' {

            Mock Get-PowerShellFile { "$ScriptPath\..\TestData\2PublicFunctions.psm1" }
            $Result = Get-PSCodeHealth -Path "$PSScriptRoot\..\TestData"

            It 'Should return 1 object' {
                ($Result | Measure-Object).Count | Should Be 1
            }
            It 'Should return an object of the type [PSCodeHealth.Overall.HealthReport]' {
                $Result | Should BeOfType [PSCustomObject]
                ($Result | Get-Member).TypeName[0] | Should Be 'PSCodeHealth.Overall.HealthReport'
            }
            It 'Should throw if the specified Path does not exist'  {
                { Get-PSCodeHealth -Path 'Any' } |
                Should Throw
            }
            It 'Should not be $Null if Get-FunctionDefinition finds 0 function' {
                Mock Get-FunctionDefinition { }
                Mock Get-PowerShellFile { "$ScriptPath\..\TestData\2PublicFunctions.psm1" }

                $ItResult = Get-PSCodeHealth -Path "$PSScriptRoot\..\TestData"
                $ItResult | Should Not BeNullOrEmpty
                $ItResult.FunctionHealthRecords | Should BeNullOrEmpty
            }
            It 'Should remove TestsPath from $PSBoundParameters before calling Get-PowerShellFile' {
                Mock Get-FunctionDefinition { }
                Mock Get-PowerShellFile { "$ScriptPath\..\TestData\2PublicFunctions.psm1" }
                { Get-PSCodeHealth -Path "$PSScriptRoot\..\TestData" -TestsPath "$PSScriptRoot\..\TestData" } |
                Should Not Throw
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