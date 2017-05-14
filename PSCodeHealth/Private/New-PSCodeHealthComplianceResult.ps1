Function New-PSCodeHealthComplianceResult {
<#
.SYNOPSIS
    Creates a new custom object and gives it the TypeName : 'PSCodeHealth.Compliance.Result'.  

.DESCRIPTION
    Creates a new custom object based on a PSCodeHealth.Compliance.Rule object and a compliance result, and gives it the TypeName : 'PSCodeHealth.Compliance.Result'.  

.PARAMETER ComplianceRule
    The compliance rule which was evaluated.

.PARAMETER Value
    The value from the health report for the evaluated metric.

.PARAMETER Result
    The compliance result, based on the compliance rule and the actual value from the health report.

.EXAMPLE
    PS C:\> New-PSCodeHealthComplianceResult -ComplianceRule $Rule -Value 81.26 -Result Warning

    Returns new custom object of the type PSCodeHealth.Compliance.Result.

.OUTPUTS
    PSCodeHealth.Compliance.Result
#>
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    Param (
        [Parameter(Mandatory, Position=0)]
        [PSTypeName('PSCodeHealth.Compliance.Rule')]
        [PSCustomObject]$ComplianceRule,

        [Parameter(Mandatory, Position=1)]
        [PSObject]$Value,

        [Parameter(Mandatory, Position=2)]
        [ValidateSet('Fail','Warning','Pass')]
        [string]$Result
    )

    $ObjectProperties = [ordered]@{
        'SettingsGroup'    = $ComplianceRule.SettingsGroup
        'MetricName'       = $ComplianceRule.MetricName
        'WarningThreshold' = $ComplianceRule.WarningThreshold
        'FailThreshold'    = $ComplianceRule.FailThreshold
        'HigherIsBetter'   = $ComplianceRule.HigherIsBetter
        'Value'            = $Value
        'Result'           = $Result
    }

    $CustomObject = New-Object -TypeName PSObject -Property $ObjectProperties
    $CustomObject.psobject.TypeNames.Insert(0, 'PSCodeHealth.Compliance.Result')
    return $CustomObject
}