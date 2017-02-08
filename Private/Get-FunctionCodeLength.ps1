Function Get-FunctionCodeLength {
<#
.SYNOPSIS
    Tells whether or not the specified function definition contains help information.
.DESCRIPTION
    Tells whether or not the specified function definition specified as a [System.Management.Automation.Language.FunctionDefinitionAst] contains help information (a CommentHelpInfo object).

.PARAMETER FunctionDefinition
    To specify the function definition to analyze.

.EXAMPLE
    Get-FunctionCodeLength -FunctionDefinition $MyFunctionAst

    Returns $True if the specified function definition contains help information, returns $False if not.

.OUTPUTS
    System.Boolean

.NOTES
    General notes
#>
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    Param (
        [Parameter(Position=0, Mandatory=$True)]
        [System.Management.Automation.Language.FunctionDefinitionAst]$FunctionDefinition
    )
    
    $FunctionText = $FunctionDefinition.Extent.Text
    $AstTokens = [System.Management.Automation.PSParser]::Tokenize($FunctionText, [ref]$Null)
    $NoCommentTokens = $AstTokens | Where-Object { $_.Type -ne 'Comment' }
    $NumberOfLines = ($NoCommentTokens | Where-Object { $_.Type -eq 'NewLine' }).Count - 1
}