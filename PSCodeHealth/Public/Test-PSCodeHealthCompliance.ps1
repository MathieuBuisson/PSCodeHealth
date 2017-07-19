Function Test-PSCodeHealthCompliance {
<#
.SYNOPSIS
    Gets the compliance result(s) of the analyzed PowerShell code, based on a PSCodeHealth report and compliance rules contained in PSCodeHealth settings.  

.DESCRIPTION
    Gets the compliance result(s) of the analyzed PowerShell code, based on a PSCodeHealth report and compliance rules contained in PSCodeHealth settings.  
    The values in the input PSCodeHealth report will be checked for compliance against the rules in the PSCodeHealth settings which are currently in effect.  
    By default, all compliance rules are coming from the file PSCodeHealthSettings.json in the module root. Custom compliance rules can be specified in JSON format in a file, via the parameter CustomSettingsPath.  

    The possible compliance levels are :  
      - Pass  
      - Warning  
      - Fail  
    
    By default, this function outputs the compliance results for every metrics in every settings groups, but this can filtered via the MetricName and the SettingsGroup parameters.  

.PARAMETER HealthReport
    The PSCodeHealth report (object of the type PSCodeHealth.Overall.HealthReport) to analyze for compliance.  
    The ouput of the command Invoke-PSCodeHealth is a PSCodeHealth report and can be bound to this parameter via pipeline input.  

.PARAMETER CustomSettingsPath
    To specify the path of a file containing user-defined compliance rules (metrics thresholds, etc...) in JSON format.  
    Any compliance rule specified in this file override the default, and rules not specified in this file will use the default from PSCodeHealthSettings.json.  

.PARAMETER SettingsGroup
    To evaluate compliance only for the metrics located in the specified group.  
    There are 2 settings groups in PSCodeHealthSettings.json, so there are 2 possible values for this parameter : 'PerFunctionMetrics' and 'OverallMetrics'.  
    Metrics in the PerFunctionMetrics group are for each individual function and metrics in the OverallMetrics group are for the entire file or folder specified in the 'Path' parameter of Invoke-PSCodeHealth.  
    If not specified, compliance is evaluated for metrics in both groups.  

.PARAMETER MetricName
    To get compliance results only for the specified metric(s).
    There is a large number of metrics, so for convenience, all the possible values are available via tab completion.
    If not specified, compliance is evaluated for all metrics.

.PARAMETER FunctionName
    To get compliance results for a specific function.  
    This is a dynamic parameter which is available when the specified HealthReport contains at least 1 FunctionHealthRecords.  

.PARAMETER Summary
    To output a single overall compliance result based on all the evaluated metrics.  
    This retains the worst compliance level, meaning :  
      - If any evaluated metric has the 'Fail' compliance level, the overall result is 'Fail'  
      - If any evaluated metric has the 'Warning' compliance level and none has 'Fail', the overall result is 'Warning'  
      - If all evaluated metrics has the 'Pass' compliance level, the overall result is 'Pass'  

.EXAMPLE
    PS C:\> Test-PSCodeHealthCompliance -HealthReport $MyProjectHealthReport

    Gets the compliance results for every metrics, based on the specified PSCodeHealth report ($MyProjectHealthReport) and the compliance rules in the default settings.

.EXAMPLE
    PS C:\> Invoke-PSCodeHealth | Test-PSCodeHealthCompliance

    Gets the compliance results for every metrics, based on the PSCodeHealth report specified via pipeline input and the compliance rules in the default settings.

.EXAMPLE
    PS C:\> Test-PSCodeHealthCompliance -HealthReport $MyProjectHealthReport -CustomSettingsPath .\MySettings.json -SettingsGroup OverallMetrics

    Evaluates the compliance results for the metrics in the settings group OverallMetrics, based on the specified PSCodeHealth report ($MyProjectHealthReport).  
    This checks compliance against compliance rules in the defaults compliance rules and any custom compliance rule from the file 'MySettings.json'.  

.EXAMPLE
    PS C:\> Test-PSCodeHealthCompliance -HealthReport $MyProjectHealthReport -MetricName 'TestCoverage','Complexity','MaximumNestingDepth'

    Evaluates the compliance results only for the TestCoverage, Complexity and MaximumNestingDepth metrics.  
    In the case of TestCoverage, this metric exists in both PerFunctionMetrics and OverallMetrics, so this evaluates the compliance result for the TestCoverage metric from both groups.  

.EXAMPLE
    PS C:\> Test-PSCodeHealthCompliance -HealthReport $MyProjectHealthReport -FunctionName 'Get-Something'

    Evaluates the compliance results specifically for the function Get-Something. Because this is the compliance of a specific function, only the per function metrics are evaluated.  
    If the value of the FunctionName parameter doesn't match any function name in the HealthReport the parameter validation will fail and state the set of possible values.  

.EXAMPLE
    PS C:\> Invoke-PSCodeHealth | Test-PSCodeHealthCompliance -Summary

    Evaluates the compliance results for every metrics, based on the PSCodeHealth report specified via pipeline input and the compliance rules in the default settings.  
    This outputs an overall 'Fail','Warning' or 'Pass' value for all the evaluated metrics.


.OUTPUTS
    PSCodeHealth.Compliance.Result, PSCodeHealth.Compliance.FunctionResult, System.String
#>
    [CmdletBinding()]
    [OutputType([PSCustomObject[]], [string])]
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
        [ValidateSet('LinesOfCode','ScriptAnalyzerFindings','TestCoverage','CommandsMissed','Complexity','MaximumNestingDepth','LinesOfCodeTotal',
        'LinesOfCodeAverage','ScriptAnalyzerFindingsTotal','ScriptAnalyzerErrors','ScriptAnalyzerWarnings',
        'ScriptAnalyzerInformation','ScriptAnalyzerFindingsAverage','NumberOfFailedTests','TestsPassRate',
        'CommandsMissedTotal','ComplexityAverage','ComplexityHighest','NestingDepthAverage','NestingDepthHighest')]
        [string[]]$MetricName,

        [Parameter(Mandatory=$False)]
        [switch]$Summary
    )

    DynamicParam {
        # The FunctionName parameter is dynamic because the set of possible values depends on the FunctionHealthRecords contained in the specified HealthReport.
        If ( $HealthReport.FunctionHealthRecords.Count -gt 0 ) {
            
            $ParameterName = 'FunctionName'            
            # Creating a parameter dictionary 
            $RuntimeParameterDictionary = New-Object -TypeName System.Management.Automation.RuntimeDefinedParameterDictionary

            $AttributeCollection = New-Object -TypeName System.Collections.ObjectModel.Collection[System.Attribute]            
            $ValidationScriptAttribute = New-Object -TypeName System.Management.Automation.ParameterAttribute
            $ValidationScriptAttribute.Mandatory = $False
            $AttributeCollection.Add($ValidationScriptAttribute)
            # Generating dynamic values for a ValidateSet
            $SetValues = $HealthReport.FunctionHealthRecords.FunctionName
            $ValidateSetAttribute = New-Object -TypeName System.Management.Automation.ValidateSetAttribute($SetValues)
            # Adding the ValidateSet to the attributes collection
            $AttributeCollection.Add($ValidateSetAttribute)
            $RuntimeParameter = New-Object -TypeName System.Management.Automation.RuntimeDefinedParameter($ParameterName, [string], $AttributeCollection)
            $RuntimeParameterDictionary.Add($ParameterName, $RuntimeParameter)
            return $RuntimeParameterDictionary
        }
    }
    
    Begin {
        If ( $RuntimeParameterDictionary ) { $FunctionName = $RuntimeParameterDictionary[$ParameterName].Value }
        $Null = $PSBoundParameters.Remove('HealthReport')
        If ( $PSBoundParameters.ContainsKey('Summary') ) {
            $Null = $PSBoundParameters.Remove('Summary')
        }
        If ( $PSBoundParameters.ContainsKey('FunctionName') ) {
            $Null = $PSBoundParameters.Remove('FunctionName')
        }        
        [System.Collections.ArrayList]$ComplianceResults = @()
        $ComplianceRules = Get-PSCodeHealthComplianceRule @PSBoundParameters
        Write-VerboseOutput "Evaluating the specified health report against $($ComplianceRules.Count) compliance rules."
    }

    Process {
        $FunctionHealthRecords = If ($FunctionName) {$HealthReport.FunctionHealthRecords | Where-Object FunctionName -eq $FunctionName} Else {$HealthReport.FunctionHealthRecords}

        Foreach ( $ComplianceRule in $ComplianceRules ) {
            If ( $ComplianceRule.SettingsGroup -eq 'PerFunctionMetrics' ) {

                $MetricsFromReport = $FunctionHealthRecords.$($ComplianceRule.MetricName)
                If ( $Null -ne $MetricsFromReport ) {
                    If ( $ComplianceRule.HigherIsBetter ) {
                        # We always retain the worst value of all the analyzed functions
                        $RetainedValue = ($MetricsFromReport | Measure-Object -Minimum).Minimum
                        Write-VerboseOutput "Retained value for $($ComplianceRule.MetricName) : $($RetainedValue)"

                        Switch ($RetainedValue) {
                            { $_ -lt $ComplianceRule.FailThreshold } { $ComplianceResult = 'Fail'; break}
                            { $_ -lt $ComplianceRule.WarningThreshold } { $ComplianceResult = 'Warning'; break}
                            Default { $ComplianceResult = 'Pass' }
                        }

                        $ResultParams = @{
                            ComplianceRule = $ComplianceRule
                            Value = $RetainedValue
                            Result = $ComplianceResult
                        }
                        If ( $FunctionName ) {
                            $ComplianceResultObj = New-PSCodeHealthComplianceResult @ResultParams -FunctionName $FunctionName
                        }
                        Else {
                            $ComplianceResultObj = New-PSCodeHealthComplianceResult @ResultParams
                        }
                        $Null = $ComplianceResults.Add($ComplianceResultObj)
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

                        $ResultParams = @{
                            ComplianceRule = $ComplianceRule
                            Value = $RetainedValue
                            Result = $ComplianceResult
                        }
                        If ( $FunctionName ) {
                            $ComplianceResultObj = New-PSCodeHealthComplianceResult @ResultParams -FunctionName $FunctionName
                        }
                        Else {
                            $ComplianceResultObj = New-PSCodeHealthComplianceResult @ResultParams
                        }
                        $Null = $ComplianceResults.Add($ComplianceResultObj)
                    }
                }
            }
            ElseIf ( $ComplianceRule.SettingsGroup -eq 'OverallMetrics' -and -not($FunctionName) ) {
                $MetricFromReport = $HealthReport.$($ComplianceRule.MetricName)
                If ( $MetricFromReport -or $MetricFromReport -eq 0 ) {
                    If ( $ComplianceRule.HigherIsBetter ) {

                        Switch ($MetricFromReport) {
                            { $_ -lt $ComplianceRule.FailThreshold } { $ComplianceResult = 'Fail'; break}
                            { $_ -lt $ComplianceRule.WarningThreshold } { $ComplianceResult = 'Warning'; break}
                            Default { $ComplianceResult = 'Pass' }
                        }
                        $ComplianceResultObj = New-PSCodeHealthComplianceResult -ComplianceRule $ComplianceRule -Value $MetricFromReport -Result $ComplianceResult
                        $Null = $ComplianceResults.Add($ComplianceResultObj)
                    }
                    Else {

                        Switch ($MetricFromReport) {
                            { $_ -gt $ComplianceRule.FailThreshold } { $ComplianceResult = 'Fail'; break}
                            { $_ -gt $ComplianceRule.WarningThreshold } { $ComplianceResult = 'Warning'; break}
                            Default { $ComplianceResult = 'Pass' }
                        }
                        $ComplianceResultObj = New-PSCodeHealthComplianceResult -ComplianceRule $ComplianceRule -Value $MetricFromReport -Result $ComplianceResult
                        $Null = $ComplianceResults.Add($ComplianceResultObj)
                    }
                }
            }
        }
    }

    End {
        If ( $Summary ) {
            If ( $ComplianceResults.Result -contains 'Fail') {
                return 'Fail'
            }
            If ( $ComplianceResults.Result -contains 'Warning') {
                return 'Warning'
            }
            return 'Pass'
        }
        return $ComplianceResults
    }
}