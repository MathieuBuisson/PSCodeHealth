Function Measure-FunctionForCodePath {
<#
.SYNOPSIS
    Gets the number of additional code paths due to For loops.
.DESCRIPTION
    Gets the number of additional code paths due to For loops (where the For statement contains a condition), in the specified function definition.

.PARAMETER FunctionDefinition
    To specify the function definition to analyze.

.EXAMPLE
    PS C:\> Measure-FunctionForCodePath -FunctionDefinition $MyFunctionAst

    Gets the number of additional code paths due to for loops in the specified function definition.

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
    $ForStatements = $FunctionAst.FindAll({ $args[0] -is [System.Management.Automation.Language.ForStatementAst] }, $True)

    # Taking into account the rare cases where For statements don't contain a condition
    $ConditionalForStatements = $ForStatements | Where-Object Condition
    
    If ( -not($ConditionalForStatements) ) {
        return [int]0
    }
    return $ConditionalForStatements.Count
}