Function Get-PowerShellFile {
<#
.SYNOPSIS
    Gets all PowerShell scripts and modules nested in the specified module.
.DESCRIPTION
    Gets all PowerShell scripts and modules nested in the module specified by name or filepath.

.PARAMETER Name
    To specify the module to check by its name.

.PARAMETER Path
    To specify the module to check by the path of its manifest (.psd1) or root module file (.psm1).

.EXAMPLE
    Get-PowerShellFile -Path C:\GitRepos\MyModule\MyModule.psd1

    Gets all PowerShell scripts and modules nested in the module specified by the path of its manifest.
#>
    [CmdletBinding(DefaultParameterSetName="Name")]
    [OutputType([String[]])]
    Param (
        [Parameter(Position=0,ParameterSetName='Name')]
        [string]$Name,
        
        [Parameter(Position=0,ParameterSetName='Path')]
        [validatescript({ Test-Path $_ })]
        [string]$Path
    )
    Try {
        If ( $PSCmdlet.ParameterSetName -eq 'Name' ) {
            $ModuleInfo = Import-Module -Name $Name -Force -PassThru
        } 
        ElseIf ($PSCmdlet.ParameterSetName -eq 'Path') {
            $ModuleInfo = Import-Module $Path -Force -PassThru
        }
    }
    Catch {
        Throw $_
    }

    $ModuleFolder = $ModuleInfo.ModuleBase
    Write-Verbose "The module folder path is : $($ModuleFolder)"

    $ScriptFiles = Get-ChildItem -Path $ModuleFolder -Recurse -Filter '*.ps*1' -File | Where-Object { $_.FullName -notmatch "Tests|\w\.psd1|xml$" }
    return $ScriptFiles.FullName
}