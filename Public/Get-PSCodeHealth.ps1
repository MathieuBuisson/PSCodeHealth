Function Get-PSCodeHealth {
<#
.SYNOPSIS
    Gets health and maintainability metrics for PowerShell code contained in scripts, modules or directories.
.DESCRIPTION
    Gets health and maintainability metrics for PowerShell code contained in scripts, modules or directories.

.PARAMETER Path
    To specify the path of the directory to search.

.PARAMETER Recurse
    To search the Path directory and all subdirectories recursively.

.EXAMPLE
    Get-PowerShellFile -Path C:\GitRepos\MyModule\ -Recurse

    Gets health and maintainability metrics for code from PowerShell files in the directory C:\GitRepos\MyModule\ and any subdirectories.

.OUTPUTS
    Output from this cmdlet (if any)

.NOTES
    General notes
#>
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    Param (
        [Parameter(Position=0, Mandatory=$True, ValueFromPipeline=$True)]
        [validatescript({ Test-Path $_ })]
        [string]$Path,

        [switch]$Recurse
    )
    
    If ( (Get-Item -Path $Path).PSIsContainer ) {
        $PowerShellFiles = Get-PowerShellFile @PSBoundParameters
        Write-VerboseOutput -Message 'Found the following PowerShell files in the directory :'
        Write-VerboseOutput -Message "$($PowerShellFiles | Out-String)"
    }
    Else {
        $PowerShellFiles = $Path
    }

    $FunctionDefinitions = Get-FunctionDefinition -Path $PowerShellFiles

    Foreach ( $Function in $FunctionDefinitions ) {

        Write-VerboseOutput -Message "Gathering metrics for function : $($Function.Name)"

        $CodeLength = Get-FunctionCodeLength -FunctionDefinition $Function
        $ScriptAnalyzerViolations = Get-FunctionScriptAnalyzerViolation -FunctionDefinition $Function

        $Properties = [ordered]@{
            'Name' = $Function.Name
            'CodeLength' = $CodeLength
            'ScriptAnalyzerViolations' = $ScriptAnalyzerViolations
        }

        $CustomObject = New-Object -TypeName PSObject -Property $Properties
        $CustomObject
    }
}