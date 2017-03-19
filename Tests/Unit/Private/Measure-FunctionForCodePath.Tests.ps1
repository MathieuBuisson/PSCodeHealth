$ModuleName = 'PSCodeHealth'
Import-Module "$PSScriptRoot\..\..\..\$ModuleName\$($ModuleName).psd1" -Force

Describe 'Measure-FunctionForCodePath' {
    InModuleScope $ModuleName {

        $Mocks = ConvertFrom-Json (Get-Content -Path "$($PSScriptRoot)\..\TestData\MockObjects.json" -Raw )

        Context 'There is no For statement in the specified function' {

            $FunctionText = ($Mocks.'Get-FunctionDefinition'.NoForStatements.Extent.Text | Out-String)
            $ScriptBlock = [System.Management.Automation.Language.Parser]::ParseInput($FunctionText, [ref]$null, [ref]$null)
            $FunctionDefinition = $ScriptBlock.FindAll({ $args[0] -is [System.Management.Automation.Language.FunctionDefinitionAst] }, $False)
            $Result = Measure-FunctionForCodePath -FunctionDefinition $FunctionDefinition[0]

            It 'Should return an object of the type [System.Int32]' {
                $Result | Should BeOfType [System.Int32]
            }
            It 'Should return the value 0' {
                $Result | Should Be 0
            }
        }

        Context 'There are 3 For statements, including 1 nested and 1 with no condition' {

            $FunctionText = ($Mocks.'Get-FunctionDefinition'.ForStatements.Extent.Text | Out-String)
            $ScriptBlock = [System.Management.Automation.Language.Parser]::ParseInput($FunctionText, [ref]$null, [ref]$null)
            $FunctionDefinition = $ScriptBlock.FindAll({ $args[0] -is [System.Management.Automation.Language.FunctionDefinitionAst] }, $False)
            $Result = Measure-FunctionForCodePath -FunctionDefinition $FunctionDefinition[0]

            It 'Should return an object of the type [System.Int32]' {
                $Result | Should BeOfType [System.Int32]
            }
            It 'Should count every For statements, except for the one which has no condition' {
                $Result | Should Be 2
            }
        }
    }
}