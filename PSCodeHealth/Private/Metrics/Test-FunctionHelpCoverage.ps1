Function Test-FunctionHelpCoverage {
<#
.SYNOPSIS
    Tells whether or not the specified function definition contains help information.
.DESCRIPTION
    Tells whether or not the specified function definition specified as a [System.Management.Automation.Language.FunctionDefinitionAst] contains help information.
    This function returns $True if the specified function definition AST has a CommentHelpInfo or if the function name is listed in an external help file.

.PARAMETER FunctionDefinition
    To specify the function definition to analyze.

.EXAMPLE
    PS C:\> Test-FunctionHelpCoverage -FunctionDefinition $MyFunctionAst

    Returns $True if the specified function definition contains help information, returns $False if not.

.OUTPUTS
    System.Boolean

.NOTES
    
#>
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    Param (
        [Parameter(Position=0, Mandatory)]
        [System.Management.Automation.Language.FunctionDefinitionAst]$FunctionDefinition
    )
    
    $FunctionHelpInfo = $FunctionDefinition.GetHelpContent()
    [bool]$CommentBasedHelpPresent = $FunctionHelpInfo -is [System.Management.Automation.Language.CommentHelpInfo]
    
    [bool]$ExternalHelpPresent = $FunctionDefinition.Name -in $Script:ExternalHelpCommandNames
    $HelpPresent = $CommentBasedHelpPresent -or $ExternalHelpPresent
    return $HelpPresent
}
