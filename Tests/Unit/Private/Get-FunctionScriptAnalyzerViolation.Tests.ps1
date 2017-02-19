$ModuleName = 'PSCodeHealth'
Import-Module "$($PSScriptRoot)\..\..\..\$($ModuleName).psd1" -Force

Describe 'Get-FunctionScriptAnalyzerViolation' {
    InModuleScope $ModuleName {

        $Mocks = ConvertFrom-Json (Get-Content -Path "$($PSScriptRoot)\..\TestData\MockObjects.json" -Raw )
        $Files = (Get-ChildItem -Path "$($PSScriptRoot)\..\TestData\" -Filter '*.psm1').FullName
        $FunctionDefinitions = Get-FunctionDefinition -Path $Files
        
        Context 'When the function contains no best practices violation' {

            Mock Get-FunctionScriptAnalyzerResult { }

            It 'Should return 0' {
                Get-FunctionScriptAnalyzerViolation -FunctionDefinition $FunctionDefinitions[0] |
                Should Be 0
            }
        }
        Context 'When the function contains 1 best practices violation' {

            Mock Get-FunctionScriptAnalyzerResult { $Mocks.'Get-FunctionScriptAnalyzerResult'.'1Result' | Where-Object { $_ } }

            It 'Should return 1' {
                Get-FunctionScriptAnalyzerViolation -FunctionDefinition $FunctionDefinitions[0] |
                Should Be 1
            }
        }
        Context 'When the function contains 3 best practices violations' {

            Mock Get-FunctionScriptAnalyzerResult { $Mocks.'Get-FunctionScriptAnalyzerResult'.'3Results' | Where-Object { $_ } }

            It 'Should return 3' {
                Get-FunctionScriptAnalyzerViolation -FunctionDefinition $FunctionDefinitions[0] |
                Should Be 3
            }
        }
    }
}