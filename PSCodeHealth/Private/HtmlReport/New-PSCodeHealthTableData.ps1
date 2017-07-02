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
`n                                            <button type="button" class="btn btn-sm cell-expand-collapse"> Expand</button>
                                            <table>`n
"@)
            Foreach ( $Finding in $Function.ScriptAnalyzerResultDetails ) {

                $ScriptName = Split-Path -Path $Function.FilePath -Leaf
                $FindingDetail = @"
                                                <tr>
                                                    <td class="cell-largeContent">ScriptName : $ScriptName<br>
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
                                        <td>$($Function.ScriptAnalyzerFindings)</td>
                                        <td>$($FindingsDetails)</td>
                                        <td>$($Function.ContainsHelp)</td>
                                    </tr>
"@
        $Null = $BestPracticesRows.Add($Row)
    }

    [System.Collections.ArrayList]$MaintainabilityRows = @()
    Foreach ( $Function in $HealthReport.FunctionHealthRecords ) {

        $Row = @"
                                    <tr>
                                        <td>$($Function.FunctionName)</td>
                                        <td>$($Function.LinesOfCode)</td>
                                        <td>$($Function.Complexity)</td>
                                        <td>$($Function.MaximumNestingDepth)</td>
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
                                        <td>$($Function.TestCoverage)</td>
                                        <td>$($Function.CommandsMissed)</td>
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