Function Invoke-PSCodeHealth {
<#
.SYNOPSIS
    Gets quality and maintainability metrics for PowerShell code contained in scripts, modules or directories.

.DESCRIPTION
    Gets quality and maintainability metrics for PowerShell code contained in scripts, modules or directories.
    These metrics relate to :  
      - Length of functions  
      - Complexity of functions  
      - Code smells, styling issues and violations of best practices (using PSScriptAnalyzer)  
      - Tests and test coverage (using Pester to run tests)  
      - Comment-based help in functions  

.PARAMETER Path
    To specify the path of the directory to search for PowerShell files to analyze.  
    If the Path is not specified and the current location is in a FileSystem PowerShell drive, this will default to the current directory.

.PARAMETER TestsPath
    To specify the file or directory where tests are located.  
    If not specified, the command will look for tests in the same directory as each function.

.PARAMETER TestsResult
    To use an existing Pester tests result object for generating the following metrics :  
      - NumberOfTests  
      - NumberOfFailedTests  
      - NumberOfPassedTests  
      - TestsPassRate (%)  
      - TestCoverage (%)  
      - CommandsMissedTotal  

.PARAMETER Recurse
    To search PowerShell files in the Path directory and all subdirectories recursively.

.PARAMETER Exclude
    To specify file(s) to exclude from both the code analysis point of view and the test coverage point of view.  
    The value of this parameter qualifies the Path parameter.  
    Enter a path element or pattern, such as *example*. Wildcards are permitted.

.PARAMETER HtmlReportPath
    To instruct Invoke-PSCodeHealth to generate an HTML report, and specify the path where the HTML file should be saved.  
    The path must include the folder path (which has to exist) and the file name.  

.PARAMETER CustomSettingsPath
    To specify the path of a file containing user-defined compliance rules (metrics thresholds, etc...) in JSON format.  
    Any compliance rule specified in this file override the default, and rules not specified in this file will use the default from PSCodeHealthSettings.json.  

.PARAMETER PassThru
    When the parameter HtmlReportPath is used, by default, Invoke-PSCodeHealth doesn't output a [PSCodeHealth.Overall.HealthReport] object to the pipeline.  
    The PassThru parameter allows to instruct Invoke-PSCodeHealth to output both an HTML report file and a [PSCodeHealth.Overall.HealthReport] object.  

.EXAMPLE
    PS C:\> Invoke-PSCodeHealth -Path 'C:\GitRepos\MyModule' -Recurse -TestsPath 'C:\GitRepos\MyModule\Tests\Unit'

    Gets quality and maintainability metrics for code from PowerShell files in the directory C:\GitRepos\MyModule\ and any subdirectories.  
    This command will look for tests located in the directory C:\GitRepos\MyModule\Tests\Unit, and any subdirectories.

.EXAMPLE
    PS C:\> Invoke-PSCodeHealth -Path 'C:\GitRepos\MyModule' -TestsPath 'C:\GitRepos\MyModule\Tests' -Recurse -Exclude "*example*"

    Gets quality and maintainability metrics for code from PowerShell files in the directory C:\GitRepos\MyModule\ and any subdirectories, except for files containing "example" in their name.  
    This command will look for tests located in the directory C:\GitRepos\MyModule\Tests\, and any subdirectories.

.EXAMPLE
    PS C:\> Invoke-PSCodeHealth -Path 'C:\GitRepos\MyModule' -TestsPath 'C:\GitRepos\MyModule\Tests' -HtmlReportPath .\Report.html -PassThru

    Gets quality and maintainability metrics for code from PowerShell files in the directory C:\GitRepos\MyModule\.  
    This command will create an HTML report (Report.html) in the current directory and a PSCodeHealth.Overall.HealthReport object to the pipeline.  
    The styling of HTML elements will reflect their compliance, based on the default compliance rules.

.EXAMPLE
    PS C:\> Invoke-PSCodeHealth -Path 'C:\GitRepos\MyModule' -TestsPath 'C:\GitRepos\MyModule\Tests' -HtmlReportPath .\Report.html -CustomSettingsPath .\MySettings.json

    Gets quality and maintainability metrics for code from PowerShell files in the directory C:\GitRepos\MyModule\.  
    This command will create an HTML report (Report.html) in the current directory and a PSCodeHealth.Overall.HealthReport object to the pipeline.  
    The styling of HTML elements will reflect their compliance, based on the default compliance rules and any custom rules in the file .\MySettings.json.


.OUTPUTS
    PSCodeHealth.Overall.HealthReport

.NOTES
    
#>
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    [OutputType([PSCustomObject])]
    Param (
        [Parameter(Position=0, Mandatory=$False, ValueFromPipeline=$True)]
        [ValidateScript({ Test-Path $_ })]
        [string]$Path,

        [Parameter(Position=1, Mandatory=$False)]
        [ValidateScript({ Test-Path $_ })]
        [string]$TestsPath,

        [Parameter(Position=2, Mandatory=$False)]
        [ValidateScript({ $_.TotalCount -is [int] })]
        [PSCustomObject]$TestsResult,

        [switch]$Recurse,

        [Parameter(Mandatory=$False)]
        [string[]]$Exclude,

        [Parameter(Mandatory, ParameterSetName='HtmlReport')]
        [ValidateScript({ Test-Path -Path (Split-Path $_ -Parent) -PathType Container })]
        [string]$HtmlReportPath,

        [Parameter(Mandatory=$False, ParameterSetName='HtmlReport')]
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf })]
        [string]$CustomSettingsPath,

        [Parameter(Mandatory=$False, ParameterSetName='HtmlReport')]
        [switch]$PassThru

    )
    If ( $PSBoundParameters.ContainsKey('Path') ) {
        $Path = (Resolve-Path -Path $Path).Path
    }
    Else {
        If ( $PWD.Provider.Name -eq 'FileSystem' ) {
            $Path = $PWD.ProviderPath
        }
        Else {
            Throw "The current location is from the $($PWD.Provider.Name) provider, please provide a value for the Path parameter or change to a FileSystem location."
        }
    }
    
    If ( (Get-Item -Path $Path).PSIsContainer ) {
        $ExternalHelpSearchRoot = $Path
        If ( $PSBoundParameters.ContainsKey('Exclude') ) {
            $PowerShellFiles = Get-PowerShellFile -Path $Path -Recurse:$($Recurse.IsPresent) -Exclude $Exclude
        }
        Else {
            $PowerShellFiles = Get-PowerShellFile -Path $Path -Recurse:$($Recurse.IsPresent)
        }
    }
    Else {
        $ExternalHelpSearchRoot = Split-Path -Path $Path -Parent
        $PowerShellFiles = $Path
    }

    If ( -not $PowerShellFiles ) {
        return $Null
    }
    Else {
        Write-VerboseOutput -Message 'Found the following PowerShell files in the directory :'
        Write-VerboseOutput -Message "$($PowerShellFiles | Out-String)"
    }
    $Script:ExternalHelpCommandNames = Get-ExternalHelpCommand -Path $ExternalHelpSearchRoot

    $FunctionDefinitions = Get-FunctionDefinition -Path $PowerShellFiles
    [System.Collections.ArrayList]$FunctionHealthRecords = @()

    If ( -not $FunctionDefinitions ) {
        $FunctionHealthRecords = $Null
    }
    Else {
        Foreach ( $Function in $FunctionDefinitions ) {

            Write-VerboseOutput -Message "Gathering metrics for function : $($Function.Name)"

            $TestCoverageParams = If ( $TestsPath ) {
                @{ FunctionDefinition = $Function; TestsPath = $TestsPath }} Else {
                @{ FunctionDefinition = $Function }
            }
            $TestCoverage = Get-FunctionTestCoverage @TestCoverageParams

            $FunctionHealthRecord = New-FunctionHealthRecord -FunctionDefinition $Function -FunctionTestCoverage $TestCoverage
            $Null = $FunctionHealthRecords.Add($FunctionHealthRecord)
        }
    }

    If ( -not $TestsPath ) {
        $TestsPath = If ( (Get-Item -Path $Path).PSIsContainer ) { $Path } Else { Split-Path -Path $Path -Parent }
    }
    $PathItem = (Get-Item -Path $Path)
    $ReportTitle = $PathItem.Name
    $AnalyzedPath = $PathItem.FullName

    $PSCodeHealthReportParams = @{
        ReportTitle = $ReportTitle
        AnalyzedPath = $AnalyzedPath
        Path = $PowerShellFiles
        FunctionHealthRecord = $FunctionHealthRecords
        TestsPath = $TestsPath
    }
    If ( ($PSBoundParameters.ContainsKey('TestsResult')) ) {
        $HealthReport = New-PSCodeHealthReport @PSCodeHealthReportParams -TestsResult $PSBoundParameters.TestsResult
    }
    Else {
        $HealthReport = New-PSCodeHealthReport @PSCodeHealthReportParams
    }

    If ( $PSCmdlet.ParameterSetName -ne 'HtmlReport' ) {
        return $HealthReport
    }
    Else {
        $JsPlaceholders = @{
            NUMBER_OF_PASSED_TESTS = $HealthReport.NumberOfPassedTests
            NUMBER_OF_FAILED_TESTS = $HealthReport.NumberOfFailedTests
            TESTS_PASS_RATE = $HealthReport.TestsPassRate
            TEST_COVERAGE = $HealthReport.TestCoverage
            CODE_NOT_COVERED = 100 - $HealthReport.TestCoverage
        }
        $JsContent = Set-PSCodeHealthPlaceholdersValue -TemplatePath "$PSScriptRoot\..\Assets\HealthReport.js" -PlaceholdersData $JsPlaceholders

        $TableData = New-PSCodeHealthTableData -HealthReport $HealthReport

        $HtmlPlaceholders = @{
            REPORT_TITLE = $HealthReport.ReportTitle
            CSS_CONTENT = Get-Content -Path "$PSScriptRoot\..\Assets\HealthReport.css"
            ANALYZED_PATH = $HealthReport.AnalyzedPath
            REPORT_DATE = $HealthReport.ReportDate
            NUMBER_OF_FILES = $HealthReport.Files
            NUMBER_OF_FUNCTIONS = $HealthReport.Functions
            LINES_OF_CODE_TOTAL = $HealthReport.LinesOfCodeTotal
            SCRIPTANALYZER_ERRORS = $HealthReport.ScriptAnalyzerErrors
            SCRIPTANALYZER_WARNINGS = $HealthReport.ScriptAnalyzerWarnings
            SCRIPTANALYZER_INFO = $HealthReport.ScriptAnalyzerInformation
            SCRIPTANALYZER_TOTAL = $HealthReport.ScriptAnalyzerFindingsTotal
            SCRIPTANALYZER_AVERAGE = $HealthReport.ScriptAnalyzerFindingsAverage
            FUNCTIONS_WITHOUT_HELP = $HealthReport.FunctionsWithoutHelp
            BEST_PRACTICES_TABLE_ROWS = $TableData.BestPracticesRows
            COMPLEXITY_HIGHEST = $HealthReport.ComplexityHighest
            NESTING_DEPTH_HIGHEST = $HealthReport.NestingDepthHighest
            LINES_OF_CODE_AVERAGE = $HealthReport.LinesOfCodeAverage
            COMPLEXITY_AVERAGE = $HealthReport.ComplexityAverage
            NESTING_DEPTH_AVERAGE = $HealthReport.NestingDepthAverage
            MAINTAINABILITY_TABLE_ROWS = $TableData.MaintainabilityRows
            NUMBER_OF_TESTS = $HealthReport.NumberOfTests
            NUMBER_OF_FAILED_TESTS = $HealthReport.NumberOfFailedTests
            NUMBER_OF_PASSED_TESTS = $HealthReport.NumberOfPassedTests
            COMMANDS_MISSED = $HealthReport.CommandsMissedTotal
            FAILED_TESTS_TABLE_ROWS = $TableData.FailedTestsRows
            COVERAGE_TABLE_ROWS = $TableData.CoverageRows
            JS_CONTENT = $JsContent
        }
        $HtmlContent = Set-PSCodeHealthPlaceholdersValue -TemplatePath "$PSScriptRoot\..\Assets\HealthReport.html" -PlaceholdersData $HtmlPlaceholders

        $ComplianceParams = @{
            HealthReport = $HealthReport                
        }
        If ( $PSBoundParameters.ContainsKey('CustomSettingsPath') ) {
            $ComplianceParams.Add('CustomSettingsPath', $CustomSettingsPath)
        }
        $OverallCompliance = Test-PSCodeHealthCompliance @ComplianceParams
        If ( $Null -eq $FunctionHealthRecords ) {
            $PerFunctionCompliance = $Null
        }
        Else {
            $PerFunctionCompliance = $FunctionHealthRecords.FunctionName.ForEach({ Test-PSCodeHealthCompliance @ComplianceParams -FunctionName $_ })
        }

        $HtmlColorParams = @{
            HealthReport = $HealthReport
            Compliance = $OverallCompliance
            PerFunctionCompliance = $PerFunctionCompliance
            Html = $HtmlContent
        }
        $ColoredHtmlContent = Set-PSCodeHealthHtmlColor @HtmlColorParams

        $Null = New-Item -Path $HtmlReportPath -ItemType File -Force
        Set-Content -Path $HtmlReportPath -Value $ColoredHtmlContent
        If ( $PassThru ) {
            return $HealthReport
        }
    }
}