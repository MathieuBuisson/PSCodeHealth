$ModuleName = 'PSCodeHealthMetrics'
Import-Module "$($PSScriptRoot)\..\..\..\$($ModuleName).psd1" -Force

Describe 'Get-FunctionScriptAnalyzerViolation' {
    InModuleScope $ModuleName {

        $Mocks = ConvertFrom-Json (Get-Content -Path "$($PSScriptRoot)\..\TestData\MockObjects.json" -Raw )
        $Files = (Get-ChildItem -Path "$($PSScriptRoot)\..\TestData\" -Filter '*.psm1').FullName
        $FunctionDefinitions = Get-FunctionDefinition -Path $Files
        
        Context 'When the function contains no best practices violation' {

            Mock Invoke-ScriptAnalyzer { }

            It 'Should return 0' {
                Get-FunctionScriptAnalyzerViolation -FunctionDefinition $FunctionDefinitions[0] |
                Should Be 0
            }
        }
        Context 'When the function contains 1 best practices violation' {

            Mock Invoke-ScriptAnalyzer { $Mocks.'Invoke-ScriptAnalyzer'.'1ScriptAnalyzerViolation' | Where-Object { $_ } }

            It 'Should return 1' {
                Get-FunctionScriptAnalyzerViolation -FunctionDefinition $FunctionDefinitions[0] |
                Should Be 1
            }
        }
        Context 'When the function contains 3 best practices violations' {

            Mock Invoke-ScriptAnalyzer { $Mocks.'Invoke-ScriptAnalyzer'.'3ScriptAnalyzerViolations' | Where-Object { $_ } }

            It 'Should return 3' {
                Get-FunctionScriptAnalyzerViolation -FunctionDefinition $FunctionDefinitions[0] |
                Should Be 3
            }
        }
    }
}