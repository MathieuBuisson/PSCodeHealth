Function New-FunctionHealthRecord {
<#
.SYNOPSIS
    Creates a new custom object and gives it the TypeName : 'PSCodeHealth.Function.HealthRecord'.
.DESCRIPTION
    Creates a new custom object and gives it the TypeName : 'PSCodeHealth.Function.HealthRecord'.

.PARAMETER FunctionDefinition
    To specify the function definition.

.PARAMETER FunctionTestCoverage
    To specify the percentage of lines of code in the specified function that are tested by unit tests.

.EXAMPLE
    PS C:\> New-FunctionHealthRecord -FunctionDefinition $MyFunctionAst -FunctionTestCoverage $TestCoverage

    Returns new custom object of the type PSCodeHealth.Function.HealthRecord.

.OUTPUTS
    PSCodeHealth.Function.HealthRecord

.NOTES
    
#>
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    Param (
        [Parameter(Position=0, Mandatory)]
        [System.Management.Automation.Language.FunctionDefinitionAst]$FunctionDefinition,

        [Parameter(Position=1, Mandatory)]
        [AllowNull()]
        [PSTypeName('PSCodeHealth.Function.TestCoverageInfo')]
        [PSCustomObject]$FunctionTestCoverage
    )

    $ScriptAnalyzerResultDetails = Get-FunctionScriptAnalyzerResult -FunctionDefinition $FunctionDefinition

    $ObjectProperties = [ordered]@{
        'FunctionName'                = $FunctionDefinition.Name
        'FilePath'                    = $FunctionDefinition.Extent.File
        'LinesOfCode'                 = Get-FunctionLinesOfCode -FunctionDefinition $FunctionDefinition
        'ScriptAnalyzerFindings'      = $ScriptAnalyzerResultDetails.Count
        'ScriptAnalyzerResultDetails' = $ScriptAnalyzerResultDetails
        'ContainsHelp'                = Test-FunctionHelpCoverage -FunctionDefinition $FunctionDefinition
        'TestCoverage'                = $FunctionTestCoverage.CodeCoveragePerCent
        'CommandsMissed'              = ($FunctionTestCoverage.CommandsMissed | Measure-Object).Count
        'Complexity'                  = Measure-FunctionComplexity -FunctionDefinition $FunctionDefinition
        'MaximumNestingDepth'         = Measure-FunctionMaxNestingDepth -FunctionDefinition $FunctionDefinition
    }

    $CustomObject = New-Object -TypeName PSObject -Property $ObjectProperties
    $CustomObject.psobject.TypeNames.Insert(0, 'PSCodeHealth.Function.HealthRecord')
    return $CustomObject
}