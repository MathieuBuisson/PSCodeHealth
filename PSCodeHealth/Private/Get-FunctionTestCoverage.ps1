Function Get-FunctionTestCoverage {
<#
.SYNOPSIS
    Gets the percentage of lines of code in the specified function that are tested by unit tests.

.DESCRIPTION
    Gets the percentage of lines of code in the specified function definition that are tested (executed) by unit tests.
    It uses Pester with its CodeCoverage parameter.

.PARAMETER FunctionDefinition
    To specify the function definition to analyze.

.PARAMETER TestsPath
    To specify the file or directory where the Pester tests are located.
    If a directory is specified, the directory and all subdirectories will be searched recursively for tests.
    If not specified, the directory of the file containing the specified function, and all subdirectories will be searched for tests.

.EXAMPLE
    Get-FunctionTestCoverage -FunctionDefinition $MyFunctionAst -TestsPath $MyModule.ModuleBase

    Gets the percentage of lines of code in the function $MyFunctionAst that are tested by all tests found in the module's parent directory.

.OUTPUTS
    System.Double

.NOTES
    
#>
    [CmdletBinding()]
    [OutputType([System.Double])]
    Param (
        [Parameter(Position=0, Mandatory=$True)]
        [System.Management.Automation.Language.FunctionDefinitionAst]$FunctionDefinition,

        [Parameter(Position=1, Mandatory=$False)]
        [validatescript({ Test-Path $_ })]
        [string]$TestsPath
    )

    [string]$SourcePath = $FunctionDefinition.Extent.File
    $FunctionName = $FunctionDefinition.Name
    Write-VerboseOutput -Message "The function [$FunctionName] comes from the file :  $SourcePath"

    If ( -not $TestsPath ) {
        $TestsPath = Split-Path -Path $SourcePath -Parent
    }

    $TestResult = Invoke-Pester -Script $TestsPath -CodeCoverage @{ Path = $SourcePath; Function = $FunctionName } -PassThru -Show None -Verbose:$False

    If ( $TestResult.CodeCoverage ) {
        $CodeCoverage = $TestResult.CodeCoverage
        $CommandsFound = $CodeCoverage.NumberOfCommandsAnalyzed
        Write-VerboseOutput -Message "Number of commands found in the function : $($CommandsFound)"

        # To prevent any "Attempted to divide by zero" exceptions
        If ( $CommandsFound -ne 0 ) {
            $CommandsExercised = $CodeCoverage.NumberOfCommandsExecuted
            Write-VerboseOutput -Message "Number of commands exercised in the tests : $($CommandsExercised)"
            [System.Double]$CodeCoveragePerCent = [math]::Round(($CommandsExercised / $CommandsFound) * 100, 2)
        }
        Else {
            [System.Double]$CodeCoveragePerCent = 0
        }
        return $CodeCoveragePerCent
    }
}