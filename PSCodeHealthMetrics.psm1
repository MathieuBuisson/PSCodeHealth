#Get public and private function definition files.
    $Public  = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue )
    $Private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue )

    Foreach ( $Import in @($Public + $Private) ) {
        Try {
            . $Import.FullName
        }
        Catch {
            Write-Error -Message "Failed to import function $($Import.FullName): $_"
        }
    }

# Here I might...
    # Export Public functions ($Public.BaseName) for WIP modules
    # Set variables visible to the module and its functions only

Export-ModuleMember -Function $Public.Basename