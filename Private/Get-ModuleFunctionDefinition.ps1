Function Get-ModuleFunctionDefinition {
<#
.SYNOPSIS
    Gets all the function definitions in the specified module.
.DESCRIPTION
    Gets all the function definitions (including private functions) in the module specified by name or filepath as FunctionDefinitionAst objects.

.PARAMETER Name
    To specify the module to analyze by its name.

.PARAMETER Path
    To specify the module to analyze by the path of its manifest (.psd1) or root module file (.psm1).

.EXAMPLE
    Get-ModuleFunctionDefinition -Path C:\GitRepos\MyModule\MyModule.psd1

    Gets all function definitions in the module specified by its manifest, as FunctionDefinitionAst objects.

.OUTPUTS
    System.Management.Automation.Language.FunctionDefinitionAst
.NOTES
    General notes
#>
    [CmdletBinding(DefaultParameterSetName="Name")]
    [OutputType([System.Management.Automation.Language.FunctionDefinitionAst[]])]
    Param (
        [Parameter(Position=0,ParameterSetName='Name')]
        [string]$Name,
        
        [Parameter(Position=0,ParameterSetName='Path')]
        [validatescript({ Test-Path $_ })]
        [string]$Path
    )
    
    If ( $PSCmdlet.ParameterSetName -eq 'Name' ) {
        $ModulePowerShellScripts = Get-PowerShellScript -Name $Name
    } 
    ElseIf ($PSCmdlet.ParameterSetName -eq 'Path') {
        $ModulePowerShellScripts = Get-PowerShellScript -Path $Path
    }

    Foreach ( $ScriptFile in $ModulePowerShellScripts ) {

        $ScriptFileAst = [System.Management.Automation.Language.Parser]::ParseFile($ScriptFile, [ref]$Null, [ref]$Null)
        $ScripFileFunctions = $ScriptFileAst.FindAll({ $args[0] -is [System.Management.Automation.Language.FunctionDefinitionAst] }, $False)
        $ScripFileFunctions
    }
}