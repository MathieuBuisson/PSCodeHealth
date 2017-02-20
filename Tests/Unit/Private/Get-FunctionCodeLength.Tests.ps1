$ModuleName = 'PSCodeHealth'
Import-Module "$PSScriptRoot\..\..\..\$ModuleName\$($ModuleName).psd1" -Force

Describe 'Get-FunctionCodeLength' {
    InModuleScope $ModuleName {

        $Files = (Get-ChildItem -Path "$($PSScriptRoot)\..\TestData\" -Filter '*.psm1').FullName
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