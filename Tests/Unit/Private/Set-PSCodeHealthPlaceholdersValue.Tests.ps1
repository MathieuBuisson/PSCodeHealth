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
                DATE = '2017-07-01 21:50:52Z'
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
            It 'Replaces properly 3 placeholders in a line' {
                $Result[5] |
                Should Be '        PSCodeHealth Report - StringValue1 <small class="analyzed-path"> StringValue2 - 2017-07-01 21:50:52Z</small>'
            }
        }
        Context 'The PlaceholderData has placeholders values containing collections' {

            $TestReportTitle = @('Line1','Line2','Line3','Line4')
            $TestDate = @(1,2,3)
            $PlaceholdersData = @{
                REPORT_TITLE = $TestReportTitle
                DATE = $TestDate
            }
            $Result = Set-PSCodeHealthPlaceholdersValue -TemplatePath $MockedFile.FullName -PlaceholdersData $PlaceholdersData

            It 'Should add lines to the content for each multi-string placeholder value' {
                ($Result -split "`n").Count | Should Be (7 + ($TestReportTitle.Count * 2 + $TestDate.Count))
            }
            It 'Replaces properly a multi-string placeholder value in a line' {
                $Result[0] | Should BeLike '<title>PSCodeHealth Report - Line1*Line2*Line3*Line4*</title>'
            }
        }
        Context 'The Html parameter is specified' {

            $PlaceholdersData = @{
                REPORT_TITLE = 'StringValue1'
                ANALYZED_PATH = 'StringValue2'
                DATE = '2017-07-01 21:50:52Z'
            }
            $Result = Set-PSCodeHealthPlaceholdersValue -Html $MockedContent -PlaceholdersData $PlaceholdersData

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
            It 'Replaces properly 3 placeholders in a line' {
                $Result[5] |
                Should Be '        PSCodeHealth Report - StringValue1 <small class="analyzed-path"> StringValue2 - 2017-07-01 21:50:52Z</small>'
            }
        }
    }
}