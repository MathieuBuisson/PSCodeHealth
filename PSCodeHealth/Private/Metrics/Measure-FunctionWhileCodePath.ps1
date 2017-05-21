Function Measure-FunctionWhileCodePath {
<#
.SYNOPSIS
    Gets the number of additional code paths due to While statements.
.DESCRIPTION
    Gets the number of additional code paths due to While statements, in the specified function definition.

.PARAMETER FunctionDefinition
    To specify the function definition to analyze.

.EXAMPLE
    PS C:\> Measure-FunctionWhileCodePath -FunctionDefinition $MyFunctionAst

    Gets the number of additional code paths due to While statements in the specified function definition.

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
    $WhileStatements = $FunctionAst.FindAll({ $args[0] -is [System.Management.Automation.Language.WhileStatementAst] }, $True)

    If ( -not($WhileStatements) ) {
        return [int]0
    }
    return $WhileStatements.Count
}