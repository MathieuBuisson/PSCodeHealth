Function New-PSCodeHealthReport {
<#
.SYNOPSIS
    Creates a new custom object and gives it the TypeName : 'PSCodeHealth.Overall.HealthReport'.
.DESCRIPTION
    Creates a new custom object and gives it the TypeName : 'PSCodeHealth.Overall.HealthReport'.
    This output object contains metrics for the code in all the PowerShell files specified via the Path parameter, uses the function health records specified via the FunctionHealthRecord parameter.
    The value of the TestsPath parameter specifies the location of the tests when calling Pester to generate test coverage information.

.PARAMETER Path
    To specify the path of one or more PowerShell file(s) to analyze.

.PARAMETER FunctionHealthRecord
    To specify the PSCodeHealth.Function.HealthRecord objects which will be the basis for the report.

.PARAMETER TestsPath
    To specify the file or directory where the Pester tests are located.
    If a directory is specified, the directory and all subdirectories will be searched recursively for tests.

.EXAMPLE
    New-PSCodeHealthReport -Path $MyPath -FunctionHealthRecord $FunctionHealthRecords -TestsPath "$MyPath\Tests"

    Returns new custom object of the type PSCodeHealth.Overall.HealthReport, containing metrics for the code in all the PowerShell files in $MyPath, using the function health records in $FunctionHealthRecords and running all tests in "$MyPath\Tests" (and its subdirectories) to generate test coverage information.

.OUTPUTS
    PSCodeHealth.Overall.HealthReport

.NOTES
    
#>
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    Param (
        [Parameter(Position=0, Mandatory)]
        [string[]]$Path,

        [Parameter(Position=1, Mandatory)]
        [AllowNull()]
        [PSTypeName('PSCodeHealth.Function.HealthRecord')]
        [PSCustomObject[]]$FunctionHealthRecord,

        [Parameter(Position=2, Mandatory)]
        [validatescript({ Test-Path $_ })]
        [string]$TestsPath
    )

    # Getting ScriptAnalyzer findings from PowerShell manifests or data files and adding them to the report
    # because these findings don't show up in the FunctionHealthRecords
    $Psd1Files = $Path | Where-Object { $_ -like "*.psd1" }
    If ( $Psd1Files ) {
        $Psd1ScriptAnalyzerResults = $Psd1Files | ForEach-Object { Invoke-ScriptAnalyzer -Path $_ }
    }
    Else {
        $Psd1ScriptAnalyzerResults = $Null
    }

    # Gettings overall test coverage for all code in $Path
    $TestResult = Invoke-Pester -Script $TestsPath -CodeCoverage $Path -Show None -PassThru -Verbose:$False -WarningAction SilentlyContinue
    If ( $TestResult.CodeCoverage ) {
        $CodeCoverage = $TestResult.CodeCoverage
        $CommandsMissed = $CodeCoverage.NumberOfCommandsMissed
        Write-VerboseOutput -Message "Number of commands found in the function : $($CommandsMissed)"

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
    }

    $ObjectProperties = [ordered]@{
        'Files'                             = $Path.Count
        'Functions'                         = $FunctionHealthRecord.Count
        'LinesOfCodeTotal'                  = ($FunctionHealthRecord.LinesOfCode | Measure-Object -Sum).Sum
        'LinesOfCodeAverage'            = [math]::Round(($FunctionHealthRecord.LinesOfCode | Measure-Object -Average).Average, 2)
        'ScriptAnalyzerFindingsTotal'       = ($FunctionHealthRecord.ScriptAnalyzerFindings | Measure-Object -Sum).Sum + $Psd1ScriptAnalyzerResults.Count
        'ScriptAnalyzerFindingsAverage' = [math]::Round(($FunctionHealthRecord.ScriptAnalyzerFindings | Measure-Object -Average).Average, 2)
        'TestCoverage'                      = $CodeCoveragePerCent
        'CommandsMissedTotal'               = $CommandsMissed
        'ComplexityAverage'             = [math]::Round(($FunctionHealthRecord.Complexity | Measure-Object -Average).Average, 2)
        'NestingDepthAverage'           = [math]::Round(($FunctionHealthRecord.MaximumNestingDepth | Measure-Object -Average).Average, 2)
        'FunctionHealthRecords'             = $FunctionHealthRecord
    }

    $CustomObject = New-Object -TypeName PSObject -Property $ObjectProperties
    $CustomObject.psobject.TypeNames.Insert(0, 'PSCodeHealth.Overall.HealthReport')
    return $CustomObject
}