Function Get-SwitchCombination {
<#
.SYNOPSIS
    Calculates the number of additional code paths, given the number of Switch clauses which don't contain a Break statement.

.DESCRIPTION
    Calculates the number of additional code paths, given the number of Switch clauses which don't contain a Break statement.  
    The formula is 2 to the power of the input integer. This is based on :
    https://math.stackexchange.com/questions/161565/what-is-the-total-number-of-combinations-of-5-items-together-when-there-are-no-d
    But we don't substract 1, because the case where none of the Switch clause apply is a possible code path which should be included.

.PARAMETER Integer
    The number of clauses in a given Switch statement which don't contain a Break statement.

.EXAMPLE
    PS C:\> Get-SwitchCombination -Integer 3

    Calculates the number of additional code paths due to 3 clauses which don't contain a Break statement in a Switch statement.

.OUTPUTS
    System.Int32

.NOTES
    https://math.stackexchange.com/a/161568
#>
    [CmdletBinding()]
    [OutputType([System.Int32])]
    Param(
        [Parameter(Position=0, Mandatory)]
        [System.Int32]$Integer
    )

    $CombinationsTotal = If ( $Integer -le 1 ) { $Integer } Else { [System.Math]::Pow(2,$Integer) }

    If ( $CombinationsTotal -ge [System.Int32]::MaxValue ) {
        return [System.Int32]::MaxValue
    }
    return ($CombinationsTotal -as [System.Int32])
}