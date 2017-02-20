$ModuleName = 'PSCodeHealth'
Import-Module "$PSScriptRoot\..\..\..\$ModuleName\$($ModuleName).psd1" -Force

Describe 'Get-FunctionDefinition' {
    InModuleScope $ModuleName {

        $Files = (Get-ChildItem -Path "$($PSScriptRoot)\..\TestData\" -Filter '*.psm1').FullName
        
        $TestDataPublicFunctions = @('Get-Nothing', 'Set-Nothing', 'Public')
        $TestDataPrivateFunctions = 'Private'
        $TestDataNestedFunctions = 'Nested'

        $Results = Get-FunctionDefinition -Path $Files
        $PipelineInputResults = $Files | Get-FunctionDefinition

        It 'Should return objects of the type [FunctionDefinitionAst]' {
            Foreach ( $Result in $Results ) {
                $Result | Should BeOfType [System.Management.Automation.Language.FunctionDefinitionAst]
            }
        }
        It 'Should return all public functions from all files' {
            Foreach ( $PublicFunction in $TestDataPublicFunctions ) {
                $Results.Name | Where-Object { $_ -eq $PublicFunction } |
                Should Not BeNullOrEmpty
            }
        }
        It 'Should return all public functions from all files specified via pipeline input' {
            Foreach ( $PublicFunction in $TestDataPublicFunctions ) {
                $PipelineInputResults.Name | Where-Object { $_ -eq $PublicFunction } |
                Should Not BeNullOrEmpty
            }
        }
        It 'Should return private functions' {
            $Results.Name | Where-Object { $_ -eq $TestDataPrivateFunctions } |
            Should Not BeNullOrEmpty
        }
        It 'Should not return any nested function' {
            $Results.Name | Where-Object { $_ -eq $TestDataNestedFunctions } |
            Should BeNullOrEmpty
        }
        It 'Should return 2 functions from the test data file : 1Public1Nested1Private.psm1' {
            ($Results.Extent.File | Where-Object { $_ -like '*\TestData\1Public1Nested1Private.psm1' }).Count |
            Should Be 2
        }
    }
}