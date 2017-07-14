Function Set-PSCodeHealthHtmlColor {
<#
.SYNOPSIS
    Sets classes to the elements in the HTML report which use color coding to reflect their compliance, and returns the modified HTML.  

.DESCRIPTION
    Sets the class attribute to the elements in the HTML report which use color coding to reflect their compliance.  
    These classes corresponds to CSS declaration blocks to apply the appropriate styling to the elements, in particular the colors.  
    Then, it returns the modified HTML content to the caller.

.PARAMETER HealthReport
    To specify the input PSCodeHealth.Overall.HealthReport object containing the data.

.PARAMETER Compliance
    To input the overall compliance information, based on the current health report and the compliance rules.

.PARAMETER PerFunctionCompliance
    To input the per-function compliance information, based on the functions in the current health report and the compliance rules.

.PARAMETER Html
    To input the original HTML content (containing placeholders to be substituted with the appropriate class values).

.EXAMPLE
    Set-PSCodeHealthHtmlColor -HealthReport $HealthReport -Compliance $OverallCompliance -PerFunctionCompliance $PerFunctionCompliance -Html $HtmlContent  

    This sets classes to the elements in the HTML report which use color coding to reflect their compliance and returns the modified HTML content.

.OUTPUTS
    System.String

.NOTES    
#>
    [CmdletBinding()]
    [OutputType([string[]])]
    Param (
        [Parameter(Mandatory, Position=0)]
        [PSTypeName('PSCodeHealth.Overall.HealthReport')]
        [PSCustomObject]$HealthReport,

        [Parameter(Mandatory, Position=1)]
        [PSTypeName('PSCodeHealth.Compliance.Result')]
        [PSCustomObject[]]$Compliance,

        [Parameter(Mandatory, Position=2)]
        [AllowNull()]
        [PSTypeName('PSCodeHealth.Compliance.FunctionResult')]
        [PSCustomObject[]]$PerFunctionCompliance,

        [Parameter(Mandatory, Position=2)]
        [AllowEmptyString()]
        [string[]]$Html
    )

        Function ConvertTo-HtmlClass ($ComplianceResult) {
            Switch ($ComplianceResult) {
                'Fail' { return 'danger' }
                'Warning' { return 'warning' }
                'Pass' { return 'success' }
                $True { return 'success' }
                $False { return 'danger' }
            }
        }

        Function Get-FindingsHtmlClass ([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]]$Findings) {
            [string[]]$FindingsSeverity = $Findings.Severity
            If ( $FindingsSeverity -contains 'Error' ) {
                return 'danger'
            }
            If ( $FindingsSeverity -contains 'Warning' ) {
                return 'warning'
            }
            If ( $FindingsSeverity -contains 'Information' ) {
                return 'info'
            }
            return ''
        }

        $OverallPlaceholders = @{
            LINES_OF_CODE_TOTAL_COMPLIANCE = ConvertTo-HtmlClass $Compliance.Where({ $_.MetricName -eq 'LinesOfCodeTotal' }).Result
            SCRIPTANALYZER_TOTAL_COMPLIANCE = ConvertTo-HtmlClass $Compliance.Where({ $_.MetricName -eq 'ScriptAnalyzerFindingsTotal' }).Result
            SCRIPTANALYZER_ERRORS_COMPLIANCE = ConvertTo-HtmlClass $Compliance.Where({ $_.MetricName -eq 'ScriptAnalyzerErrors' }).Result
            SCRIPTANALYZER_WARNINGS_COMPLIANCE = ConvertTo-HtmlClass $Compliance.Where({ $_.MetricName -eq 'ScriptAnalyzerWarnings' }).Result
            SCRIPTANALYZER_INFO_COMPLIANCE = ConvertTo-HtmlClass $Compliance.Where({ $_.MetricName -eq 'ScriptAnalyzerInformation' }).Result
            TESTS_PASS_RATE_COMPLIANCE = ConvertTo-HtmlClass $Compliance.Where({ $_.MetricName -eq 'TestsPassRate' }).Result
            TEST_COVERAGE_COMPLIANCE = ConvertTo-HtmlClass $Compliance.Where({ $_.MetricName -eq 'TestCoverage' -and $_.SettingsGroup -eq 'OverallMetrics'}).Result
            SCRIPTANALYZER_AVERAGE_COMPLIANCE = ConvertTo-HtmlClass $Compliance.Where({ $_.MetricName -eq 'ScriptAnalyzerFindingsAverage' }).Result
            LINES_OF_CODE_AVERAGE_COMPLIANCE = ConvertTo-HtmlClass $Compliance.Where({ $_.MetricName -eq 'LinesOfCodeAverage' }).Result
            COMPLEXITY_AVERAGE_COMPLIANCE = ConvertTo-HtmlClass $Compliance.Where({ $_.MetricName -eq 'ComplexityAverage' }).Result
            NESTING_DEPTH_AVERAGE_COMPLIANCE = ConvertTo-HtmlClass $Compliance.Where({ $_.MetricName -eq 'NestingDepthAverage' }).Result
            NUMBER_OF_FAILED_TESTS_COMPLIANCE = ConvertTo-HtmlClass $Compliance.Where({ $_.MetricName -eq 'NumberOfFailedTests' }).Result
            COMMANDS_MISSED_TOTAL_COMPLIANCE = ConvertTo-HtmlClass $Compliance.Where({ $_.MetricName -eq 'CommandsMissedTotal' }).Result
            COMPLEXITY_HIGHEST_COMPLIANCE = ConvertTo-HtmlClass $Compliance.Where({ $_.MetricName -eq 'ComplexityHighest' }).Result
            NESTING_DEPTH_HIGHEST_COMPLIANCE = ConvertTo-HtmlClass $Compliance.Where({ $_.MetricName -eq 'NestingDepthHighest' }).Result
        }
        $HtmlOverall = Set-PSCodeHealthPlaceholdersValue -Html $Html -PlaceholdersData $OverallPlaceholders

        $HtmlFunction = $HtmlOverall
        Foreach ( $Function in $HealthReport.FunctionHealthRecords.FunctionName ) {

            $FunctionRecord = $HealthReport.FunctionHealthRecords.Where({ $_.FunctionName -eq $Function })

            $FunctionPlaceholders = @{
                "$($Function)_SCRIPTANALYZER_FINDINGS" = ConvertTo-HtmlClass $PerFunctionCompliance.Where({ $_.FunctionName -eq $Function -and $_.MetricName -eq 'ScriptAnalyzerFindings' }).Result
                "$($Function)_CONTAINS_HELP" = ConvertTo-HtmlClass $FunctionRecord.ContainsHelp
                "$($Function)_LINES_OF_CODE_COMPLIANCE" = ConvertTo-HtmlClass $PerFunctionCompliance.Where({ $_.FunctionName -eq $Function -and $_.MetricName -eq 'LinesOfCode' }).Result
                "$($Function)_COMPLEXITY_COMPLIANCE" = ConvertTo-HtmlClass $PerFunctionCompliance.Where({ $_.FunctionName -eq $Function -and $_.MetricName -eq 'Complexity' }).Result
                "$($Function)_MAXIMUM_NESTING_DEPTH_COMPLIANCE" = ConvertTo-HtmlClass $PerFunctionCompliance.Where({ $_.FunctionName -eq $Function -and $_.MetricName -eq 'MaximumNestingDepth' }).Result
                "$($Function)_TEST_COVERAGE_COMPLIANCE" = ConvertTo-HtmlClass $PerFunctionCompliance.Where({ $_.FunctionName -eq $Function -and $_.MetricName -eq 'TestCoverage' }).Result
                "$($Function)_COMMANDS_MISSED_COMPLIANCE" = ConvertTo-HtmlClass $PerFunctionCompliance.Where({ $_.FunctionName -eq $Function -and $_.MetricName -eq 'CommandsMissed' }).Result
                "$($Function)_FINDINGS_DETAILS" = Get-FindingsHtmlClass -Findings $FunctionRecord.ScriptAnalyzerResultDetails
            }
            $HtmlFunction = Set-PSCodeHealthPlaceholdersValue -Html $HtmlFunction -PlaceholdersData $FunctionPlaceholders
        }
        return $HtmlFunction
}