$ModuleName = 'PSCodeHealth'
Import-Module "$PSScriptRoot\..\..\..\$ModuleName\$($ModuleName).psd1" -Force

Describe 'Set-PSCodeHealthPlaceholdersValue' {
    InModuleScope $ModuleName {

        $Mocks = ConvertFrom-Json (Get-Content -Path "$($PSScriptRoot)\..\..\TestData\MockObjects.json" -Raw )
        $MockedContent = $Mocks.'Get-Content'
        Mock Get-Content { $MockedContent }
        $MockedFile = New-Item -Path TestDrive:\Template.html -ItemType File

        Context 'The template file does not contain any placeholder matching any key of the specified PlaceholdersData' {

            $PlaceholdersData = @{ DOES_NOT_EXIST = 'StringValue'}
            $Result = Set-PSCodeHealthPlaceholdersValue -TemplatePath $MockedFile.FullName -PlaceholdersData $PlaceholdersData

            It 'Should return 7 lines' {
                $Result.Count | Should Be 7
            }
            It 'Should return the content of the template file unmodified' {
                $Result | Should Be $MockedContent
            }
        }
        Context 'The template file contains 4 placeholders matching 3 keys of the specified PlaceholdersData' {

            $PlaceholdersData = @{
                REPORT_TITLE = 'StringValue1'
                ANALYZED_PATH = 'StringValue2'
                DATE = Get-Date -Format u
            }
            $Result = Set-PSCodeHealthPlaceholdersValue -TemplatePath $MockedFile.FullName -PlaceholdersData $PlaceholdersData

            It 'Should return 7 lines' {
                $Result.Count | Should Be 7
            }
            It 'Replaces properly a single placeholder in a line' {
                $Result[0] | Should Be '<title>PSCodeHealth Report - StringValue1</title>'
            }
            It 'Does not modify lines which do not contain any placeholder' {
                $Result[1] | Should Be '</head>'
                $Result[2] | Should Be '<body>'
            }
        }
    }
}