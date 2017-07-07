Function New-PSCodeHealthTableData {
<#
.SYNOPSIS
    Generate table rows for the HTML report, based on the data contained in a PSCodeHealth.Overall.HealthReport object.  

.DESCRIPTION
    Generate table rows for the HTML report, based on the data contained in a PSCodeHealth.Overall.HealthReport object.  
    This provides the rows for the following tables :  
      - Best Practices (per function)  
      - Maintainability (per function)  
      - Failed Tests Details  
      - Test Coverage (per function)  

.PARAMETER HealthReport
    To specify the input PSCodeHealth.Overall.HealthReport object containing the data.

.EXAMPLE
    New-PSCodeHealthTableData -HealthReport $HealthReport  

    This generates the rows for the tables Best Practices, Maintainability, Failed Tests Details and Test Coverage tables, based on the data in $HealthReport.  

.OUTPUTS
    PSCustomObject

.NOTES    
#>
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    Param (
        [Parameter(Mandatory, Position=0)]
        [PSTypeName('PSCodeHealth.Overall.HealthReport')]
        [PSCustomObject]$HealthReport
    )

    [System.Collections.ArrayList]$BestPracticesRows = @()
    Foreach ( $Function in $HealthReport.FunctionHealthRecords ) {

        If ( $Function.ScriptAnalyzerFindings -gt 0 ) {
            [System.Collections.ArrayList]$FindingsDetails = @()
            $Null = $FindingsDetails.Add(@"
`n                                            <button type="button" class="btn btn-{$($Function.FunctionName)_FINDINGS_DETAILS} btn-sm cell-expand-collapse"> Expand</button>
                                            <table>`n
"@)
            Foreach ( $Finding in $Function.ScriptAnalyzerResultDetails ) {

                $ScriptName = Split-Path -Path $Function.FilePath -Leaf
                $FindingDetail = @"
                                                <tr>
                                                    <td class="{$($Function.FunctionName)_FINDINGS_DETAILS} cell-largeContent">ScriptName : $ScriptName<br>
Line (in the function) : $($Finding.Line)<br>
Severity                      : $($Finding.Severity)<br>
RuleName                      : $($Finding.RuleName)<br>
Message                       : $($Finding.Message)<br>
                                                    </td>
                                                </tr>`n
"@
                $Null = $FindingsDetails.Add($FindingDetail)
            }
            $CloseTable = @"
                                            </table>`n                                        
"@
            $Null = $FindingsDetails.Add($CloseTable)
        }
        Else {
            [string]$FindingsDetails = ''
        }
        $Row = @"
                                    <tr>
                                        <td>$($Function.FunctionName)</td>
                                        <td class="{$($Function.FunctionName)_SCRIPTANALYZER_FINDINGS}">$($Function.ScriptAnalyzerFindings)</td>
                                        <td class="{$($Function.FunctionName)_FINDINGS_DETAILS}">$($FindingsDetails)</td>
                                        <td class="{$($Function.FunctionName)_CONTAINS_HELP}">$($Function.ContainsHelp)</td>
                                    </tr>
"@
        $Null = $BestPracticesRows.Add($Row)
    }

    [System.Collections.ArrayList]$MaintainabilityRows = @()
    Foreach ( $Function in $HealthReport.FunctionHealthRecords ) {

        $Row = @"
                                    <tr>
                                        <td>$($Function.FunctionName)</td>
                                        <td class="{$($Function.FunctionName)_LINES_OF_CODE_COMPLIANCE}">$($Function.LinesOfCode)</td>
                                        <td class="{$($Function.FunctionName)_COMPLEXITY_COMPLIANCE}">$($Function.Complexity)</td>
                                        <td class="{$($Function.FunctionName)_MAXIMUM_NESTING_DEPTH_COMPLIANCE}">$($Function.MaximumNestingDepth)</td>
                                    </tr>
"@
        $Null = $MaintainabilityRows.Add($Row)
    }

    If ( $HealthReport.NumberOfFailedTests -gt 0 ) {
        [System.Collections.ArrayList]$FailedTestsRows = @()
        Foreach ( $FailedTest in $HealthReport.FailedTestsDetails ) {
            
            $Row = @"
                                    <tr>
                                        <td>$($FailedTest.File)</td>
                                        <td>$($FailedTest.Line)</td>
                                        <td>$($FailedTest.Describe)</td>
                                        <td>$($FailedTest.TestName)</td>
                                        <td>$($FailedTest.ErrorMessage)</td>
                                    </tr>
"@
            $Null = $FailedTestsRows.Add($Row)
        }
    }
    Else {
        [string]$FailedTestsRows = ''
    }

    [System.Collections.ArrayList]$CoverageRows = @()
    Foreach ( $Function in $HealthReport.FunctionHealthRecords ) {

        $Row = @"
                                    <tr>
                                        <td>$($Function.FunctionName)</td>
                                        <td class="{$($Function.FunctionName)_TEST_COVERAGE_COMPLIANCE}">$($Function.TestCoverage)</td>
                                        <td class="{$($Function.FunctionName)_COMMANDS_MISSED_COMPLIANCE}">$($Function.CommandsMissed)</td>
                                    </tr>
"@
        $Null = $CoverageRows.Add($Row)
    }

    $ObjectProperties = [ordered]@{
        'BestPracticesRows'   = $BestPracticesRows
        'MaintainabilityRows' = $MaintainabilityRows
        'FailedTestsRows'     = $FailedTestsRows
        'CoverageRows'        = $CoverageRows
    }

    $CustomObject = New-Object -TypeName PSObject -Property $ObjectProperties
    return $CustomObject
}