Function Get-PSCodeHealthSetting {
<#
.SYNOPSIS
    Get the PSCodeHealth settings (metrics thresholds, etc...) which are currently in effect.  

.DESCRIPTION
    Get the PSCodeHealth settings (metrics thresholds, etc...) which are currently in effect.  
    By default, all the settings are coming from the file PSCodeHealthSettings.json in the module root.  

    Custom settings can be specified in JSON format in a file, via the parameter CustomSettingsPath.  
    In this case, any setting specified in the custom settings file override the default, and settings not specified in the custom settings file will use the defaults from PSCodeHealthSettings.json.  

.PARAMETER CustomSettingsPath
    To specify the path of a file containing user-defined settings (metrics thresholds, etc...) in JSON format.  
    Any setting specified in this file override the default, and settings not specified in this file will use the default from PSCodeHealthSettings.json.  

.PARAMETER SettingsGroup
    To filter the output settings to only the settings located in the specified group.  
    There 2 settings group in PSCodeHealthSettings.json, so there are 2 possible values for this parameter : 'FunctionHealthRecordMetricsRules' and 'OverallHealthReportMetricsRules'.  
    If not specified, all the settings are output.  

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

    $DefaultSettingsPath = "$PSScriptRoot\..\PSCodeHealthSettings.json"
    $DefaultSettings = ConvertFrom-Json (Get-Content -Path $DefaultSettingsPath -Raw)

    If ( $PSBoundParameters.ContainsKey('CustomSettingsPath') ) {
        Try {
            $CustomSettings = ConvertFrom-Json (Get-Content -Path $CustomSettingsPath -Raw) -ErrorAction Stop
        }
        Catch {
            Throw "An error occurred when attempting to convert JSON data from the file $CustomSettingsPath to an object. Please verify that the content of this file is in valid JSON format."
        }
    }
    
    If ( $CustomSettings ) {
        $SettingsInEffect = Merge-PSCodeHealthSetting -DefaultSettings $DefaultSettings -CustomSettings $CustomSettings
    }
    Else {
        $SettingsInEffect = $DefaultSettings
    }
    If ( $PSBoundParameters.ContainsKey('SettingsGroup') ) {
        $OutputSettings = $SettingsInEffect.$($PSBoundParameters.SettingsGroup)
        If ( $PSBoundParameters.ContainsKey('MetricName') ) {
            $OutputSettings = $OutputSettings.$($PSBoundParameters.MetricName)
        }
    }
    Else {
        $OutputSettings = $SettingsInEffect
        If ( $PSBoundParameters.ContainsKey('MetricName') ) {
            $SettingsGroupNames = ($OutputSettings | Get-Member -MemberType Properties).Name

            # There can be more than 1 object because a few metrics are available in both settings groups
            $MetricObjects = $SettingsGroupNames | ForEach-Object { $OutputSettings.$($_) } | Where-Object { $_.$($PSBoundParameters.MetricName) }
            $OutputSettings = $MetricObjects | ForEach-Object { $_.$($MetricName) }
        }
    }
    return $OutputSettings
}