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

.PARAMETER FunctionName
    To get compliance results for a specific function.  
    If this parameter is specified, this creates a PSCodeHealth.Compliance.FunctionResult object, instead of PSCodeHealth.Compliance.Result.

.EXAMPLE
    PS C:\> New-PSCodeHealthComplianceResult -ComplianceRule $Rule -Value 81.26 -Result Warning

    Returns new custom object of the type PSCodeHealth.Compliance.Result.

.EXAMPLE
    PS C:\> New-PSCodeHealthComplianceResult -ComplianceRule $Rule -Value 81.26 -Result Warning -FunctionName 'Get-Something'

    Returns new custom object of the type PSCodeHealth.Compliance.FunctionResult for the function 'Get-Something'.

.OUTPUTS
    PSCodeHealth.Compliance.Result, PSCodeHealth.Compliance.FunctionResult
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
        [string]$Result,

        [Parameter(Mandatory=$False, Position=3)]
        [string]$FunctionName
    )

    $PropsDictionary = [ordered]@{
        'SettingsGroup'    = $ComplianceRule.SettingsGroup
        'MetricName'       = $ComplianceRule.MetricName
        'WarningThreshold' = $ComplianceRule.WarningThreshold
        'FailThreshold'    = $ComplianceRule.FailThreshold
        'HigherIsBetter'   = $ComplianceRule.HigherIsBetter
        'Value'            = $Value
        'Result'           = $Result
    }

    If ( $PSBoundParameters.ContainsKey('FunctionName') ) {
        $PropsDictionary.Insert(0, 'FunctionName', $FunctionName)

        $CustomObject = New-Object -TypeName PSObject -Property $PropsDictionary
        $CustomObject.psobject.TypeNames.Insert(0, 'PSCodeHealth.Compliance.FunctionResult')
    }
    Else {
        $CustomObject = New-Object -TypeName PSObject -Property $PropsDictionary
        $CustomObject.psobject.TypeNames.Insert(0, 'PSCodeHealth.Compliance.Result')
    }
    return $CustomObject
}