#Get public and private function definition files.
$Public  = @( Get-ChildItem -Path "$PSScriptRoot\Public\*.ps1" -File -ErrorAction SilentlyContinue )
$Private = @( Get-ChildItem -Path "$PSScriptRoot\Private" -File -Filter '*.ps1' -Recurse -ErrorAction SilentlyContinue )

Foreach ( $Import in @($Public + $Private) ) {
    Try {
        . $Import.FullName
    }
    Catch {
        Write-Error -Message "Failed to import function $($Import.FullName): $_"
    }
}
$Script:ExternalHelpCommandNames = @()

Export-ModuleMember -Function $Public.Basename
Set-Alias -Name ipch -Value Invoke-PSCodeHealth -Force
Export-ModuleMember -Alias 'ipch'