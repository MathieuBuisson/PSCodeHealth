Function Get-FunctionDefinition {
<#
.SYNOPSIS
    Gets all the function definitions in the specified files.
.DESCRIPTION
    Gets all the function definitions (including private functions but excluding nested functions) in the specified PowerShell file.

.PARAMETER Path
    To specify the path of the file to analyze.

.EXAMPLE
    Get-FunctionDefinition -Path C:\GitRepos\MyModule\MyModule.psd1

    Gets all function definitions in the module specified by its manifest, as FunctionDefinitionAst objects.

.OUTPUTS
    System.Management.Automation.Language.FunctionDefinitionAst
.NOTES
    General notes
#>
    [CmdletBinding()]
    [OutputType([System.Management.Automation.Language.FunctionDefinitionAst[]])]
    Param (
        [Parameter(Position=0, Mandatory=$True, ValueFromPipeline=$True)]
        [validatescript({ Test-Path $_ -PathType Leaf })]
        [string[]]$Path
    )
    Process {
        Foreach ( $PowerShellFile in $Path ) {
            Write-VerboseOutput -Message "Parsing file : $PowerShellFile"

            $FileAst = [System.Management.Automation.Language.Parser]::ParseFile($PowerShellFile, [ref]$Null, [ref]$Null)
            $FileFunctions = $FileAst.FindAll({ $args[0] -is [System.Management.Automation.Language.FunctionDefinitionAst] }, $False)
            If ( $FileFunctions ) {
                Foreach ( $FunctionName in $FileFunctions.Name ) {
                    Write-VerboseOutput -Message "Found function : $FunctionName"
                }
            }
            $FileFunctions
        }
    }
}