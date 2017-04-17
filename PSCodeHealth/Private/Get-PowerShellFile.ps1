Function Get-PowerShellFile {
<#
.SYNOPSIS
    Gets all PowerShell files in the specified directory.
.DESCRIPTION
    Gets all PowerShell files (.ps1, .psm1 and .psd1) in the specified directory.
    The following PowerShell-related files are excluded : Tests, format data files and type data files.

.PARAMETER Path
    To specify the path of the directory to search.

.PARAMETER Recurse
    To search the Path directory and all subdirectories recursively.

.EXAMPLE
    Get-PowerShellFile -Path C:\GitRepos\MyModule\ -Recurse

    Gets all PowerShell files in the directory C:\GitRepos\MyModule\ and any subdirectories.
#>
    [CmdletBinding()]
    [OutputType([String[]])]

    Param (
        [Parameter(Position=0, Mandatory=$True, ValueFromPipeline=$True)]
        [validatescript({ Test-Path $_ -PathType Container })]
        [string]$Path,

        [switch]$Recurse
    )

    $PowerShellFiles = Get-ChildItem @PSBoundParameters -Filter '*.ps*1' -File | Where-Object { $_.FullName -notmatch "Tests|xml$" }
    return $PowerShellFiles.FullName
}