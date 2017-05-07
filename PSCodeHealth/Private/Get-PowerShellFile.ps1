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

.PARAMETER Exclude
    To specify file(s) to exclude. The value of this parameter qualifies the Path parameter.
    Enter a path element or pattern, such as *example*. Wildcards are permitted.

.EXAMPLE
    PS C:\> Get-PowerShellFile -Path C:\GitRepos\MyModule\ -Recurse

    Gets all PowerShell files in the directory C:\GitRepos\MyModule\ and any subdirectories.

.EXAMPLE
    PS C:\> Get-PowerShellFile -Path C:\GitRepos\MyModule\ -Recurse -Exclude "*example*"

    Gets PowerShell files in the directory C:\GitRepos\MyModule\ and any subdirectories, except for files containing "example" in their name.

.OUTPUTS
    System.String

#>
    [CmdletBinding()]
    [OutputType([String[]])]

    Param (
        [Parameter(Position=0, Mandatory, ValueFromPipeline=$True)]
        [ValidateScript({ Test-Path $_ -PathType Container })]
        [string]$Path,

        [switch]$Recurse,

        [Parameter(Mandatory=$False)]
        [string[]]$Exclude
    )

    $PowerShellFiles = Get-ChildItem @PSBoundParameters -Filter '*.ps*1' -File | Where-Object { $_.FullName -notmatch "Tests|xml$" }
    return $PowerShellFiles.FullName
}