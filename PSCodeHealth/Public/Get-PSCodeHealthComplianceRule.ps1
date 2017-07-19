Function Get-PSCodeHealthComplianceRule {
<#
.SYNOPSIS
    Get the PSCodeHealth compliance rules (metrics thresholds, etc...) which are currently in effect.  

.DESCRIPTION
    Get the PSCodeHealth compliance rules (metrics warning and fail thresholds, etc...) which are currently in effect.  
    By default, all the compliance rules are coming from the file PSCodeHealthSettings.json in the module root.  

    Custom compliance rules can be specified in JSON format in a file, via the parameter CustomSettingsPath.  
    In this case, any compliance rules specified in the custom settings file override the default, and rules not specified in the custom settings file will use the defaults from PSCodeHealthSettings.json.  

    By default, this function outputs compliance rules for every metrics in every settings groups, but this can filtered via the MetricName and the SettingsGroup parameters.  

.PARAMETER CustomSettingsPath
    To specify the path of a file containing user-defined compliance rules (metrics thresholds, etc...) in JSON format.  
    Any compliance rule specified in this file override the default, and rules not specified in this file will use the default from PSCodeHealthSettings.json.  

.PARAMETER SettingsGroup
    To filter the output compliance rules to only the ones located in the specified group.  
    There are 2 settings groups in PSCodeHealthSettings.json, so there are 2 possible values for this parameter : 'PerFunctionMetrics' and 'OverallMetrics'.  
    Metrics in the PerFunctionMetrics group are generated for each individual function and metrics in the OverallMetrics group are calculated for the entire file or folder specified in the 'Path' parameter of Invoke-PSCodeHealth.  
    If not specified, compliance rules from both groups are output.  

.PARAMETER MetricName
    To filter the output compliance rules to only the ones for the specified metric or metrics.  
    There is a large number of metrics, so for convenience, all the possible values are available via tab completion.

.EXAMPLE
    PS C:\> Get-PSCodeHealthComplianceRule

    Gets all the default PSCodeHealth compliance rules (metrics warning and fail thresholds, etc...).

.EXAMPLE
    PS C:\> Get-PSCodeHealthComplianceRule -CustomSettingsPath .\MySettings.json -SettingsGroup OverallMetrics

    Gets all PSCodeHealth compliance rules (metrics warning and fail thresholds, etc...) in effect in the group 'OverallMetrics'.  
    This also output any compliance rule overriding the defaults because they are specified in the file MySettings.json.

.EXAMPLE
    PS C:\> Get-PSCodeHealthComplianceRule -MetricName 'TestCoverage','Complexity','MaximumNestingDepth'

    Gets the default compliance rules in effect for the TestCoverage, Complexity and MaximumNestingDepth metrics.  
    In the case of TestCoverage, this metric exists in both PerFunctionMetrics and OverallMetrics, so the TestCoverage compliance rules from both groups will be output.  

.OUTPUTS
    PSCodeHealth.Compliance.Rule
#>
    [CmdletBinding()]
    [OutputType([PSCustomObject[]])]
    Param(
        [Parameter(Mandatory=$False,Position=0)]
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf })]
        [string]$CustomSettingsPath,

        [Parameter(Mandatory=$False,Position=1)]
        [ValidateSet('PerFunctionMetrics','OverallMetrics')]
        [string]$SettingsGroup,

        [Parameter(Mandatory=$False,Position=2)]
        [ValidateSet('LinesOfCode','ScriptAnalyzerFindings','TestCoverage','CommandsMissed','Complexity','MaximumNestingDepth','LinesOfCodeTotal',
        'LinesOfCodeAverage','ScriptAnalyzerFindingsTotal','ScriptAnalyzerErrors','ScriptAnalyzerWarnings',
        'ScriptAnalyzerInformation','ScriptAnalyzerFindingsAverage','NumberOfFailedTests','TestsPassRate',
        'CommandsMissedTotal','ComplexityAverage','ComplexityHighest','NestingDepthAverage','NestingDepthHighest')]
        [string[]]$MetricName
    )

    $MetricsGroups = @('PerFunctionMetrics','OverallMetrics')
    $DefaultSettingsPath = "$PSScriptRoot\..\PSCodeHealthSettings.json"
    $DefaultSettings = ConvertFrom-Json (Get-Content -Path $DefaultSettingsPath -Raw) -ErrorAction Stop | Where-Object { $_ }

    If ( $PSBoundParameters.ContainsKey('CustomSettingsPath') ) {
        Try {
            $CustomSettings = ConvertFrom-Json (Get-Content -Path $CustomSettingsPath -Raw) -ErrorAction Stop | Where-Object { $_ }
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
        If ( $PSBoundParameters.ContainsKey('MetricName') ) {
            $MetricsInGroup = $SettingsInEffect.$($SettingsGroup) | Where-Object { ($_ | Get-Member -MemberType Properties).Name -in $MetricName }
            Write-VerboseOutput "Found $($MetricsInGroup.Count) relevant metrics in the group $SettingsGroup"
            Foreach ( $MetricRule in $MetricsInGroup ) {
                New-PSCodeHealthComplianceRule -MetricRule $MetricRule -SettingsGroup $SettingsGroup
            }
        }
        Else {
            $MetricsInGroup = $SettingsInEffect.$($SettingsGroup)
            Write-VerboseOutput "Found $($MetricsInGroup.Count) relevant metrics in the group $SettingsGroup"
            Foreach ( $MetricRule in $MetricsInGroup ) {
                New-PSCodeHealthComplianceRule -MetricRule $MetricRule -SettingsGroup $SettingsGroup
            }
        }
    }
    Else {
        If ( $PSBoundParameters.ContainsKey('MetricName') ) {
            Foreach ( $MetricGroup in $MetricsGroups ) {

                $MetricsInGroup = $SettingsInEffect.$($MetricGroup) | Where-Object { ($_ | Get-Member -MemberType Properties).Name -in $MetricName }
                Write-VerboseOutput "Found $($MetricsInGroup.Count) relevant metrics in the group $MetricGroup"
                Foreach ( $MetricRule in $MetricsInGroup ) {
                    New-PSCodeHealthComplianceRule -MetricRule $MetricRule -SettingsGroup $MetricGroup
                }
            }
        }
        Else {
            Foreach ( $MetricGroup in $MetricsGroups ) {

                $MetricsInGroup = $SettingsInEffect.$($MetricGroup)
                Write-VerboseOutput "Found $($MetricsInGroup.Count) relevant metrics in the group $MetricGroup"
                Foreach ( $MetricRule in $MetricsInGroup ) {
                    New-PSCodeHealthComplianceRule -MetricRule $MetricRule -SettingsGroup $MetricGroup
                }
            }
        }
    }
}