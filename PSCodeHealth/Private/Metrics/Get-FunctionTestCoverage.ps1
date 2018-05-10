Function Get-FunctionTestCoverage {
<#
.SYNOPSIS
    Gets test coverage information for the specified function.

.DESCRIPTION
    Gets test coverage information for the specified function. This includes 2 pieces of information :  
      - Code coverage percentage (lines of code that are exercized by unit tests)  
      - Missed Commands (lines of codes or commands not being exercized by unit tests)  

    It uses Pester with its CodeCoverage parameter.

.PARAMETER FunctionDefinition
    To specify the function definition to analyze.

.PARAMETER TestsPath
    To specify the file or directory where the Pester tests are located.
    If a directory is specified, the directory and all subdirectories will be searched recursively for tests.
    If not specified, the directory of the file containing the specified function, and all subdirectories will be searched for tests.

.EXAMPLE
    PS C:\> Get-FunctionTestCoverage -FunctionDefinition $MyFunctionAst -TestsPath $MyModule.ModuleBase

    Gets test coverage information for the function $MyFunctionAst given the tests found in the module's parent directory.

.OUTPUTS
    PSCodeHealth.Function.TestCoverageInfo

.NOTES
    
#>
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    Param (
        [Parameter(Position=0, Mandatory)]
        [System.Management.Automation.Language.FunctionDefinitionAst]$FunctionDefinition,

        [Parameter(Position=1, Mandatory=$False)]
        [ValidateScript({ Test-Path $_ })]
        [string]$TestsPath
    )

    [string]$SourcePath = $FunctionDefinition.Extent.File
    $FunctionName = $FunctionDefinition.Name
    Write-VerboseOutput -Message "The function [$FunctionName] comes from the file :  $SourcePath"

    If ( -not $TestsPath ) {
        $TestsPath = Split-Path -Path $SourcePath -Parent
    }

    # Find all the files under the test path that contain the function name
    $Tests = Get-ChildItem -Path $TestsPath -Recurse -Filter *.tests.ps1 |
    Select-String -Pattern $FunctionName |
    Where-Object { $_.Line -notmatch 'Describe|Context|It |Mock ' } |
    Select-Object -ExpandProperty Path -Unique

    # Invoke-Pester didn't have the "Show" parameter prior to version 4.x
    $SuppressOutput = If ((Get-Module -Name Pester).Version.Major -lt 4) { @{Quiet = $True} } Else { @{Show = 'None'} }

    $TestsResult = Invoke-Pester -Script $Tests -CodeCoverage @{ Path = $SourcePath; Function = $FunctionName } -PassThru -Verbose:$False @SuppressOutput

    If ( $TestsResult.CodeCoverage ) {
        $CodeCoverage = $TestsResult.CodeCoverage
        $CommandsFound = $CodeCoverage.NumberOfCommandsAnalyzed
        Write-VerboseOutput -Message "Number of commands found in the function : $($CommandsFound)"

        # To prevent any "Attempted to divide by zero" exceptions
        If ( $CommandsFound -ne 0 ) {
            $Commandsexercised = $CodeCoverage.NumberOfCommandsExecuted
            Write-VerboseOutput -Message "Number of commands exercized in the tests : $($CommandsExercised)"
            [System.Double]$CodeCoveragePerCent = [math]::Round(($CommandsExercised / $CommandsFound) * 100, 2)
        }
        Else {
            [System.Double]$CodeCoveragePerCent = 0
        }

        $ObjectProperties = [ordered]@{
            'CodeCoveragePerCent'         = $CodeCoveragePerCent
            'CommandsMissed'              = $CodeCoverage.MissedCommands
        }
        $CustomObject = New-Object -TypeName PSObject -Property $ObjectProperties
        $CustomObject.psobject.TypeNames.Insert(0, 'PSCodeHealth.Function.TestCoverageInfo')
        return $CustomObject
    }
}