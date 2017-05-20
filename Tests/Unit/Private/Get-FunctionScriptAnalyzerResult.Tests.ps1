$ModuleName = 'PSCodeHealth'
Import-Module "$PSScriptRoot\..\..\..\$ModuleName\$($ModuleName).psd1" -Force

Describe 'Get-FunctionScriptAnalyzerResult' {
    InModuleScope $ModuleName {

        $Mocks = ConvertFrom-Json (Get-Content -Path "$($PSScriptRoot)\..\..\TestData\MockObjects.json" -Raw )
        $Files = (Get-ChildItem -Path "$($PSScriptRoot)\..\..\TestData\" -Filter '*.psm1').FullName
        $FunctionDefinitions = Get-FunctionDefinition -Path $Files

        Context 'No Invoke-ScriptAnalyzer Mock' {

            $Function = $FunctionDefinitions | Where-Object Name -eq 'Set-Nothing'
            $Result = Get-FunctionScriptAnalyzerResult -FunctionDefinition $Function

            It 'Should return PSScriptAnalyzer [DiagnosticRecord] objects' {
                $Result |
                Should BeOfType [Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord]
            }
            It 'Should return the expected ScriptAnalyzer finding' {
                $Result.Extent.Text | Should Be 'Set-Nothing'
                $Result.RuleName | Should Be 'PSUseShouldProcessForStateChangingFunctions'
            }
        }
        
        Context 'When the function contains no best practices violation' {

            Mock Invoke-ScriptAnalyzer { }

            It 'Should return $Null' {
                Get-FunctionScriptAnalyzerResult -FunctionDefinition $FunctionDefinitions[0] |
                Should BeNullOrEmpty
            }
        }
        Context 'When the function contains 1 best practices violation' {

            Mock Invoke-ScriptAnalyzer { $Mocks.'Invoke-ScriptAnalyzer'.'1Result_PSProvideCommentHelp' | Where-Object { $_ } }
            $Result = Get-FunctionScriptAnalyzerResult -FunctionDefinition $FunctionDefinitions[0]

            It 'Should return the expected PSScriptAnalyzer finding' {
                $Result.RuleName | Should Be 'PSProvideCommentHelp'
                $Result.Extent.Text | Should Be 'BadFunction'
            }
        }
        Context 'When the function contains 2 best practices violations' {

            Mock Invoke-ScriptAnalyzer { $Mocks.'Invoke-ScriptAnalyzer'.'2Results_2Rules' | Where-Object { $_ } }
            $Results = Get-FunctionScriptAnalyzerResult -FunctionDefinition $FunctionDefinitions[0]

            It 'Should return 2 PSScriptAnalyzer findings' {
                $Results.Count | Should Be 2
            }
            It 'Should return the expected PSScriptAnalyzer rule names' {
                $Results.RuleName -contains 'PSProvideCommentHelp' | Should Be $True
                $Results.RuleName -contains 'PSAvoidGlobalVars' | Should Be $True
            }
            It 'Should return the expected PSScriptAnalyzer extents' {
                ($Results.Extent | Where-Object Text -eq 'VeryBadFunction').Count |
                Should Be 2
            }
        }
    }
}