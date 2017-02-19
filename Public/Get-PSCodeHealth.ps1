Function Get-PSCodeHealth {
<#
.SYNOPSIS
    Gets health and maintainability metrics for PowerShell code contained in scripts, modules or directories.
.DESCRIPTION
    Gets health and maintainability metrics for PowerShell code contained in scripts, modules or directories.

.PARAMETER Path
    To specify the path of the directory to search.

.PARAMETER TestsPath
    To specify the file or directory where tests are located.
    If not specified, the command will look for tests in the same directory as each function.

.PARAMETER Recurse
    To search PowerShell files in the Path directory and all subdirectories recursively.

.EXAMPLE
    Get-PowerShellFile -Path 'C:\GitRepos\MyModule' -Recurse -TestsPath 'C:\GitRepos\MyModule\Tests\Unit'

    Gets health and maintainability metrics for code from PowerShell files in the directory C:\GitRepos\MyModule\ and any subdirectories.
    This command will look for tests located in the directory C:\GitRepos\MyModule\Tests\Unit, and any subdirectories.

.OUTPUTS
    PSCodeHealth.Function.HealthRecord

.NOTES
    General notes
#>
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    Param (
        [Parameter(Position=0, Mandatory=$True, ValueFromPipeline=$True)]
        [validatescript({ Test-Path $_ })]
        [string]$Path,

        [Parameter(Position=1, Mandatory=$False)]
        [validatescript({ Test-Path $_ })]
        [string]$TestsPath,

        [switch]$Recurse
    )
    
    If ( (Get-Item -Path $Path).PSIsContainer ) {

        If ( $PSBoundParameters.ContainsKey('TestsPath') ) {
            $Null = $PSBoundParameters.Remove('TestsPath')
        }
        $PowerShellFiles = Get-PowerShellFile @PSBoundParameters
    }
    Else {
        $PowerShellFiles = $Path
    }

    If ( -not $PowerShellFiles ) {
        return $Null
    }
    Else {
        Write-VerboseOutput -Message 'Found the following PowerShell files in the directory :'
        Write-VerboseOutput -Message "$($PowerShellFiles | Out-String)"
    }

    $FunctionDefinitions = Get-FunctionDefinition -Path $PowerShellFiles
    If ( -not $FunctionDefinitions ) {
        return $Null
    }

    Foreach ( $Function in $FunctionDefinitions ) {

        Write-VerboseOutput -Message "Gathering metrics for function : $($Function.Name)"

        $CodeLength = Get-FunctionCodeLength -FunctionDefinition $Function
        $ScriptAnalyzerViolations = Get-FunctionScriptAnalyzerViolation -FunctionDefinition $Function
        $ScriptAnalyzerResults = Get-FunctionScriptAnalyzerResult -FunctionDefinition $Function
        $ContainsHelp = Test-FunctionHelpCoverage -FunctionDefinition $Function

        $TestCoverageParams = If ( $TestsPath ) {
            @{ FunctionDefinition = $Function; TestsPath = $TestsPath }} Else {
            @{ FunctionDefinition = $Function }
        }
        $TestCoverage = Get-FunctionTestCoverage @TestCoverageParams

        $FunctionHealthRecordParams = @{
            FunctionDefinition = $Function
            CodeLength = $CodeLength
            ScriptAnalyzerViolations = $ScriptAnalyzerViolations
            ScriptAnalyzerResultDetails = $ScriptAnalyzerResults
            ContainsHelp = $ContainsHelp
            TestCoverage = $TestCoverage
        }
        $FunctionHealthRecord = New-FunctionHealthRecord @FunctionHealthRecordParams
        $FunctionHealthRecord
    }
}