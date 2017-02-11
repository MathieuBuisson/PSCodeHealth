$ModuleName = 'PSCodeHealthMetrics'
Import-Module "$($PSScriptRoot)\..\..\$($ModuleName).psd1" -Force

Describe 'General Module behaviour' {
       
    $ModuleInfo = Get-Module -Name $ModuleName

    It 'The required modules should be Pester and PSScriptAnalyzer' {
        
        Foreach ( $RequiredModule in $ModuleInfo.RequiredModules.Name ) {
            $RequiredModule -in @('Pester','PSScriptAnalyzer') | Should Be $True
        }
    }
}

Describe 'Get-ModulePowerShellScript' {

    InModuleScope $ModuleName {
        
        New-Item -Path TestDrive:\Module -ItemType Directory
        New-Item -Path TestDrive:\Module\Module.psd1 -ItemType File
        New-Item -Path TestDrive:\Module\SubFolder -ItemType Directory
        New-Item -Path TestDrive:\Module\SubFolder\Module.psm1 -ItemType File
        New-Item -Path TestDrive:\Module\SubFolder\Module.ps1 -ItemType File
        New-Item -Path TestDrive:\Module\SubFolder\Module.Tests.ps1 -ItemType File
        Mock Import-Module { [PSCustomObject]@{ ModuleBase = 'TestDrive:\Module' } }

        $Results = Get-ModulePowerShellScript -Name 'Module'

        It 'Should return strings' {
            Foreach ( $Result in $Results ) {
                $Result | Should BeOfType [string]
            }
        }
        It 'Should return only files with a .ps*1 extension' {
            Foreach ( $Result in $Results ) {
                $Result | Should BeLike '*.ps*1'
            }
        }
        It 'Should not return any script with "*Tests*" in their name or path' {
            $Results | Where-Object { $_ -like "*Tests*" } | Should BeNullOrEmpty
        }
        It 'Should not return any file with the .psd1 extension' {
            $Results | Where-Object { $_ -like "*psd1" } | Should BeNullOrEmpty
        }
    }
}

