Function Test-FunctionHelpCoverage {
<#
.SYNOPSIS
    Tells whether or not the specified function definition contains help information.
.DESCRIPTION
    Tells whether or not the specified function definition specified as a [System.Management.Automation.Language.FunctionDefinitionAst] contains help information (a CommentHelpInfo object).

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
    $CommentBasedHelpPresent = $FunctionHelpInfo -is [System.Management.Automation.Language.CommentHelpInfo]
    $ExternalHelpPresent = $FunctionDefinition.Name -in $Script:ExternalHelpCommandNames
    $HelpPresent = $CommentBasedHelpPresent -or $ExternalHelpPresent
    return $HelpPresent
}