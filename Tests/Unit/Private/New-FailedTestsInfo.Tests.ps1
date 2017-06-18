$ModuleName = 'PSCodeHealth'
Import-Module "$PSScriptRoot\..\..\..\$ModuleName\$($ModuleName).psd1" -Force

Describe 'New-FailedTestsInfo' {
    InModuleScope $ModuleName {

        $Mocks = ConvertFrom-Json (Get-Content -Path "$($PSScriptRoot)\..\..\TestData\MockObjects.json" -Raw )
        $MockTestsResult = $Mocks.'Invoke-Pester'.'2FailedTests'.Where({ $_ })

        Context 'The specified test result contains 2 failed tests' {

            $Results = New-FailedTestsInfo -TestsResult $MockTestsResult

            It 'Should return objects of the type [PSCodeHealth.Overall.FailedTestsInfo]' {
                Foreach ( $Result in $Results ) {
                    $Result | Should BeOfType [PSCustomObject]
                    ($Result | Get-Member).TypeName[0] | Should Be 'PSCodeHealth.Overall.FailedTestsInfo'
                }
            }
            It 'Should return 2 objects' {
                $Results.Count | Should Be 2
            }
            It 'Should return an object with the expected property "File"' {
                Foreach ( $Result in $Results ) {
                    $Result.File | Should Be 'Coveralls.Tests.ps1'
                }
            }
            It 'Should return an object with the expected property "Line"' {
                Foreach ( $Result in $Results ) {
                    $Result.Line | Should BeIn @('97','101')
                }
            }
            It 'Should return an object with the expected property "Describe"' {
                Foreach ( $Result in $Results ) {
                    $Result.Describe | Should BeIn @('MockDescribe','MockDescribe2')
                }
            }
            It 'Should return an object with the expected property "TestName"' {
                Foreach ( $Result in $Results ) {
                    $Result.TestName | Should BeIn @('MockTestName','MockTestName2')
                }
            }
            It 'Should return an object with the expected property "ErrorMessage"' {
                Foreach ( $Result in $Results ) {
                    $Result.ErrorMessage | Should BeIn @('MockFailureMessage','MockFailureMessage2')
                }
            }
        }
    }
}