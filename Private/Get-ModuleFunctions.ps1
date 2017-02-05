Function Get-ModuleFunctions {
<#
.SYNOPSIS
    Gets all the functions in the specified module.
.DESCRIPTION
    Gets all the functions (including private functions) in the module specified by name or filepath
.EXAMPLE
    Example of how to use this cmdlet
.OUTPUTS
    Output from this cmdlet (if any)
.NOTES
    General notes
#>
    [CmdletBinding(DefaultParameterSetName="Name")]
    [OutputType([String])]
    Param (
        [Parameter(Position=0,ParameterSetName='Name')]
        [string]$Name,
        
        [Parameter(Position=0,ParameterSetName='Path')]
        [validatescript({ Test-Path $_ })]
        [string]$Path
    )
    
    If ( $PSCmdlet.ParameterSetName -eq 'Name' ) {
        $ModulePowerShellScripts = Get-ModulePowerShellScripts -Name $Name
    } 
    ElseIf ($PSCmdlet.ParameterSetName -eq 'Path') {
        $ModulePowerShellScripts = Get-ModulePowerShellScripts -Path $Path
    }

    Foreach ( )
}