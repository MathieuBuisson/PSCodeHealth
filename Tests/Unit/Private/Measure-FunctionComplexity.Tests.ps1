$ModuleName = 'PSCodeHealth'
Import-Module "$PSScriptRoot\..\..\..\$ModuleName\$($ModuleName).psd1" -Force

Describe 'Measure-FunctionComplexity' {
    InModuleScope $ModuleName {

        $Mocks = ConvertFrom-Json (Get-Content -Path "$($PSScriptRoot)\..\..\TestData\MockObjects.json" -Raw )

        Context 'There is no branching statement in the specified function' {

            $FunctionText = ($Mocks.'Get-FunctionDefinition'.NoBranching.Extent.Text | Out-String)
            $ScriptBlock = [System.Management.Automation.Language.Parser]::ParseInput($FunctionText, [ref]$null, [ref]$null)
            $FunctionDefinition = $ScriptBlock.FindAll({ $args[0] -is [System.Management.Automation.Language.FunctionDefinitionAst] }, $False)
            $Result = Measure-FunctionComplexity -FunctionDefinition $FunctionDefinition[0]

            It 'Should return an object of the type [System.Int32]' {
                $Result | Should BeOfType [System.Int32]
            }
            It 'Should return the value 1' {
                $Result | Should Be 1
            }
        }

        Context 'There are 19 branching statements of multiple types' {

            $FunctionText = ($Mocks.'Get-FunctionDefinition'.MultipleBranchings.Extent.Text | Out-String)
            $ScriptBlock = [System.Management.Automation.Language.Parser]::ParseInput($FunctionText, [ref]$null, [ref]$null)
            $FunctionDefinition = $ScriptBlock.FindAll({ $args[0] -is [System.Management.Automation.Language.FunctionDefinitionAst] }, $False)
            $Result = Measure-FunctionComplexity -FunctionDefinition $FunctionDefinition[0]

            It 'Should return an object of the type [System.Int32]' {
                $Result | Should BeOfType [System.Int32]
            }
            It 'Should return 1 + the number of code paths due to branching statements' {
                $Result | Should Be 20
            }
        }
    }
}