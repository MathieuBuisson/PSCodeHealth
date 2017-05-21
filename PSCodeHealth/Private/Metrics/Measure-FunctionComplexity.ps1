Function Measure-FunctionComplexity {
<#
.SYNOPSIS
    Measures the code complexity.
.DESCRIPTION
    Measures the code complexity, in the specified function definition.
    This complexity is measured according to the Cyclomatic complexity.
    Cyclomatic complexity counts the number of possible paths through a given section of code.
    The number of possible paths depends on the number of conditional logic constructs, because conditional logic constructs are where the flow of execution branches out to one or more different path(s).

.PARAMETER FunctionDefinition
    To specify the function definition to analyze.

.EXAMPLE
    PS C:\> Measure-FunctionComplexity -FunctionDefinition $MyFunctionAst

    Gets the number of additional code paths due to While statements in the specified function definition.

.OUTPUTS
    System.Int32

.NOTES
    For more information on Cyclomatic complexity, please refer to the following article
    https://en.wikipedia.org/wiki/Cyclomatic_complexity

    A simple example of measuring the Cyclomatic complexity of a piece od code can be found here :
    https://www.tutorialspoint.com/software_testing_dictionary/cyclomatic_complexity.htm
#>
    [CmdletBinding()]
    [OutputType([System.Int32])]
    Param (
        [Parameter(Position=0, Mandatory)]
        [System.Management.Automation.Language.FunctionDefinitionAst]$FunctionDefinition
    )
    # Default complexity value for code which contains no branching statement (1 code path)
    [int]$DefaultComplexity = 1

    $ForPaths = Measure-FunctionForCodePath -FunctionDefinition $FunctionDefinition
    Write-VerboseOutput -Message "Number of code paths due to For loops : $($ForPaths)"

    $IfPaths = Measure-FunctionIfCodePath -FunctionDefinition $FunctionDefinition
    Write-VerboseOutput -Message "Number of code paths due to If and ElseIf statements : $($IfPaths)"

    $LogicalOpPaths = Measure-FunctionLogicalOpCodePath -FunctionDefinition $FunctionDefinition
    Write-VerboseOutput -Message "Number of code paths due to logical operators : $($LogicalOpPaths)"

    $SwitchPaths = Measure-FunctionSwitchCodePath -FunctionDefinition $FunctionDefinition
    Write-VerboseOutput -Message "Number of code paths due to Switch statements : $($SwitchPaths)"

    $TrapCatchPaths = Measure-FunctionTrapCatchCodePath -FunctionDefinition $FunctionDefinition
    Write-VerboseOutput -Message "Number of code paths due to Trap statements and Catch clauses : $($TrapCatchPaths)"

    $WhilePaths = Measure-FunctionWhileCodePath -FunctionDefinition $FunctionDefinition
    Write-VerboseOutput -Message "Number of code paths due to While loops : $($WhilePaths)"

    [int]$TotalComplexity = $DefaultComplexity + $ForPaths + $IfPaths + $LogicalOpPaths + $SwitchPaths + $TrapCatchPaths + $WhilePaths
    return $TotalComplexity
}