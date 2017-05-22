Function Get-FunctionLinesOfCode {
<#
.SYNOPSIS
    Gets the number of lines in the specified function definition (excluding comments).
.DESCRIPTION
    Gets the number of lines of code in the specified function definition specified as a [System.Management.Automation.Language.FunctionDefinitionAst].
    The single line comments, multiple lines comments and comment-based help are not executable code, so they are excluded.

.PARAMETER FunctionDefinition
    To specify the function definition to analyze.

.EXAMPLE
    PS C:\> Get-FunctionLinesOfCode -FunctionDefinition $MyFunctionAst

    Returns the number of lines of code in the specified function definition.

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
    Write-VerboseOutput -Message "Function name : $($FunctionDefinition.Name)"

    $AstTokens = [System.Management.Automation.PSParser]::Tokenize($FunctionText, [ref]$Null)
    $NoCommentTokens = $AstTokens.Where({ $_.Type -ne 'Comment' })

    # Substracting 1 from the number of lines if the last token is a NewLine
    [System.Int32]$NumberofLinesToSubstract = If ( $NoCommentTokens[-1].Type -eq 'NewLine' ) { 1 } Else { 0 }
    Write-VerboseOutput -Message "Number of lines to substract : $($NumberofLinesToSubstract)."

    [System.Int32]$NumberOfLines = ($NoCommentTokens.Where({ $_.Type -eq 'NewLine' })).Count - $NumberofLinesToSubstract
    return $NumberOfLines
}