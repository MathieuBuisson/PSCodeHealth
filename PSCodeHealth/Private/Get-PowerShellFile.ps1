Function Get-PowerShellFile {
<#
.SYNOPSIS
    Gets all PowerShell files in the specified directory.
.DESCRIPTION
    Gets all PowerShell files (.ps1, .psm1 and .psd1) in the specified directory.
    The following PowerShell-related files are excluded : format data files, type data files and files containing Pester Tests.

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

    $ChildItems = Get-ChildItem @PSBoundParameters -File
    $PowerShellFilter = { $_.Name -like '*.ps*1' }
    $PowerShellFiles = $ChildItems | Where-Object $PowerShellFilter

    Foreach ( $File in $PowerShellFiles ) {
        $FileAst = [System.Management.Automation.Language.Parser]::ParseFile($File.FullName, [ref]$Null, [ref]$Null)
        $Predicate = {
            Param($Ast) $Ast -is [System.Management.Automation.Language.CommandAst] -and
            $Ast.GetCommandName() -eq 'Describe' -and
            $Ast.CommandElements.StaticType -contains [scriptblock]
        }
        $DescribeBlock = $FileAst.Find($Predicate, $False)
        If ( -not($DescribeBlock) ) {
            $File.FullName
        }
    }
}