Describe 'Get-ModuleFunctionDefinition' {

    InModuleScope $ModuleName {

        $TestsDirectory = Resolve-Path -Path $PSScriptRoot
        Mock Get-ModulePowerShellScript { (Get-ChildItem -Path (Join-Path $TestsDirectory 'TestData')).FullName }
        
        $TestDataPublicFunctions = @('Get-Nothing', 'Set-Nothing', 'Public')
        $TestDataPrivateFunctions = 'Private'
        $TestDataNestedFunctions = 'Nested'

        $Results = Get-ModuleFunctionDefinition -Name 'Module'

        It 'Should return objects of the type [FunctionDefinitionAst]' {
            Foreach ( $Result in $Results ) {
                $Result | Should BeOfType [System.Management.Automation.Language.FunctionDefinitionAst]
            }
        }
        It 'Should return all public functions from all script files' {
            Foreach ( $PublicFunction in $TestDataPublicFunctions ) {
                $Results.Name | Where-Object { $_ -eq $PublicFunction } |
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
            ($Results.Extent.File | Where-Object { $_ -eq "$($PSScriptRoot)\TestData\1Public1Nested1Private.psm1" }).Count |
            Should Be 2
        }
    }
}

Describe 'Test-FunctionHelpCoverage' {

    InModuleScope $ModuleName {

        $TestsDirectory = Resolve-Path -Path $PSScriptRoot
        Mock Get-ModulePowerShellScript { (Get-ChildItem -Path (Join-Path $TestsDirectory 'TestData')).FullName }

        $FunctionDefinitions = Get-ModuleFunctionDefinition -Path "$($PSScriptRoot)\TestData\2PublicFunctions.psm1"
        $FunctionsWithHelp = @('Set-Nothing', 'Get-Nothing', 'Public')
        $FunctionWithNoHelp = 'Private'

        It 'Should return a [System.Boolean]' {
            Foreach ( $FunctionDefinition in $FunctionDefinitions ) {
                Test-FunctionHelpCoverage -FunctionDefinition $FunctionDefinition |
                Should BeOfType [System.Boolean]
            }
        }
        It 'Should return True if the specified function contains some help info' {
            Foreach ( $FunctionDefinition in ($FunctionDefinitions | Where-Object { $_.Name -in $FunctionsWithHelp }) ) {
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

Describe 'Get-FunctionCodeLength' {
    InModuleScope $ModuleName {

        $TestsDirectory = Resolve-Path -Path $PSScriptRoot
        Mock Get-ModulePowerShellScript { (Get-ChildItem -Path (Join-Path $TestsDirectory 'TestData')).FullName }

        $FunctionDefinitions = Get-ModuleFunctionDefinition -Path "$($PSScriptRoot)\TestData\2PublicFunctions.psm1"
        $TestCases = @(
            @{ FunctionName = 'Public'; ExpectedNumberOfLines = 6 }
            @{ FunctionName = 'Private'; ExpectedNumberOfLines = 3 }
            @{ FunctionName = 'Get-Nothing'; ExpectedNumberOfLines = 15 }
            @{ FunctionName = 'Set-Nothing'; ExpectedNumberOfLines = 16 }
        )

        It 'Counts <ExpectedNumberOfLines> lines in the function definition : <FunctionName>' -TestCases $TestCases {
            Param ([string]$FunctionName, [int]$ExpectedNumberOfLines)

            Get-FunctionCodeLength -FunctionDefinition ($FunctionDefinitions | Where-Object { $_.Name -eq $FunctionName }) |
            Should Be $ExpectedNumberOfLines
        }
    }
}

Describe 'Get-FunctionScriptAnalyzerViolation' {
    InModuleScope $ModuleName {

        Context 'When the function contains no best practices violation' {

            $TestsDirectory = Resolve-Path -Path $PSScriptRoot
            Mock Get-ModulePowerShellScript { Join-Path $TestsDirectory 'TestData\2PublicFunctions.psm1' }
            Mock Invoke-ScriptAnalyzer { $Null }
            $FunctionDefinitions = Get-ModuleFunctionDefinition -Path "$($PSScriptRoot)\TestData\2PublicFunctions.psm1"

            It 'Should return 0' {
                Get-FunctionScriptAnalyzerViolation -FunctionDefinition $FunctionDefinitions[0] |
                Should Be 0
            }
        }
        Context 'When the function contains 1 best practices violation' {

            $TestsDirectory = Resolve-Path -Path $PSScriptRoot
            Mock Get-ModulePowerShellScript { Join-Path $TestsDirectory 'TestData\2PublicFunctions.psm1' }
            Mock Invoke-ScriptAnalyzer { '1 violation' }
            $FunctionDefinitions = Get-ModuleFunctionDefinition -Path "$($PSScriptRoot)\TestData\2PublicFunctions.psm1"

            It 'Should return 1' {
                Get-FunctionScriptAnalyzerViolation -FunctionDefinition $FunctionDefinitions[0] |
                Should Be 1
            }
        }
        Context 'When the function contains 3 best practices violations' {

            $TestsDirectory = Resolve-Path -Path $PSScriptRoot
            Mock Get-ModulePowerShellScript { Join-Path $TestsDirectory 'TestData\2PublicFunctions.psm1' }
            Mock Invoke-ScriptAnalyzer { 'First violation', 'Second', 'Third' }
            $FunctionDefinitions = Get-ModuleFunctionDefinition -Path "$($PSScriptRoot)\TestData\2PublicFunctions.psm1"

            It 'Should return 3' {
                Get-FunctionScriptAnalyzerViolation -FunctionDefinition $FunctionDefinitions[0] |
                Should Be 3
            }
        }
    }
}