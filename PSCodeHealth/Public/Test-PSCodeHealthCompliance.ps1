Function Test-PSCodeHealthCompliance {
<#
.SYNOPSIS
    Get the PSCodeHealth settings (metrics thresholds, etc...) which are currently in effect.  

.DESCRIPTION
    Get the PSCodeHealth settings (metrics warning and fail thresholds, etc...) which are currently in effect.  
    By default, all the settings are coming from the file PSCodeHealthSettings.json in the module root.  

    Custom settings can be specified in JSON format in a file, via the parameter CustomSettingsPath.  
    In this case, any setting specified in the custom settings file override the default, and settings not specified in the custom settings file will use the defaults from PSCodeHealthSettings.json.  

.PARAMETER CustomSettingsPath
    To specify the path of a file containing user-defined settings (metrics thresholds, etc...) in JSON format.  
    Any setting specified in this file override the default, and settings not specified in this file will use the default from PSCodeHealthSettings.json.  

.PARAMETER SettingsGroup
    To filter the output settings to only the settings located in the specified group.  
    There are 2 settings groups in PSCodeHealthSettings.json, so there are 2 possible values for this parameter : 'FunctionHealthRecordMetricsRules' and 'OverallHealthReportMetricsRules'.  
    Metrics in the FunctionHealthRecordMetricsRules group are generated for each individual function and metrics in the OverallHealthReportMetricsRules group are calculated for the entire file or folder specified in the 'Path' parameter of Invoke-PSCodeHealth.  
    If not specified, all the settings are output.  

.PARAMETER MetricName
    To filter the output settings to only the settings for the specified metric.  
    There is a large number of metrics, so for convenience, all the possible values are available via tab completion.

.EXAMPLE
    PS C:\> Test-PSCodeHealthCompliance

    Gets all the default PSCodeHealth settings (metrics warning and fail thresholds, etc...).

.EXAMPLE
    PS C:\> Test-PSCodeHealthCompliance -CustomSettingsPath .\MySettings.json -SettingsGroup OverallHealthReportMetricsRules

    Gets all PSCodeHealth settings (metrics warning and fail thresholds, etc...) in effect in the group 'OverallHealthReportMetricsRules'.  
    This also output any setting overriding the defaults because they were specified in the file MySettings.json.

.EXAMPLE
    PS C:\> Test-PSCodeHealthCompliance -MetricName TestCoverage

    Gets the default settings (metrics warning and fail thresholds) in effect for the metric(s) named 'TestCoverage'. In this case, this metric exists in both FunctionHealthRecordMetricsRules and OverallHealthReportMetricsRules, so the TestCoverage settings from both groups will be output.  

.OUTPUTS
    System.Management.Automation.PSCustomObject
#>
    [CmdletBinding()]
    [OutputType([PSCustomObject[]])]
    Param(
        [Parameter(Mandatory=$False,Position=0)]
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf })]
        [string]$CustomSettingsPath,

        [Parameter(Mandatory=$False,Position=1)]
        [ValidateSet('FunctionHealthRecordMetricsRules','OverallHealthReportMetricsRules')]
        [string]$SettingsGroup,

        [Parameter(Mandatory=$False,Position=2)]
        [ValidateSet('LinesOfCode','ScriptAnalyzerFindings','TestCoverage','Complexity','MaximumNestingDepth','LinesOfCodeTotal',
        'LinesOfCodeAverage','ScriptAnalyzerFindingsTotal','ScriptAnalyzerErrors','ScriptAnalyzerWarnings',
        'ScriptAnalyzerInformation','ScriptAnalyzerFindingsAverage','NumberOfFailedTests','TestsPassRate',
        'CommandsMissedTotal','ComplexityAverage','NestingDepthAverage')]
        [string]$MetricName
    )


}