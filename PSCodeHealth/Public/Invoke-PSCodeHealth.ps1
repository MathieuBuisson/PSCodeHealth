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

.PARAMETER Recurse
    To search PowerShell files in the Path directory and all subdirectories recursively.

.PARAMETER Exclude
    To specify file(s) to exclude from both the code analysis point of view and the test coverage point of view.  
    The value of this parameter qualifies the Path parameter.  
    Enter a path element or pattern, such as *example*. Wildcards are permitted.

.EXAMPLE
    PS C:\> Invoke-PSCodeHealth -Path 'C:\GitRepos\MyModule' -Recurse -TestsPath 'C:\GitRepos\MyModule\Tests\Unit'

    Gets quality and maintainability metrics for code from PowerShell files in the directory C:\GitRepos\MyModule\ and any subdirectories.  
    This command will look for tests located in the directory C:\GitRepos\MyModule\Tests\Unit, and any subdirectories.

.EXAMPLE
    PS C:\> Invoke-PSCodeHealth -Path 'C:\GitRepos\MyModule' -TestsPath 'C:\GitRepos\MyModule\Tests' -Recurse -Exclude "*example*"

    Gets quality and maintainability metrics for code from PowerShell files in the directory C:\GitRepos\MyModule\ and any subdirectories, except for files containing "example" in their name.  
    This command will look for tests located in the directory C:\GitRepos\MyModule\Tests\, and any subdirectories.

.OUTPUTS
    PSCodeHealth.Overall.HealthReport

.NOTES
    
#>
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    Param (
        [Parameter(Position=0, Mandatory=$False, ValueFromPipeline=$True)]
        [validatescript({ Test-Path $_ })]
        [string]$Path,

        [Parameter(Position=1, Mandatory=$False)]
        [validatescript({ Test-Path $_ })]
        [string]$TestsPath,

        [switch]$Recurse,

        [Parameter(Mandatory=$False)]
        [string[]]$Exclude
    )
    If ( -not($PSBoundParameters.ContainsKey('Path')) ) {

        If ( $PWD.Provider.Name -eq 'FileSystem' ) {
            $Path = $PWD.ProviderPath
        }
        Else {
            Throw "The current location is from the $($PWD.Provider.Name) provider, please provide a value for the Path parameter or change to a FileSystem location."
        }
    }
    
    If ( (Get-Item -Path $Path).PSIsContainer ) {
        If ( $PSBoundParameters.ContainsKey('Exclude') ) {
            $PowerShellFiles = Get-PowerShellFile -Path $Path -Recurse:$($Recurse.IsPresent) -Exclude $Exclude
        }
        Else {
            $PowerShellFiles = Get-PowerShellFile -Path $Path -Recurse:$($Recurse.IsPresent)
        }
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
            $FunctionHealthRecords += $FunctionHealthRecord
        }
    }

    If ( -not $TestsPath ) {
        $TestsPath = If ( (Get-Item -Path $Path).PSIsContainer ) { $Path } Else { Split-Path -Path $Path -Parent }
    }

    New-PSCodeHealthReport -Path $PowerShellFiles -FunctionHealthRecord $FunctionHealthRecords -TestsPath $TestsPath
}