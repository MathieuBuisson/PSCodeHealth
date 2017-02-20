$ModuleName = 'PSCodeHealth'
Import-Module "$PSScriptRoot\..\..\..\$ModuleName\$($ModuleName).psd1" -Force

Describe 'General Module behaviour' {
       
    $ModuleInfo = Get-Module -Name $ModuleName
    $ManifestPath = '{0}\{1}.psd1' -f $ModuleInfo.ModuleBase, $ModuleName

    It 'The required modules should be Pester and PSScriptAnalyzer' {
        
        Foreach ( $RequiredModule in $ModuleInfo.RequiredModules.Name ) {
            $RequiredModule -in @('Pester','PSScriptAnalyzer') | Should Be $True
        }
    }
    It 'Has a valid manifest' {
        { Test-ModuleManifest -Path $ManifestPath -ErrorAction Stop } |
        Should Not Throw
    }
    It 'Has a valid root module' {
        $ModuleInfo.RootModule -like '*{0}.psm1' -f $ModuleName |
        Should Be $True
    }
    It 'Exports all public functions' {
        $ExpectedFunctions = (Get-ChildItem -Path "$PSScriptRoot\..\..\..\PSCodeHealth\Public" -File).BaseName
        $ExportedFunctions = $ModuleInfo.ExportedFunctions.Values.Name
        
        Foreach ( $FunctionName in $ExpectedFunctions ) {
			$ExportedFunctions -contains $FunctionName | Should Be $True
		}
    }
}