Function Measure-FunctionTrapCatchCodePath {
<#
.SYNOPSIS
    Gets the number of additional code paths due to Trap statements and Catch clauses in Try statements.
.DESCRIPTION
    Gets the number of additional code paths due to Trap statements and Catch clauses in Try statements, in the specified function definition.

.PARAMETER FunctionDefinition
    To specify the function definition to analyze.

.EXAMPLE
    PS C:\> Measure-FunctionTrapCatchCodePath -FunctionDefinition $MyFunctionAst

    Gets the number of additional code paths due to Trap statements and Catch clauses in Try statements, in the specified function definition.

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
    $TrapStatements = $FunctionAst.FindAll({ $args[0] -is [System.Management.Automation.Language.TrapStatementAst] }, $True)
    $CatchClauses = $FunctionAst.FindAll({ $args[0] -is [System.Management.Automation.Language.CatchClauseAst] }, $True)

    [int]$ErrorHandlingCodePaths = $TrapStatements.Count + $CatchClauses.Count
    return $ErrorHandlingCodePaths
}