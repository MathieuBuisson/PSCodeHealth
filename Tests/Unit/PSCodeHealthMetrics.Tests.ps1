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

Describe 'Write-VerboseOutput' {
    InModuleScope $ModuleName {

        Context 'Formatted DateTime' {

            Mock Write-Verbose -ParameterFilter { $Message -match "^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}" } { }

            It 'Should call Write-Verbose with correctly formatted date in the Message parameter' {
                $Null = Write-VerboseOutput -Message 'Test'
                Assert-MockCalled -CommandName Write-Verbose -Exactly -Times 1 -Scope It
            }
        }
        Context 'Message' {

            Mock Write-Verbose -ParameterFilter { $Message -match "Test$" } { }

            It 'Should call Write-Verbose with message in the Message parameter' {
                $Null = Write-VerboseOutput -Message 'Test'
                Assert-MockCalled -CommandName Write-Verbose -Exactly -Times 1 -Scope It
            }
        }
    }
}

Describe 'Get-PowerShellFile' {
    InModuleScope $ModuleName {
        
        New-Item -Path TestDrive:\Module -ItemType Directory
        New-Item -Path TestDrive:\Module\Module.psd1 -ItemType File
        New-Item -Path TestDrive:\Module\SubFolder -ItemType Directory
        New-Item -Path TestDrive:\Module\SubFolder\Module.psm1 -ItemType File
        New-Item -Path TestDrive:\Module\SubFolder\Module.psd1 -ItemType File
        New-Item -Path TestDrive:\Module\SubFolder\Module.ps1 -ItemType File
        New-Item -Path TestDrive:\Module\SubFolder\Module.Tests.ps1 -ItemType File

        $Results = Get-PowerShellFile -Path TestDrive:\Module -Recurse
        $PipelineInputResults = 'TestDrive:\Module' | Get-PowerShellFile

        It 'Should return strings' {
            Foreach ( $Result in $Results ) {
                $Result | Should BeOfType [string]
            }
        }
        It 'Should work with the Path input from the pipeline' {
            Foreach ( $Result in $PipelineInputResults ) {
                $PipelineInputResults | Should BeOfType [string]
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
        It 'Should not return any file from subdirectories without the Recurse parameter' {
            $PipelineInputResults.Count | Should Be 1
        }
        It 'Should return any file from directory and all subdirectories with the Recurse parameter' {
            $Results.Count | Should Be 4
        }
    }
}

Describe 'Get-FunctionDefinition' {
    InModuleScope $ModuleName {

        $Files = (Get-ChildItem -Path (Join-Path -Path $PSScriptRoot -ChildPath 'TestData') -Filter '*.psm1').FullName
        
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
            ($Results.Extent.File | Where-Object { $_ -eq "$($PSScriptRoot)\TestData\1Public1Nested1Private.psm1" }).Count |
            Should Be 2
        }
    }
}

Describe 'Test-FunctionHelpCoverage' {
    InModuleScope $ModuleName {

        $Files = (Get-ChildItem -Path (Join-Path -Path $PSScriptRoot -ChildPath 'TestData') -Filter '*.psm1').FullName
        $FunctionDefinitions = Get-FunctionDefinition -Path $Files
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

        $Files = (Get-ChildItem -Path (Join-Path -Path $PSScriptRoot -ChildPath 'TestData') -Filter '*.psm1').FullName
        $FunctionDefinitions = Get-FunctionDefinition -Path $Files
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

            $Files = (Get-ChildItem -Path (Join-Path -Path $PSScriptRoot -ChildPath 'TestData') -Filter '*.psm1').FullName
            $FunctionDefinitions = Get-FunctionDefinition -Path $Files
            Mock Invoke-ScriptAnalyzer { }

            It 'Should return 0' {
                Get-FunctionScriptAnalyzerViolation -FunctionDefinition $FunctionDefinitions[0] |
                Should Be 0
            }
        }
        Context 'When the function contains 1 best practices violation' {

            $Files = (Get-ChildItem -Path (Join-Path -Path $PSScriptRoot -ChildPath 'TestData') -Filter '*.psm1').FullName
            $FunctionDefinitions = Get-FunctionDefinition -Path $Files
            Mock Invoke-ScriptAnalyzer { '1 violation' }

            It 'Should return 1' {
                Get-FunctionScriptAnalyzerViolation -FunctionDefinition $FunctionDefinitions[0] |
                Should Be 1
            }
        }
        Context 'When the function contains 3 best practices violations' {

            $Files = (Get-ChildItem -Path (Join-Path -Path $PSScriptRoot -ChildPath 'TestData') -Filter '*.psm1').FullName
            $FunctionDefinitions = Get-FunctionDefinition -Path $Files
            Mock Invoke-ScriptAnalyzer { 'First violation', 'Second', 'Third' }

            It 'Should return 3' {
                Get-FunctionScriptAnalyzerViolation -FunctionDefinition $FunctionDefinitions[0] |
                Should Be 3
            }
        }
    }
}

Describe 'Get-FunctionTestCoverage' {
    InModuleScope $ModuleName {

        $FunctionDefinitions = Get-FunctionDefinition -Path "$($PSScriptRoot)\TestData\1Public1Nested1Private.psm1"
        $FunctionDefinitions2 = Get-FunctionDefinition -Path "$($PSScriptRoot)\TestData\2PublicFunctions.psm1"
        
        It 'Should return a [System.Double]' {
            Foreach ( $FunctionDefinition in $FunctionDefinitions ) {
                Get-FunctionTestCoverage -FunctionDefinition $FunctionDefinition |
                Should BeOfType [System.Double]
            }
        }
        It "Should return 0 if Pester doesn't find any command in the function" {
            $EmptyFunction = $FunctionDefinitions2 | Where-Object { $_.Name -eq 'Get-Nothing' }
            Get-FunctionTestCoverage -FunctionDefinition $EmptyFunction |
            Should Be 0
        }
        It 'Should run tests only from the specified file if TestsPath is a file' {

        }
        It 'Should run tests only from the directory and any subdirectories if TestsPath is a directory' {

        }
        It 'Should run tests from the directory of the file containing the specified function, and any subdirectories' {

        }
    }
}