Function New-PSCodeHealthComplianceRule {
<#
.SYNOPSIS
    Creates a new custom object and gives it the TypeName : 'PSCodeHealth.Compliance.Rule'.
.DESCRIPTION
    Creates a new custom object and gives it the TypeName : 'PSCodeHealth.Compliance.Rule'.

.PARAMETER MetricRule
    To specify the original metric rule object.

.PARAMETER SettingsGroup
    To specify from which settings group the current metric rule comes from.

.EXAMPLE
    PS C:\> New-PSCodeHealthComplianceRule -MetricRule $MetricRule -SettingsGroup PerFunctionMetrics

    Returns new custom object of the type PSCodeHealth.Compliance.Rule.

.OUTPUTS
    PSCodeHealth.Compliance.Rule
#>
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    Param (
        [Parameter(Mandatory, Position=0)]
        [PSCustomObject]$MetricRule,

        [Parameter(Mandatory, Position=1)]
        [ValidateSet('PerFunctionMetrics','OverallMetrics')]
        [string]$SettingsGroup
    )

    $MetricName = ($MetricRule | Get-Member -MemberType Properties).Name

    $ObjectProperties = [ordered]@{
        'SettingsGroup'    = $SettingsGroup
        'MetricName'       = $MetricName
        'WarningThreshold' = $MetricRule.$($MetricName).WarningThreshold
        'FailThreshold'    = $MetricRule.$($MetricName).FailThreshold
        'HigherIsBetter'   = $MetricRule.$($MetricName).HigherIsBetter
    }

    $CustomObject = New-Object -TypeName PSObject -Property $ObjectProperties
    $CustomObject.psobject.TypeNames.Insert(0, 'PSCodeHealth.Compliance.Rule')
    return $CustomObject
}