Function Get-ExternalHelpCommand {
    <#
    .SYNOPSIS
        Gets the name of the commands listed in external help files.
    .DESCRIPTION
        Gets the name of the commands listed in external (MAML-formatted) help files.
    
    .PARAMETER Path
        Root directory where the function looks for external help files.  
        The function looks for files with a name ending with "-help.xml" in a "en-US" subdirectory.
    
    .EXAMPLE
        PS C:\> Get-ExternalHelpCommand -Path 'C:\GitRepos\MyModule'
    
        Gets the name of all the commands listed in external help files found in the folder : C:\GitRepos\MyModule\.
        
    .NOTES
        https://info.sapien.com/index.php/scripting/scripting-help/writing-xml-help-for-advanced-functions
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Position=0, Mandatory)]
        [ValidateScript({ Test-Path $_ -PathType Container })]
        [string[]]$Path
    )

    $LocaleFolder = Get-ChildItem -Path $Path -Directory -Filter 'en-US' -Recurse
    If ( $LocaleFolder ) {
        $MamlHelpFile = Get-ChildItem -Path $LocaleFolder.FullName -File -Filter '*-help.xml'
        If ( $MamlHelpFile ) {
            Try {
                [xml]$Maml = Get-Content -Path $MamlHelpFile.FullName
            }
            Catch {
                Write-Warning "The content of the file $($MamlHelpFile.FullName) was not valid XML"
                return
            }
            return $Maml.helpItems.command.details.name
        }
    }
}