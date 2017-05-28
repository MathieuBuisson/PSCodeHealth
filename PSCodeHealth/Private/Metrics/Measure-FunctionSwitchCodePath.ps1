Function Measure-FunctionSwitchCodePath {
<#
.SYNOPSIS
    Gets the number of additional code paths due to Switch statements.
.DESCRIPTION
    Gets the number of additional code paths due to Switch statements, in the specified function definition.

.PARAMETER FunctionDefinition
    To specify the function definition to analyze.

.EXAMPLE
    PS C:\> Measure-FunctionSwitchCodePath -FunctionDefinition $MyFunctionAst

    Gets the number of additional code paths due to Switch statements in the specified function definition.

.OUTPUTS
    System.Int32

.NOTES
    
#>
    [CmdletBinding()]
    [OutputType([System.Int32])]
    Param (
        [Parameter(Position=0, Mandatory)]
        [System.Management.Automation.Language.FunctionDefinitionAst]$FunctionDefinition
    )
    
    $FunctionText = $FunctionDefinition.Extent.Text

    # Converting the function definition to a generic ScriptBlockAst because the FindAll method of FunctionDefinitionAst object work strangely
    $FunctionAst = [System.Management.Automation.Language.Parser]::ParseInput($FunctionText, [ref]$null, [ref]$null)
    $SwitchStatements = $FunctionAst.FindAll({ $args[0] -is [System.Management.Automation.Language.SwitchStatementAst] }, $True)

    If ( -not($SwitchStatements) ) {
        return [int]0
    }
    [int]$SwitchCodePaths = 0
    Foreach ( $SwitchStatement in $SwitchStatements ) {
        [int]$ClausesWithBreak = (@($SwitchStatement.Clauses).Where({ $_ -match 'Break' })).Count
        [int]$ClausesWithoutBreak = (@($SwitchStatement.Clauses).Where({ $_ -notmatch 'Break' })).Count
        $SwitchCodePaths += ($ClausesWithBreak + (Get-SwitchCombination -Integer $ClausesWithoutBreak))
    }
    # Each clause is creating an additional path, except for the "catch-all" Default clause
    return $SwitchCodePaths
}