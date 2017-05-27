$ModuleName = 'PSCodeHealth'
Import-Module "$PSScriptRoot\..\..\..\$ModuleName\$($ModuleName).psd1" -Force

Describe 'Invoke-PSCodeHealth' {
    InModuleScope $ModuleName {

        $ScriptPath = $PSScriptRoot
        $Mocks = ConvertFrom-Json (Get-Content -Path "$($PSScriptRoot)\..\..\TestData\MockObjects.json" -Raw )
        
        Context 'Get-PowerShellFile returns 0 file' {

            Mock Get-PowerShellFile { }
            $Result = Invoke-PSCodeHealth -Path "$PSScriptRoot\..\..\TestData"

            It 'Should not throw but return $Null' {
                $Result | Should Be $Null
            }
        }

        Context 'Get-PowerShellFile returns 1 file' {

            Mock Get-PowerShellFile { "$ScriptPath\..\..\TestData\2PublicFunctions.psm1" }
            $Result = Invoke-PSCodeHealth -Path "$PSScriptRoot\..\..\TestData"

            It 'Should return 1 object' {
                ($Result | Measure-Object).Count | Should Be 1
            }
            It 'Should return an object of the type [PSCodeHealth.Overall.HealthReport]' {
                $Result | Should BeOfType [PSCustomObject]
                ($Result | Get-Member).TypeName[0] | Should Be 'PSCodeHealth.Overall.HealthReport'
            }
            It 'Should throw if the specified Path does not exist'  {
                { Invoke-PSCodeHealth -Path 'Any' } |
                Should Throw
            }
            It 'Should not be $Null if Get-FunctionDefinition finds 0 function' {
                Mock Get-FunctionDefinition { }
                Mock Get-PowerShellFile { "$ScriptPath\..\..\TestData\2PublicFunctions.psm1" }

                $ItResult = Invoke-PSCodeHealth -Path "$PSScriptRoot\..\..\TestData"
                $ItResult | Should Not BeNullOrEmpty
                $ItResult.FunctionHealthRecords | Should BeNullOrEmpty
            }
            It 'Should remove TestsPath from $PSBoundParameters before calling Get-PowerShellFile' {
                Mock Get-FunctionDefinition { }
                Mock Get-PowerShellFile { "$ScriptPath\..\..\TestData\2PublicFunctions.psm1" }
                { Invoke-PSCodeHealth -Path "$PSScriptRoot\..\..\TestData" -TestsPath "$PSScriptRoot\..\..\TestData\FakeTestFile.ps1" } |
                Should Not Throw
            }
            It 'Should return an object with the expected property "ReportTitle"' {
                $Result.ReportTitle | Should Be 'TestData'
            }
            It 'Should return an object with the expected property "ReportDate"' {
                $Result.ReportDate | Should Match '^\d{4}\-\d{2}\-\d{2}\s\d{2}'
            }
            It 'Should return an object with the expected property "AnalyzedPath"' {
                $Result.AnalyzedPath | Should BeLike '*\TestData'
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
    }
}