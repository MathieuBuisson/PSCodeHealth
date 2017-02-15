$ModuleName = 'PSCodeHealthMetrics'
Import-Module "$($PSScriptRoot)\..\..\..\$($ModuleName).psd1" -Force

$Mocks = ConvertFrom-Json (Get-Content -Path "$($PSScriptRoot)\..\TestData\MockObjects.json" -Raw )

Describe 'General Module behaviour' {
       
    $ModuleInfo = Get-Module -Name $ModuleName

    It 'The required modules should be Pester and PSScriptAnalyzer' {
        
        Foreach ( $RequiredModule in $ModuleInfo.RequiredModules.Name ) {
            $RequiredModule -in @('Pester','PSScriptAnalyzer') | Should Be $True
        }
    }
}