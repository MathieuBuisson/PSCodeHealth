Function New-FunctionHealthRecord {
<#
.SYNOPSIS
    Creates a new custom object and gives it the TypeName : 'PSCodeHealth.Function.HealthRecord'.
.DESCRIPTION
    Creates a new custom object and gives it the TypeName : 'PSCodeHealth.Function.HealthRecord'.

.PARAMETER FunctionDefinition
    To specify the function definition.

.PARAMETER CodeLength
    To specify the number of code lines in the function definition.

.PARAMETER ScriptAnalyzerViolations
    To specify the number of best practices violation found in the function.

.PARAMETER ScriptAnalyzerResultDetails
    To populate the PSScriptAnalyzer results found in the function

.PARAMETER ContainsHelp
    To specify whether or not, the function contains help information.

.PARAMETER TestCoverage
    To specify the percentage of lines of code in the specified function that are tested by unit tests.

.EXAMPLE
    New-FunctionHealthRecord -FunctionDefinition $MyFunctionAst

    Returns new custom object of the type PSCodeHealth.Function.HealthRecord.

.OUTPUTS
    PSCodeHealth.Function.HealthRecord

.NOTES
    General notes
#>
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    Param (
        [Parameter(Position=0, Mandatory)]
        [System.Management.Automation.Language.FunctionDefinitionAst]$FunctionDefinition,

        [Parameter(Position=1, Mandatory)]
        [System.Int32]$CodeLength,

        [Parameter(Position=2, Mandatory)]
        [System.Int32]$ScriptAnalyzerViolations,

        [Parameter(Position=3, Mandatory)]
        [AllowNull()]
        [Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]]$ScriptAnalyzerResultDetails,

        [Parameter(Position=4, Mandatory)]
        [System.Boolean]$ContainsHelp,

        [Parameter(Position=5, Mandatory)]
        [System.Double]$TestCoverage
    )
    
        $ObjectProperties = [ordered]@{
            'Name' = $FunctionDefinition.Name
            'FilePath' = $FunctionDefinition.Extent.File
            'CodeLength' = $CodeLength
            'ScriptAnalyzerViolations' = $ScriptAnalyzerViolations
            'ScriptAnalyzerResultDetails' = $ScriptAnalyzerResultDetails
            'ContainsHelp' = $ContainsHelp
            'TestCoverage' = $TestCoverage
        }

        $CustomObject = New-Object -TypeName PSObject -Property $ObjectProperties
        $CustomObject.psobject.TypeNames.Insert(0, 'PSCodeHealth.Function.HealthRecord')
        return $CustomObject
}