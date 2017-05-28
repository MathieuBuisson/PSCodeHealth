$ModuleName = 'PSCodeHealth'
Import-Module "$PSScriptRoot\..\..\..\$ModuleName\$($ModuleName).psd1" -Force

Describe 'Measure-FunctionSwitchCodePath' {
    InModuleScope $ModuleName {

        $Mocks = ConvertFrom-Json (Get-Content -Path "$($PSScriptRoot)\..\..\TestData\MockObjects.json" -Raw )

        Context 'There is no Switch statement in the specified function' {

            $FunctionText = ($Mocks.'Get-FunctionDefinition'.NoSwitchStatements.Extent.Text | Out-String)
            $ScriptBlock = [System.Management.Automation.Language.Parser]::ParseInput($FunctionText, [ref]$null, [ref]$null)
            $FunctionDefinition = $ScriptBlock.FindAll({ $args[0] -is [System.Management.Automation.Language.FunctionDefinitionAst] }, $False)
            $Result = Measure-FunctionSwitchCodePath -FunctionDefinition $FunctionDefinition[0]

            It 'Should return an object of the type [System.Int32]' {
                $Result | Should BeOfType [System.Int32]
            }
            It 'Should return the value 0' {
                $Result | Should Be 0
            }
        }

        Context 'There are Switch statements with 3 clauses and a default clause in the specified function' {

            $FunctionText = ($Mocks.'Get-FunctionDefinition'.SwitchStatements.Extent.Text | Out-String)
            $ScriptBlock = [System.Management.Automation.Language.Parser]::ParseInput($FunctionText, [ref]$null, [ref]$null)
            $FunctionDefinition = $ScriptBlock.FindAll({ $args[0] -is [System.Management.Automation.Language.FunctionDefinitionAst] }, $False)
            $Result = Measure-FunctionSwitchCodePath -FunctionDefinition $FunctionDefinition[0]

            It 'Should return an object of the type [System.Int32]' {
                $Result | Should BeOfType [System.Int32]
            }
            It 'Should count every clause in the Switch statement, except for the Default clause' {
                $Result | Should Be 3
            }
        }
        Context 'There are Switch statements with clauses which do not contain a break statement' {

            $FunctionText = ($Mocks.'Get-FunctionDefinition'.SwitchWithNoBreakStatements.Extent.Text | Out-String)
            $ScriptBlock = [System.Management.Automation.Language.Parser]::ParseInput($FunctionText, [ref]$null, [ref]$null)
            $FunctionDefinition = $ScriptBlock.FindAll({ $args[0] -is [System.Management.Automation.Language.FunctionDefinitionAst] }, $False)
            $Result = Measure-FunctionSwitchCodePath -FunctionDefinition $FunctionDefinition[0]

            It 'Should return an object of the type [System.Int32]' {
                $Result | Should BeOfType [System.Int32]
            }
            It 'Should return 4099' {
                $Result | Should Be 4099
            }
        }
    }
}