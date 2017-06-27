Function New-PSCodeHealthReport {
<#
.SYNOPSIS
    Creates a new custom object and gives it the TypeName : 'PSCodeHealth.Overall.HealthReport'.
.DESCRIPTION
    Creates a new custom object and gives it the TypeName : 'PSCodeHealth.Overall.HealthReport'.
    This output object contains metrics for the code in all the PowerShell files specified via the Path parameter, uses the function health records specified via the FunctionHealthRecord parameter.
    The value of the TestsPath parameter specifies the location of the tests when calling Pester to generate test coverage information.

.PARAMETER ReportTitle
    To specify the title of the health report.  
    This is mainly used when generating an HTML report.

.PARAMETER AnalyzedPath
    To specify the code path being analyzed.  
    This corresponds to the original Path value of Invoke-PSCodeHealth.

.PARAMETER Path
    To specify the path of one or more PowerShell file(s) to analyze.

.PARAMETER FunctionHealthRecord
    To specify the PSCodeHealth.Function.HealthRecord objects which will be the basis for the report.

.PARAMETER TestsPath
    To specify the file or directory where the Pester tests are located.
    If a directory is specified, the directory and all subdirectories will be searched recursively for tests.

.PARAMETER TestsResult
    To use an existing Pester tests result object for generating the following metrics :  
      - NumberOfTests  
      - NumberOfFailedTests  
      - FailedTestsDetails  
      - NumberOfPassedTests  
      - TestsPassRate (%)  
      - TestCoverage (%)  
      - CommandsMissedTotal  

.EXAMPLE
    PS C:\> New-PSCodeHealthReport -ReportTitle 'MyTitle' -AnalyzedPath 'C:\Folder' -Path $MyPath -FunctionHealthRecord $FunctionHealthRecords -TestsPath "$MyPath\Tests"

    Returns new custom object of the type PSCodeHealth.Overall.HealthReport, containing metrics for the code in all the PowerShell files in $MyPath, using the function health records in $FunctionHealthRecords and running all tests in "$MyPath\Tests" (and its subdirectories) to generate test coverage information.

.OUTPUTS
    PSCodeHealth.Overall.HealthReport

.NOTES
    
#>
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    Param (
        [Parameter(Position=0, Mandatory)]
        [string]$ReportTitle,

        [Parameter(Position=1, Mandatory)]
        [string]$AnalyzedPath,
        
        [Parameter(Position=2, Mandatory)]
        [string[]]$Path,

        [Parameter(Position=3, Mandatory)]
        [AllowNull()]
        [PSTypeName('PSCodeHealth.Function.HealthRecord')]
        [PSCustomObject[]]$FunctionHealthRecord,

        [Parameter(Position=4, Mandatory)]
        [ValidateScript({ Test-Path $_ })]
        [string]$TestsPath,

        [Parameter(Position=5, Mandatory=$False)]
        [PSCustomObject]$TestsResult
    )

    # Getting ScriptAnalyzer findings from PowerShell manifests or data files and adding them to the report
    # because these findings don't show up in the FunctionHealthRecords
    $Psd1Files = $Path | Where-Object { $_ -like "*.psd1" }
    If ( $Psd1Files ) {
        $Psd1ScriptAnalyzerResults = $Psd1Files | ForEach-Object { Invoke-ScriptAnalyzer -Path $_ }

        # Have to do that because even if $Psd1ScriptAnalyzerResults is Null, it adds 1 to the number of items in $AllScriptAnalyzerResults
        If ( $Psd1ScriptAnalyzerResults ) {
            $AllScriptAnalyzerResults = ($FunctionHealthRecord.ScriptAnalyzerResultDetails | Where-Object { $_ }) + $Psd1ScriptAnalyzerResults
        }
        Else {
            $AllScriptAnalyzerResults = ($FunctionHealthRecord.ScriptAnalyzerResultDetails | Where-Object { $_ })
        }
    }
    Else {
        $AllScriptAnalyzerResults = ($FunctionHealthRecord.ScriptAnalyzerResultDetails | Where-Object { $_ })
    }
    $ScriptAnalyzerErrors = $AllScriptAnalyzerResults | Where-Object Severity -EQ 'Error'
    $ScriptAnalyzerWarnings = $AllScriptAnalyzerResults | Where-Object Severity -EQ 'Warning'
    $ScriptAnalyzerInformation = $AllScriptAnalyzerResults | Where-Object Severity -EQ 'Information'

    # Gettings overall test coverage for all code in $Path
    If ( ($PSBoundParameters.ContainsKey('TestsResult')) ) {
        $TestsResult = $PSBoundParameters.TestsResult
    }
    Else {
        $OverallPesterParams = @{
            Script = $TestsPath
            CodeCoverage = $Path
            PassThru = $True
            Strict = $True
            Verbose = $False
            WarningAction = 'SilentlyContinue'
        }

        # Invoke-Pester didn't have the "Show" parameter prior to version 4.x
        $SuppressOutput = If ((Get-Module -Name Pester).Version.Major -lt 4) { @{Quiet = $True} } Else { @{Show = 'None'} }

        $TestsResult = Invoke-Pester @OverallPesterParams @SuppressOutput
    }
    If ( $TestsResult.CodeCoverage ) {
        $CodeCoverage = $TestsResult.CodeCoverage
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

    $FailedTestsDetails = If ($TestsResult.FailedCount -gt 0) { New-FailedTestsInfo -TestsResult $TestsResult } Else { $Null }

    $ObjectProperties = [ordered]@{
        'ReportTitle'                   = $ReportTitle
        'ReportDate'                    = Get-Date -Format u
        'AnalyzedPath'                  = $AnalyzedPath
        'Files'                         = $Path.Count
        'Functions'                     = $FunctionHealthRecord.Count
        'LinesOfCodeTotal'              = ($FunctionHealthRecord.LinesOfCode | Measure-Object -Sum).Sum
        'LinesOfCodeAverage'            = [math]::Round(($FunctionHealthRecord.LinesOfCode | Measure-Object -Average).Average, 2)
        'ScriptAnalyzerFindingsTotal'   = ($AllScriptAnalyzerResults | Measure-Object).Count
        'ScriptAnalyzerErrors'          = ($ScriptAnalyzerErrors | Measure-Object).Count
        'ScriptAnalyzerWarnings'        = ($ScriptAnalyzerWarnings | Measure-Object).Count
        'ScriptAnalyzerInformation'     = ($ScriptAnalyzerInformation | Measure-Object).Count
        'ScriptAnalyzerFindingsAverage' = [math]::Round(($FunctionHealthRecord.ScriptAnalyzerFindings | Measure-Object -Average).Average, 2)
        'FunctionsWithoutHelp'          = ($FunctionHealthRecord | Where-Object { -not($_.ContainsHelp) } | Measure-Object).Count
        'NumberOfTests'                 = If ( $TestsResult ) { $TestsResult.TotalCount } Else { 0 }
        'NumberOfFailedTests'           = If ( $TestsResult ) { $TestsResult.FailedCount } Else { 0 }
        'FailedTestsDetails'            = $FailedTestsDetails
        'NumberOfPassedTests'           = If ( $TestsResult ) { $TestsResult.PassedCount } Else { 0 }
        'TestsPassRate'                 = If ($TestsResult.TotalCount) { [math]::Round(($TestsResult.PassedCount / $TestsResult.TotalCount) * 100, 2) } Else { 0 }
        'TestCoverage'                  = $CodeCoveragePerCent
        'CommandsMissedTotal'           = $CommandsMissed
        'ComplexityAverage'             = [math]::Round(($FunctionHealthRecord.Complexity | Measure-Object -Average).Average, 2)
        'ComplexityHighest'             = [math]::Round(($FunctionHealthRecord.Complexity | Measure-Object -Maximum).Maximum, 2)
        'NestingDepthAverage'           = [math]::Round(($FunctionHealthRecord.MaximumNestingDepth | Measure-Object -Average).Average, 2)
        'NestingDepthHighest'           = [math]::Round(($FunctionHealthRecord.MaximumNestingDepth | Measure-Object -Maximum).Maximum, 2)
        'FunctionHealthRecords'         = $FunctionHealthRecord
    }

    $CustomObject = New-Object -TypeName PSObject -Property $ObjectProperties
    $CustomObject.psobject.TypeNames.Insert(0, 'PSCodeHealth.Overall.HealthReport')
    return $CustomObject
}