$ModuleName = 'PSCodeHealth'
Import-Module "$PSScriptRoot\..\..\$ModuleName\$($ModuleName).psd1" -Force
$CodePath = "$PSScriptRoot\..\TestData\coveralls"

Describe 'Invoke-PSCodeHealth' {

    $ReportPath = "$TestDrive\Report.html"
    Invoke-PSCodeHealth -Path $CodePath -HtmlReportPath $ReportPath
    $ReportContent = Get-Content -Path $ReportPath -Raw
    $ExpectedFunctionNames = @('Add-CoverageInfo','Merge-CoverageResult','Get-CoverageArray','Format-FileCoverage','Get-CommandsForFile','Get-GitInfo','Format-Coverage','Publish-Coverage','Get-CoveragePercentage')

    Context 'Given code in coveralls module, it generates an HTML report with the expected content' {

        It 'Should have the expected <title> element' {
            $ReportContent | Should Match '<title>PSCodeHealth Report - coveralls</title>'
        }
        It 'Should contain the expected CSS in the <style> element' {
            $ReportContent | Should Match '(?smi)(<style>?\s+header\s>\s\.row\s\{).+</style>'
        }
        It 'Should contain the expected javascript in the <script> element' {
            $ReportContent | Should Match '(?smi)(<script>?\s+Chart.pluginService.register.+\s+afterUpdate:\sfunction\s\(chart\)\s\{)'
        }
        It 'Should contain the correct heading' {
            $ReportContent | Should Match '\s+Code Health Report - <small>coveralls</small>'
        }
        It 'Should contain the correct value for the number of functions' {
            $ReportContent | Should Match '(?smi)(Number of Functions</h3>.\s+</div>.\s+<div class="panel-body">.\s+<h2>9</h2>)'
        }
        It 'Should contain the correct value for "Lines of Code - Total"' {
            $ReportContent | Should Match '(?smi)(Lines of Code - Total</h3>.\s+</div>.\s+<div class="panel-body">.\s+<h2>204</h2>)'
        }
        It 'Should contain the correct value for "ScriptAnalyzer Errors"' {
            $ReportContent | Should Match '(?smi)(ScriptAnalyzer Errors</h3>.\s+</div>.\s+<div class="panel-body">.\s+<h2>1</h2>)'
        }
        It 'Should contain the correct value for "ScriptAnalyzer Findings - Average"' {
            $ReportContent | Should Match '(?smi)(ScriptAnalyzer Findings - Average</h3>.\s+</div>.\s+<div class="panel-body">.\s+<h2>0.44</h2>)'
        }
        It 'Should contain the correct value for "ScriptAnalyzer Info"' {
            $ReportContent | Should Match '(?smi)(ScriptAnalyzer Info</h3>.\s+</div>.\s+<div class="panel-body">.\s+<h2>0</h2>)'
        }
        It 'Should contain the correct value for "Functions Without Help"' {
            $ReportContent | Should Match '(?smi)(Functions Without Help</h3>.\s+</div>.\s+<div class="panel-body">.\s+<h2>9</h2>)'
        }
        It 'Should contain the correct value for "Complexity - Highest"' {
            $ReportContent | Should Match '(?smi)(Complexity - Highest</h3>.\s+</div>.\s+<div class="panel-body">.\s+<h2>5</h2>)'
        }
        It 'Should contain the correct value for "Nesting Depth - Highest"' {
            $ReportContent | Should Match '(?smi)(Nesting Depth - Highest</h3>.\s+</div>.\s+<div class="panel-body">.\s+<h2>3</h2>)'
        }
        It 'Should contain the correct value for "Lines of Code - Average"' {
            $ReportContent | Should Match '(?smi)(Lines of Code - Average</h3>.\s+</div>.\s+<div class="panel-body">.\s+<h2>22.67</h2>)'
        }
        It 'Should contain the correct value for "Complexity - Average"' {
            $ReportContent | Should Match '(?smi)(Complexity - Average</h3>.\s+</div>.\s+<div class="panel-body">.\s+<h2>2</h2>)'
        }
        It 'Should contain the correct value for "Nesting Depth - Average"' {
            $ReportContent | Should Match '(?smi)(Nesting Depth - Average</h3>.\s+</div>.\s+<div class="panel-body">.\s+<h2>1.11</h2>)'
        }
        It 'Should contain the correct value for "Number of Tests"' {
            $ReportContent | Should Match '(?smi)(Number of Tests</h3>.\s+</div>.\s+<div class="panel-body">.\s+<h2>13</h2>)'
        }
        It 'Should contain the correct value for "Number of Failed Tests"' {
            $ReportContent | Should Match '(?smi)(Number of Failed Tests</h3>.\s+</div>.\s+<div class="panel-body">.\s+<h2>2</h2>)'
        }
        It 'Should contain the correct value for "Number of Passed Tests"' {
            $ReportContent | Should Match '(?smi)(Number of Passed Tests</h3>.\s+</div>.\s+<div class="panel-body">.\s+<h2>11</h2>)'
        }
        It 'Should contain the correct value for "Number of Missed Commands"' {
            $ReportContent | Should Match '(?smi)(Number of Missed Commands</h3>.\s+</div>.\s+<div class="panel-body">.\s+<h2>61</h2>)'
        }
        It 'Should contain the expected test "Should return 2 objects with the value 1" in the "Failed Tests Details" table' {
            $ReportContent | Should Match '(?smi)(<td>97</td>.+\s+<td>Get-CoverageArray</td>.+\s+<td>Should return 2 objects with the value 1</td>.+\s+)'
        }
        It 'Should contain the expected test "Should return 0 objects with the value 0" in the "Failed Tests Details" table' {
            $ReportContent | Should Match '(?smi)(<td>100</td>.+\s+<td>Get-CoverageArray</td>.+\s+<td>Should return 0 objects with the value 0</td>.+\s+)'
        }
        It 'Should contain 1 row per function in the "Per Function Information" table' {
            Foreach ( $FunctionName in $ExpectedFunctionNames ) {
                $ReportContent | Should Match "\s+<td>$FunctionName</td>"
            }
        }
        It 'Should contain the expected Best Practices row for the function "Add-CoverageInfo"' {
            $ReportContent | Should Match '(?smi)(<td>Add-CoverageInfo</td>.+<td class="success">0</td>.+<td class=""></td>.+<td class="danger">False</td>.+\s+</tr>)'
        }
        It 'Should contain the expected Best Practices row for the function "Merge-CoverageResult"' {
            $ReportContent | Should Match '(?smi)(<td>Merge-CoverageResult</td>.+<td class="success">0</td>.+<td class=""></td>.+<td class="danger">False</td>.+\s+</tr>)'
        }
        It 'Should contain the expected Best Practices row for the function "Format-Coverage"' {
            $ReportContent | Should Match '(?smi)(<td>Format-Coverage</td>.+<td class="success">0</td>.+<td class=""></td>.+<td class="danger">False</td>.+\s+</tr>)'
        }
        It 'Should contain the expected Best Practices row and button for the function "Get-CoverageArray"' {
            $ReportContent | Should Match '(?smi)(<td>Get-CoverageArray</td>.+<td class="success">2</td>.+<td class="danger">.+<button type="button" class="btn btn-danger btn-sm cell-expand-collapse"> Expand</button>)'
        }
        It 'Should contain the expected Best Practices row and button for the function "Get-GitInfo"' {
            $ReportContent | Should Match '(?smi)(<td>Get-GitInfo</td>.+<td class="success">1</td>.+<td class="warning">.+<button type="button" class="btn btn-warning btn-sm cell-expand-collapse"> Expand</button>)'
        }
        It 'Should contain the expected Maintainability row for the function "Get-CoverageArray"' {
            $ReportContent | Should Match '(?smi)(<td>Get-CoverageArray</td>.+<td class="warning">31</td>.+<td class="success">5</td>.+<td class="success">3</td>.+\s+</tr>)'
        }
        It 'Should contain the expected Maintainability row for the function "Get-CommandsForFile"' {
            $ReportContent | Should Match '(?smi)(<td>Get-CommandsForFile</td>.+<td class="success">16</td>.+<td class="success">1</td>.+<td class="success">1</td>.+\s+</tr>)'
        }
        It 'Should contain the expected Maintainability row for the function "Format-Coverage"' {
            $ReportContent | Should Match '(?smi)(<td>Format-Coverage</td>.+<td class="warning">39</td>.+<td class="success">3</td>.+<td class="success">1</td>.+\s+</tr>)'
        }
        It 'Should contain the expected Test Coverage row for the function "Add-CoverageInfo"' {
            $ReportContent | Should Match '(?smi)(<td>Add-CoverageInfo</td>.+<td class="danger">0</td>.+<td class="success">3</td>.+\s+</tr>)'
        }
        It 'Should contain the expected Test Coverage row for the function "Get-CoverageArray"' {
            $ReportContent | Should Match '(?smi)(<td>Get-CoverageArray</td>.+<td class="success">94.74</td>.+<td class="success">1</td>.+\s+</tr>)'
        }
        It 'Should contain the expected Test Coverage row for the function "Publish-Coverage"' {
            $ReportContent | Should Match '(?smi)(<td>Publish-Coverage</td>.+<td class="danger">0</td>.+<td class="warning">10</td>.+\s+</tr>)'
        }
        It 'Should contain the expected Test Coverage row for the function "Get-CoveragePercentage"' {
            $ReportContent | Should Match '(?smi)(<td>Get-CoveragePercentage</td>.+<td class="success">100</td>.+<td class="success">0</td>.+\s+</tr>)'
        }
    }
}