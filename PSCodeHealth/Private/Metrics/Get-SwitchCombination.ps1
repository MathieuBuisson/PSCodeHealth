Function Get-SwitchCombination {
<#
.SYNOPSIS
    Helper function to calculate the factorial of a given integer.
#>
    [CmdletBinding()]
    [OutputType([System.Int32])]
    Param(
        [Parameter(Position=0, Mandatory)]
        [System.Int32]$Integer
    )

    # The formula is 2 to the power of the input integer. This is based on :
    # https://math.stackexchange.com/questions/161565/what-is-the-total-number-of-combinations-of-5-items-together-when-there-are-no-d
    # But we don't substract 1, because the case where none of the Switch clause apply is a possibility which should be included.
    $CombinationsTotal = If ( $Integer -le 1 ) { $Integer } Else { [System.Math]::Pow(2,$Integer) }

    If ( $CombinationsTotal -ge [System.Int32]::MaxValue ) {
        return [System.Int32]::MaxValue
    }
    return ($CombinationsTotal -as [System.Int32])
}