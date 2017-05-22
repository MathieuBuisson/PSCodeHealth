Function Measure-FunctionLogicalOpCodePath {
<#
.SYNOPSIS
    Gets the number of additional code paths due to Switch statements.
.DESCRIPTION
    Gets the number of additional code paths due to Switch statements, in the specified function definition.

.PARAMETER FunctionDefinition
    To specify the function definition to analyze.

.EXAMPLE
    PS C:\> Measure-FunctionLogicalOpCodePath -FunctionDefinition $MyFunctionAst

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
    $Tokens = $Null
    $Null = [System.Management.Automation.Language.Parser]::ParseInput($FunctionText, [ref]$Tokens, [ref]$Null)
    $LogicalOperators = $Tokens.Where({$_.Kind.ToString() -In 'And','Or','Xor'})

    If ( -not($LogicalOperators) ) {
        return [int]0
    }
    return $LogicalOperators.Count
}