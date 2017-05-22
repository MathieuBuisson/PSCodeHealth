$ModuleName = 'PSCodeHealth'
Import-Module "$PSScriptRoot\..\..\..\$ModuleName\$($ModuleName).psd1" -Force

Describe 'Test-FunctionHelpCoverage' {
    InModuleScope $ModuleName {

        $Files = (Get-ChildItem -Path "$($PSScriptRoot)\..\..\TestData\" -Filter '*.psm1').FullName
        $FunctionDefinitions = Get-FunctionDefinition -Path $Files
        $FunctionsWithHelp = @('Set-Nothing', 'Get-Nothing', 'Public')
        $FunctionWithNoHelp = 'Private'

        It 'Should return a [System.Boolean]' {
            Foreach ( $FunctionDefinition in $FunctionDefinitions ) {
                Test-FunctionHelpCoverage -FunctionDefinition $FunctionDefinition |
                Should BeOfType [System.Boolean]
            }
        }
        It 'Should return True if the specified function contains some help info' {
            Foreach ( $FunctionDefinition in ($FunctionDefinitions.Where({$_.Name -in $FunctionsWithHelp})) ) {
                Test-FunctionHelpCoverage -FunctionDefinition $FunctionDefinition |
                Should Be $True
            }
        }
        It 'Should return False if the specified function does not contain any help info' {
            $FunctionDefinitionWithNoHelp = $FunctionDefinitions | Where-Object { $_.Name -eq $FunctionWithNoHelp }
            Test-FunctionHelpCoverage -FunctionDefinition $FunctionDefinitionWithNoHelp |
            Should Be $False
        }
    }
}