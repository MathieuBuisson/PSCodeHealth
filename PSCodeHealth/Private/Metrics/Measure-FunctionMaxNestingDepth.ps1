Function Measure-FunctionMaxNestingDepth {
<#
.SYNOPSIS
    Gets the depth of the most deeply nested statement in the function.
.DESCRIPTION
    Gets the depth of the most deeply nested statement in the function.
    Measuring the maximum nesting depth in a function is a way of evaluating its complexity.

.PARAMETER FunctionDefinition
    To specify the function definition to analyze.

.EXAMPLE
    PS C:\> Measure-FunctionMaxNestingDepth -FunctionDefinition $MyFunctionAst

    Gets the depth of the most deeply nested statement in the specified function definition.

.OUTPUTS
    System.Int32

.LINK
    Additional information on why maximum nesting depth is an interesting measure of code complexity :
    https://www.cqse.eu/en/blog/mccabe-cyclomatic-complexity/
    
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

    [System.Collections.ArrayList]$NestingDepthValues = @()
    [System.Int32]$NestingDepth = 0
    [System.Collections.ArrayList]$CurlyBraces = $Tokens.Where({ $_.Kind -in 'AtCurly','LCurly','RCurly' })

    # Removing the first opening curly and the last closing curly because they belong to the function itself
    $CurlyBraces.RemoveAt(0)
    $CurlyBraces.RemoveAt(($CurlyBraces.Count - 1))
    If ( -not $CurlyBraces ) {
        return $NestingDepth
    }

    Foreach ( $CurlyBrace in $CurlyBraces ) {

        If ( $CurlyBrace.Kind -in 'AtCurly','LCurly' ) {
            $NestingDepth++
        }
        ElseIf ( $CurlyBrace.Kind -eq 'RCurly' ) {
            $NestingDepth--
        }
        $Null = $NestingDepthValues.Add($NestingDepth)
    }
        Write-VerboseOutput -Message "Number of nesting depth values : $($NestingDepthValues.Count)"
        $MaxDepthValue = ($NestingDepthValues | Measure-Object -Maximum).Maximum -as [System.Int32]
        return $MaxDepthValue
}