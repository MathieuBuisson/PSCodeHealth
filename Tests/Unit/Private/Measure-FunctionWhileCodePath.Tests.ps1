$ModuleName = 'PSCodeHealth'
Import-Module "$PSScriptRoot\..\..\..\$ModuleName\$($ModuleName).psd1" -Force

Describe 'Measure-FunctionWhileCodePath' {
    InModuleScope $ModuleName {

        $Mocks = ConvertFrom-Json (Get-Content -Path "$($PSScriptRoot)\..\TestData\MockObjects.json" -Raw )

        Context 'There is no While statement in the specified function' {

            $FunctionText = ($Mocks.'Get-FunctionDefinition'.NoWhileStatement.Extent.Text | Out-String)
            $ScriptBlock = [System.Management.Automation.Language.Parser]::ParseInput($FunctionText, [ref]$null, [ref]$null)
            $FunctionDefinition = $ScriptBlock.FindAll({ $args[0] -is [System.Management.Automation.Language.FunctionDefinitionAst] }, $False)
            $Result = Measure-FunctionWhileCodePath -FunctionDefinition $FunctionDefinition[0]

            It 'Should return an object of the type [System.Int32]' {
                $Result | Should BeOfType [System.Int32]
            }
            It 'Should return the value 0' {
                $Result | Should Be 0
            }
        }

        Context 'There are 2 While statements, including 1 nested' {

            $FunctionText = ($Mocks.'Get-FunctionDefinition'.WhileStatements.Extent.Text | Out-String)
            $ScriptBlock = [System.Management.Automation.Language.Parser]::ParseInput($FunctionText, [ref]$null, [ref]$null)
            $FunctionDefinition = $ScriptBlock.FindAll({ $args[0] -is [System.Management.Automation.Language.FunctionDefinitionAst] }, $False)
            $Result = Measure-FunctionWhileCodePath -FunctionDefinition $FunctionDefinition[0]

            It 'Should return an object of the type [System.Int32]' {
                $Result | Should BeOfType [System.Int32]
            }
            It 'Should count every While statements, including the nested one' {
                $Result | Should Be 2
            }
        }
    }
}