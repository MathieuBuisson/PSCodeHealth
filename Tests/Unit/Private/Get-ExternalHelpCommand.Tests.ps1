$ModuleName = 'PSCodeHealth'
Import-Module "$PSScriptRoot\..\..\..\$ModuleName\$($ModuleName).psd1" -Force

Describe 'Get-ExternalHelpCommand' {
    InModuleScope $ModuleName {
        Context 'The specified folder does not contain any external help file' {

            It 'Should not throw' {
               {Get-ExternalHelpCommand -Path $TestDrive} | Should -Not -Throw
            }
        }
        Context 'The specified folder contains an external help file with invalid XML' {

            $InvalidXmlFile = "$PSScriptRoot\..\..\TestData\InvalidHelp"
            
            It 'Should not throw' {
                {Get-ExternalHelpCommand -Path $InvalidXmlFile -WarningAction SilentlyContinue} |
                Should -Not -Throw
             }
         }
        Context 'The specified folder contains a valid external help file' {
            
            $HelpFile = "$PSScriptRoot\..\..\TestData\TestHelp"
            $Results = Get-ExternalHelpCommand -Path $HelpFile
            $ExpectedCommandName = @('Get-PlasterTemplate', 'Invoke-Plaster', 'New-PlasterManifest', 'Test-PlasterManifest')

            It 'Should return an object of the type [string]' {
                Foreach ( $Result in $Results ) {
                    $Result | Should -BeOfType [string]
                }
            }
            It 'Should return 4 objects' {
                $Results.Count | Should -Be 4
            }
            It 'Should return the expected command names from the external help file' {
                Foreach ( $Result in $Results ) {
                    $Result | Should -BeIn $ExpectedCommandName
                }
            }
        }
    }
}