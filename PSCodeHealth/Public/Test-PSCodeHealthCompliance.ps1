Function Test-PSCodeHealthCompliance {
<#
.SYNOPSIS
    Gets the compliance level(s) of the analyzed PowerShell code, based on a PSCodeHealth report and compliance rules contained in PSCodeHealth settings.  

.DESCRIPTION
    Gets the compliance level(s) of the analyzed PowerShell code, based on a PSCodeHealth report and compliance rules contained in PSCodeHealth settings.  
    The values in the input PSCodeHealth report will be checked for compliance against the rules in the PSCodeHealth settings which are currently in effect.  
    By default, all compliance rules are coming from the file PSCodeHealthSettings.json in the module root. Custom compliance rules can be specified in JSON format in a file, via the parameter CustomSettingsPath.  

    The possible compliance levels are :  
      - Pass  
      - Warning  
      - Fail  
    
    By default, this function outputs the compliance levels for every metrics in every settings groups, but this can filtered via the MetricName and the SettingsGroup parameters.  

.PARAMETER HealthReport
    The PSCodeHealth report (object of the type PSCodeHealth.Overall.HealthReport) to analyze for compliance.  
    The ouput of the command Invoke-PSCodeHealth is a PSCodeHealth report and can be bound to this parameter via pipeline input.  

.PARAMETER CustomSettingsPath
    To specify the path of a file containing user-defined compliance rules (metrics thresholds, etc...) in JSON format.  
    Any compliance rule specified in this file override the default, and rules not specified in this file will use the default from PSCodeHealthSettings.json.  

.PARAMETER SettingsGroup
    To get compliance levels only for the metrics located in the specified group.  
    There are 2 settings groups in PSCodeHealthSettings.json, so there are 2 possible values for this parameter : 'PerFunctionMetrics' and 'OverallMetrics'.  
    Metrics in the PerFunctionMetrics group are for each individual function and metrics in the OverallMetrics group are for the entire file or folder specified in the 'Path' parameter of Invoke-PSCodeHealth.  
    If not specified, compliance levels for metrics in both groups are output.  

.PARAMETER MetricName
    To get compliance levels only for the specified metric or metrics.
    There is a large number of metrics, so for convenience, all the possible values are available via tab completion.

.EXAMPLE
    PS C:\> Test-PSCodeHealthCompliance -HealthReport $MyProjectHealthReport

    Gets the compliance levels for every metrics, based on the specified PSCodeHealth report ($MyProjectHealthReport) and the compliance rules in the default settings.

.EXAMPLE
    PS C:\> Invoke-PSCodeHealth | Test-PSCodeHealthCompliance

    Gets the compliance levels for every metrics, based on the PSCodeHealth report specified via pipeline input and the compliance rules in the default settings.

.EXAMPLE
    PS C:\> Test-PSCodeHealthCompliance -HealthReport $MyProjectHealthReport -CustomSettingsPath .\MySettings.json -SettingsGroup OverallMetrics

    Gets the compliance levels for the metrics in the settings group OverallMetrics, based on the specified PSCodeHealth report ($MyProjectHealthReport).  
    This checks compliance against compliance rules in the defaults compliance rules and any custom compliance rule from the file 'MySettings.json'.  

.EXAMPLE
    PS C:\> Test-PSCodeHealthCompliance -HealthReport $MyProjectHealthReport -MetricName 'TestCoverage','Complexity','MaximumNestingDepth'

    Gets the compliance levels for the TestCoverage, Complexity and MaximumNestingDepth metrics.  
    In the case of TestCoverage, this metric exists in both PerFunctionMetrics and OverallMetrics, so this outputs the compliance level for the TestCoverage metric from both groups.  

.OUTPUTS
    PSCodeHealth.Compliance.Result
#>
    [CmdletBinding()]
    [OutputType([PSCustomObject[]])]
    Param(
        [Parameter(Mandatory, Position=0, ValueFromPipeline=$True)]
        [PSTypeName('PSCodeHealth.Overall.HealthReport')]
        [PSCustomObject]$HealthReport,

        [Parameter(Mandatory=$False,Position=1)]
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf })]
        [string]$CustomSettingsPath,

        [Parameter(Mandatory=$False,Position=2)]
        [ValidateSet('PerFunctionMetrics','OverallMetrics')]
        [string]$SettingsGroup,

        [Parameter(Mandatory=$False,Position=3)]
        [ValidateSet('LinesOfCode','ScriptAnalyzerFindings','TestCoverage','Complexity','MaximumNestingDepth','LinesOfCodeTotal',
        'LinesOfCodeAverage','ScriptAnalyzerFindingsTotal','ScriptAnalyzerErrors','ScriptAnalyzerWarnings',
        'ScriptAnalyzerInformation','ScriptAnalyzerFindingsAverage','NumberOfFailedTests','TestsPassRate',
        'CommandsMissedTotal','ComplexityAverage','NestingDepthAverage')]
        [string[]]$MetricName
    )

    # First, we get the compliance rules for the specified metrics group and/or metric name(s) we are interested in
    $Null = $PSBoundParameters.Remove('HealthReport')
    $ComplianceRules = Get-PSCodeHealthComplianceRule @PSBoundParameters
    Write-VerboseOutput "Evaluating the specified health report against $($ComplianceRules.Count) compliance rules."

    # Now, we evaluate the values from the PSCodeHealth report against our compliance rules
    Foreach ( $ComplianceRule in $ComplianceRules ) {
        If ( $ComplianceRule.SettingsGroup -eq 'PerFunctionMetrics' ) {

            $MetricsFromReport = $HealthReport.FunctionHealthRecords.$($ComplianceRule.MetricName)
            If ( $MetricsFromReport ) {
                If ( $ComplianceRule.HigherIsBetter ) {
                    # We always retain the worst value of all the analyzed functions
                    $RetainedValue = ($MetricsFromReport | Measure-Object -Minimum).Minimum
                    Write-VerboseOutput "Retained value for $($ComplianceRule.MetricName) : $($RetainedValue)"

                    Switch ($RetainedValue) {
                        { $_ -lt $ComplianceRule.FailThreshold } { $ComplianceResult = 'Fail'; break}
                        { $_ -lt $ComplianceRule.WarningThreshold } { $ComplianceResult = 'Warning'; break}
                        Default { $ComplianceResult = 'Pass' }
                    }
                    New-PSCodeHealthComplianceResult -ComplianceRule $ComplianceRule -Value $RetainedValue -Result $ComplianceResult
                }
                Else {
                    # We always retain the worst value of all the analyzed functions
                    $RetainedValue = ($MetricsFromReport | Measure-Object -Maximum).Maximum
                    Write-VerboseOutput "Retained value for $($ComplianceRule.MetricName) : $($RetainedValue)"

                    Switch ($RetainedValue) {
                        { $_ -gt $ComplianceRule.FailThreshold } { $ComplianceResult = 'Fail'; break}
                        { $_ -gt $ComplianceRule.WarningThreshold } { $ComplianceResult = 'Warning'; break}
                        Default { $ComplianceResult = 'Pass' }
                    }
                    New-PSCodeHealthComplianceResult -ComplianceRule $ComplianceRule -Value $RetainedValue -Result $ComplianceResult
                }
            }
        }
        Else { # If the compliance rule is for an overall metric

            $MetricFromReport = $HealthReport.$($ComplianceRule.MetricName)
            If ( $MetricFromReport -or $MetricFromReport -eq 0 ) {
                If ( $ComplianceRule.HigherIsBetter ) {

                    Switch ($MetricFromReport) {
                        { $_ -lt $ComplianceRule.FailThreshold } { $ComplianceResult = 'Fail'; break}
                        { $_ -lt $ComplianceRule.WarningThreshold } { $ComplianceResult = 'Warning'; break}
                        Default { $ComplianceResult = 'Pass' }
                    }
                    New-PSCodeHealthComplianceResult -ComplianceRule $ComplianceRule -Value $MetricFromReport -Result $ComplianceResult
                }
                Else {

                    Switch ($MetricFromReport) {
                        { $_ -gt $ComplianceRule.FailThreshold } { $ComplianceResult = 'Fail'; break}
                        { $_ -gt $ComplianceRule.WarningThreshold } { $ComplianceResult = 'Warning'; break}
                        Default { $ComplianceResult = 'Pass' }
                    }
                    New-PSCodeHealthComplianceResult -ComplianceRule $ComplianceRule -Value $MetricFromReport -Result $ComplianceResult
                }
            }
        }
    }
}