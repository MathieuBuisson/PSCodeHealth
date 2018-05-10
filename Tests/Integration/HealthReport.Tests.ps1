$ModuleName = 'PSCodeHealth'
Import-Module "$PSScriptRoot\..\..\$ModuleName\$($ModuleName).psd1" -Force
$CodePath = "$PSScriptRoot\..\TestData\coveralls"

Describe 'Invoke-PSCodeHealth' {

    $Result = Invoke-PSCodeHealth -Path $CodePath
    $ExpectedFunctionNames = @('Add-CoverageInfo','Merge-CoverageResult','Get-CoverageArray','Format-FileCoverage','Get-CommandsForFile','Get-GitInfo','Format-Coverage','Publish-Coverage','Get-CoveragePercentage')
    $AddCoverageInfo = $Result.FunctionHealthRecords.Where({$_.FunctionName -eq 'Add-CoverageInfo'})
    $GetCoverageArray = $Result.FunctionHealthRecords.Where({$_.FunctionName -eq 'Get-CoverageArray'})
    $FormatFileCoverage = $Result.FunctionHealthRecords.Where({$_.FunctionName -eq 'Format-FileCoverage'})
    $FormatCoverage = $Result.FunctionHealthRecords.Where({$_.FunctionName -eq 'Format-Coverage'})
    $GetCoveragePercentage = $Result.FunctionHealthRecords.Where({$_.FunctionName -eq 'Get-CoveragePercentage'})

    Context 'Given code in coveralls module, it returns the expected FunctionHealthRecords' {

        It 'Should find 9 function definitions' {
            $Result.FunctionHealthRecords.Count | Should Be 9
        }
        It 'Should return only functions with the expected function names' {
            Foreach ( $FunctionName in $Result.FunctionHealthRecords.FunctionName ) {
                $FunctionName | Should BeIn $ExpectedFunctionNames
            }
        }
        It 'Should return correct LinesOfCode metric for the function Add-CoverageInfo' {
            $AddCoverageInfo.LinesOfCode | Should Be 14
        }
        It 'Should return correct ScriptAnalyzerFindings metric for the function Add-CoverageInfo' {
            $AddCoverageInfo.ScriptAnalyzerFindings | Should Be 0
        }
        It 'Should return correct TestCoverage metric for the function Add-CoverageInfo' {
            $AddCoverageInfo.TestCoverage | Should Be 0
        }
        It 'Should return correct CommandsMissed metric for the function Add-CoverageInfo' {
            $AddCoverageInfo.CommandsMissed | Should Be 3
        }        
        It 'Should return correct Complexity metric for the function Add-CoverageInfo' {
            $AddCoverageInfo.Complexity | Should Be 1
        }
        It 'Should return correct MaximumNestingDepth metric for the function Add-CoverageInfo' {
            $AddCoverageInfo.MaximumNestingDepth | Should Be 1
        }
        It 'Should return correct LinesOfCode metric for the function Get-CoverageArray' {
            $GetCoverageArray.LinesOfCode | Should Be 31
        }
        It 'Should return correct ScriptAnalyzerFindings metric for the function Get-CoverageArray' {
            $GetCoverageArray.ScriptAnalyzerFindings | Should Be 2
        }
        It 'Should return correct TestCoverage metric for the function Get-CoverageArray' {
            $GetCoverageArray.TestCoverage | Should Be 94.74
        }
        It 'Should return correct CommandsMissed metric for the function Get-CoverageArray' {
            $GetCoverageArray.CommandsMissed | Should Be 1
        }        
        It 'Should return correct Complexity metric for the function Get-CoverageArray' {
            $GetCoverageArray.Complexity | Should Be 5
        }
        It 'Should return correct MaximumNestingDepth metric for the function Get-CoverageArray' {
            $GetCoverageArray.MaximumNestingDepth | Should Be 3
        }
        It 'Should return correct LinesOfCode metric for the function Format-FileCoverage' {
            $FormatFileCoverage.LinesOfCode | Should Be 24
        }
        It 'Should return correct ScriptAnalyzerFindings metric for the function Format-FileCoverage' {
            $FormatFileCoverage.ScriptAnalyzerFindings | Should Be 0
        }
        It 'Should return correct TestCoverage metric for the function Format-FileCoverage' {
            $FormatFileCoverage.TestCoverage | Should Be 100
        }
        It 'Should return correct CommandsMissed metric for the function Format-FileCoverage' {
            $FormatFileCoverage.CommandsMissed | Should Be 0
        }
        It 'Should return correct Complexity metric for the function Format-FileCoverage' {
            $FormatFileCoverage.Complexity | Should Be 2
        }
        It 'Should return correct MaximumNestingDepth metric for the function Format-FileCoverage' {
            $FormatFileCoverage.MaximumNestingDepth | Should Be 1
        }
        It 'Should return correct LinesOfCode metric for the function Format-Coverage' {
            $FormatCoverage.LinesOfCode | Should Be 39
        }
        It 'Should return correct ScriptAnalyzerFindings metric for the function Format-Coverage' {
            $FormatCoverage.ScriptAnalyzerFindings | Should Be 0
        }
        It 'Should return correct TestCoverage metric for the function Format-Coverage' {
            $FormatCoverage.TestCoverage | Should Be 0
        }
        It 'Should return correct CommandsMissed metric for the function Format-Coverage' {
            $FormatCoverage.CommandsMissed | Should Be 20
        }
        It 'Should return correct Complexity metric for the function Format-Coverage' {
            $FormatCoverage.Complexity | Should Be 3
        }
        It 'Should return correct MaximumNestingDepth metric for the function Format-Coverage' {
            $FormatCoverage.MaximumNestingDepth | Should Be 1
        }
        It 'Should return correct LinesOfCode metric for the function Get-CoveragePercentage' {
            $GetCoveragePercentage.LinesOfCode | Should Be 17
        }
        It 'Should return correct ScriptAnalyzerFindings metric for the function Get-CoveragePercentage' {
            $GetCoveragePercentage.ScriptAnalyzerFindings | Should Be 1
        }
        It 'Should return correct TestCoverage metric for the function Get-CoveragePercentage' {
            $GetCoveragePercentage.TestCoverage | Should Be 100
        }
        It 'Should return correct CommandsMissed metric for the function Get-CoveragePercentage' {
            $GetCoveragePercentage.CommandsMissed | Should Be 0
        }
        It 'Should return correct Complexity metric for the function Get-CoveragePercentage' {
            $GetCoveragePercentage.Complexity | Should Be 2
        }
        It 'Should return correct MaximumNestingDepth metric for the function Get-CoveragePercentage' {
            $GetCoveragePercentage.MaximumNestingDepth | Should Be 1
        }
    }
    Context 'Given code in coveralls module, it returns the expected PSCodeHealthReport' {

        It 'The health report should have the expected Files property' {
            $Result.Files | Should Be 3
        }
        It 'The health report should have the expected Functions property' {
            $Result.Functions | Should Be 9
        }
        It 'The health report should have the expected LinesOfCodeTotal property' {
            $Result.LinesOfCodeTotal | Should Be 204
        }
        It 'The health report should have the expected LinesOfCodeAverage property' {
            $Result.LinesOfCodeAverage | Should Be 22.67
        }
        It 'The health report should have the expected ScriptAnalyzerFindingsTotal property' {
            $Result.ScriptAnalyzerFindingsTotal | Should Be 4
        }
        It 'The health report should have the expected FunctionsWithoutHelp property' {
            $Result.FunctionsWithoutHelp | Should Be 9
        }
        It 'The health report should have the expected NumberOfTests property' {
            $Result.NumberOfTests | Should Be 13
        }
        It 'The health report should have the expected NumberOfFailedTests property' {
            $Result.NumberOfFailedTests | Should Be 2
        }
        It 'The health report should have 2 objects in its "FailedTestsDetails" property' {
            $Result.FailedTestsDetails.Count | Should Be 2
        }
        It 'The health report should have the expected "File" values in its FailedTestsDetails property' {
            Foreach ( $FailedTestsDetail in $Result.FailedTestsDetails ) {
                $FailedTestsDetail.File | Should Be 'Coveralls.Tests.ps1'
            }
        }
        It 'The health report should have the expected "Line" values in its FailedTestsDetails property' {
            Foreach ( $FailedTestsDetail in $Result.FailedTestsDetails ) {
                $FailedTestsDetail.Line | Should BeIn @('97','100')
            }
        }
        It 'The health report should have the expected "Describe" values in its FailedTestsDetails property' {
            Foreach ( $FailedTestsDetail in $Result.FailedTestsDetails ) {
                $FailedTestsDetail.Describe | Should Be 'Get-CoverageArray'
            }
        }
        It 'The health report should have the expected "TestName" values in its FailedTestsDetails property' {
            Foreach ( $FailedTestsDetail in $Result.FailedTestsDetails ) {
                $FailedTestsDetail.TestName | Should BeIn @('Should return 2 objects with the value 1','Should return 0 objects with the value 0')
            }
        }
        It 'The health report should have the expected "ErrorMessage" values in its FailedTestsDetails property' {
            Foreach ( $FailedTestsDetail in $Result.FailedTestsDetails ) {
                $FailedTestsDetail.ErrorMessage | Should BeLike 'Expected*'
            }
        }
        It 'The health report should have the expected NumberOfPassedTests property' {
            $Result.NumberOfPassedTests | Should Be 11
        }
        It 'The health report should have the expected TestsPassRate property' {
            $Result.TestsPassRate | Should Be 84.62
        }
        It 'The health report should have the expected TestCoverage property' {
            $Result.TestCoverage | Should Be 39.6
        }
        It 'The health report should have the expected CommandsMissedTotal property' {
            $Result.CommandsMissedTotal | Should Be 61
        }
        It 'The health report should have the expected ComplexityAverage property' {
            $Result.ComplexityAverage | Should Be 2
        }
        It 'Should return an object with the expected property "ComplexityHighest"' {
            $Result.ComplexityHighest | Should Be 5
        }
        It 'The health report should have the expected NestingDepthAverage property' {
            $Result.NestingDepthAverage | Should Be 1.11
        }
        It 'Should return an object with the expected property "NestingDepthHighest"' {
            $Result.NestingDepthHighest | Should Be 3
        }
    }
}