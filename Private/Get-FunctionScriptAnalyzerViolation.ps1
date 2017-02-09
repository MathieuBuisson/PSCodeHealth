Function Get-FunctionScriptAnalyzerViolation {
<#
.SYNOPSIS
    Gets the number of best practices violations in the specified function definition, using PSScriptAnalyzer.
.DESCRIPTION
    Gets the number of best practices violations in the specified function definition specified as a [System.Management.Automation.Language.FunctionDefinitionAst].
    It uses the PSScriptAnalyzer PowerShell module.

.PARAMETER FunctionDefinition
    To specify the function definition to analyze.

.EXAMPLE
    Get-FunctionScriptAnalyzerViolation -FunctionDefinition $MyFunctionAst

    Returns the number of best practices violations (PSScriptAnalyzer results) in the specified function definition.

.OUTPUTS
    System.Int32

.NOTES
    General notes
#>
    [CmdletBinding()]
    [OutputType([System.Int32])]
    Param (
        [Parameter(Position=0, Mandatory=$True)]
        [System.Management.Automation.Language.FunctionDefinitionAst]$FunctionDefinition
    )
    
    Invoke-ScriptAnalyzer -ScriptDefinition $FunctionDefinition.Extent.Text
}