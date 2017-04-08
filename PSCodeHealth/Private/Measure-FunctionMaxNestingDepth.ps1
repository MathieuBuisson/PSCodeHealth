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
    Measure-FunctionMaxNestingDepth -FunctionDefinition $MyFunctionAst

    Gets the depth of the most deeply nested statement in the specified function definition.

.OUTPUTS
    System.Int32

.NOTES
    
#>
    [CmdletBinding()]
    [OutputType([System.Int32])]
    Param (
        [Parameter(Position=0, Mandatory=$True)]
        [System.Management.Automation.Language.FunctionDefinitionAst]$FunctionDefinition
    )

    $FunctionText = $FunctionDefinition.Extent.Text
    $Tokens = $Null
    $Null = [System.Management.Automation.Language.Parser]::ParseInput($FunctionText, [ref]$Tokens, [ref]$Null)

    [System.Collections.ArrayList]$NestingDepthValues = @()
    [System.Int32]$NestingDepth = 0
    [System.Collections.ArrayList]$CurlyBrackets = $Tokens | Where-Object { $_.Kind -in 'AtCurly','LCurly','RCurly' }

    # Removing the first opening curly and the last closing curly because they belong to the function itself
    $CurlyBrackets.RemoveAt(0)
    $CurlyBrackets.RemoveAt(($CurlyBrackets.Count - 1))
    If ( -not $CurlyBrackets ) {
        return $NestingDepth
    }

    Foreach ( $CurlyBracket in $CurlyBrackets ) {

        If ( $CurlyBracket.Kind -in 'AtCurly','LCurly' ) {
            $NestingDepth++
        }
        ElseIf ( $CurlyBracket.Kind -eq 'RCurly' ) {
            $NestingDepth--
        }
        $NestingDepthValues += $NestingDepth
    }
        Write-VerboseOutput -Message "Number of nesting depth values : $($NestingDepthValues.Count)"
        $MaxDepthValue = ($NestingDepthValues | Measure-Object -Maximum).Maximum -as [System.Int32]
        return $MaxDepthValue
}