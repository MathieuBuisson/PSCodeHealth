$ModuleName = 'PSCodeHealth'
Import-Module "$($PSScriptRoot)\..\..\..\$($ModuleName).psd1" -Force

Describe 'Write-VerboseOutput' {
    InModuleScope $ModuleName {

        Context 'Formatted DateTime' {

            Mock Write-Verbose -ParameterFilter { $Message -match "^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}" } { }

            It 'Should call Write-Verbose with correctly formatted date in the Message parameter' {
                $Null = Write-VerboseOutput -Message 'Test'
                Assert-MockCalled -CommandName Write-Verbose -Scope It -ParameterFilter { $Message -match "^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}" }
            }
        }
        Context 'Message' {

            Mock Write-Verbose -ParameterFilter { $Message -match "Test$" } { }

            It 'Should call Write-Verbose with message in the Message parameter' {
                $Null = Write-VerboseOutput -Message 'Test'
                Assert-MockCalled -CommandName Write-Verbose -Scope It -ParameterFilter { $Message -match "Test$" }
            }
        }
    }
}