$ModuleName = 'PSCodeHealth'
Import-Module "$PSScriptRoot\..\..\..\$ModuleName\$($ModuleName).psd1" -Force

Describe 'Measure-FunctionLogicalOpCodePath' {
    InModuleScope $ModuleName {

        $Mocks = ConvertFrom-Json (Get-Content -Path "$($PSScriptRoot)\..\..\TestData\MockObjects.json" -Raw )

        Context 'There is no logical operator in the specified function' {

            $FunctionText = ($Mocks.'Get-FunctionDefinition'.NoLogicalOp.Extent.Text | Out-String)
            $ScriptBlock = [System.Management.Automation.Language.Parser]::ParseInput($FunctionText, [ref]$null, [ref]$null)
            $FunctionDefinition = $ScriptBlock.FindAll({ $args[0] -is [System.Management.Automation.Language.FunctionDefinitionAst] }, $False)
            $Result = Measure-FunctionLogicalOpCodePath -FunctionDefinition $FunctionDefinition[0]

            It 'Should return an object of the type [System.Int32]' {
                $Result | Should BeOfType [System.Int32]
            }
            It 'Should return the value 0' {
                $Result | Should Be 0
            }
        }

        Context 'There are And, Or and Xor logical operators in the specified function' {

            $FunctionText = ($Mocks.'Get-FunctionDefinition'.LogicalOps.Extent.Text | Out-String)
            $ScriptBlock = [System.Management.Automation.Language.Parser]::ParseInput($FunctionText, [ref]$null, [ref]$null)
            $FunctionDefinition = $ScriptBlock.FindAll({ $args[0] -is [System.Management.Automation.Language.FunctionDefinitionAst] }, $False)
            $Result = Measure-FunctionLogicalOpCodePath -FunctionDefinition $FunctionDefinition[0]

            It 'Should return an object of the type [System.Int32]' {
                $Result | Should BeOfType [System.Int32]
            }
            It 'Should count every logical operator' {
                $Result | Should Be 3
            }
        }
    }
}