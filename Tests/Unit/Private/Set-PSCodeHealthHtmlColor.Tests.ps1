$ModuleName = 'PSCodeHealth'
Import-Module "$PSScriptRoot\..\..\..\$ModuleName\$($ModuleName).psd1" -Force

Describe 'Set-PSCodeHealthHtmlColor' {
    InModuleScope $ModuleName {

        $TemplatePath = "$PSScriptRoot\..\..\..\PSCodeHealth\Assets\HealthReport.html"
        $TestHtml = Get-Content -Path $TemplatePath
        $LINES_OF_CODE_TOTAL_COMPLIANCELines = (Select-String $TemplatePath -Pattern 'LINES_OF_CODE_TOTAL_COMPLIANCE').LineNumber
        $SCRIPTANALYZER_TOTAL_COMPLIANCELines = (Select-String $TemplatePath -Pattern 'SCRIPTANALYZER_TOTAL_COMPLIANCE').LineNumber
        $SCRIPTANALYZER_ERRORS_COMPLIANCELines = (Select-String $TemplatePath -Pattern 'SCRIPTANALYZER_ERRORS_COMPLIANCE').LineNumber
        $SCRIPTANALYZER_WARNINGS_COMPLIANCELines = (Select-String $TemplatePath -Pattern 'SCRIPTANALYZER_WARNINGS_COMPLIANCE').LineNumber
        $SCRIPTANALYZER_INFO_COMPLIANCELines = (Select-String $TemplatePath -Pattern 'SCRIPTANALYZER_INFO_COMPLIANCE').LineNumber
        $TESTS_PASS_RATE_COMPLIANCELines = (Select-String $TemplatePath -Pattern 'TESTS_PASS_RATE_COMPLIANCE').LineNumber
        $TEST_COVERAGE_COMPLIANCELines = (Select-String $TemplatePath -Pattern 'TEST_COVERAGE_COMPLIANCE').LineNumber
        $SCRIPTANALYZER_AVERAGE_COMPLIANCELines = (Select-String $TemplatePath -Pattern 'SCRIPTANALYZER_AVERAGE_COMPLIANCE').LineNumber
        $COMPLEXITY_HIGHEST_COMPLIANCELines = (Select-String $TemplatePath -Pattern 'COMPLEXITY_HIGHEST_COMPLIANCE').LineNumber
        $NESTING_DEPTH_HIGHEST_COMPLIANCELines = (Select-String $TemplatePath -Pattern 'NESTING_DEPTH_HIGHEST_COMPLIANCE').LineNumber
        $LINES_OF_CODE_AVERAGE_COMPLIANCELines = (Select-String $TemplatePath -Pattern 'LINES_OF_CODE_AVERAGE_COMPLIANCE').LineNumber
        $COMPLEXITY_AVERAGE_COMPLIANCELines = (Select-String $TemplatePath -Pattern 'COMPLEXITY_AVERAGE_COMPLIANCE').LineNumber
        $NESTING_DEPTH_AVERAGE_COMPLIANCELines = (Select-String $TemplatePath -Pattern 'NESTING_DEPTH_AVERAGE_COMPLIANCE').LineNumber
        $COMMANDS_MISSED_TOTAL_COMPLIANCELines = (Select-String $TemplatePath -Pattern 'COMMANDS_MISSED_TOTAL_COMPLIANCE').LineNumber
        
        $Mocks = ConvertFrom-Json (Get-Content -Path "$($PSScriptRoot)\..\..\TestData\MockObjects.json" -Raw)

        Context 'The input health report does not contain any FunctionHealthRecords' {

            $HealthReport = $Mocks.'Invoke-PSCodeHealth'.NoFunctionHealthRecord | Where-Object { $_ }
            $HealthReport.psobject.TypeNames.Insert(0, 'PSCodeHealth.Overall.HealthReport')
            $TestParams = @{
                HealthReport = $HealthReport
                Compliance = Test-PSCodeHealthCompliance -HealthReport $HealthReport
                PerFunctionCompliance = $Null
                Html = $TestHtml
            }
            $Result = Set-PSCodeHealthHtmlColor @TestParams

            It 'Should return objects of the type "System.String"' {
                ($Result | Get-Member).TypeName[0] | Should Be 'System.String'
            }
            It 'Should replace all {LINES_OF_CODE_TOTAL_COMPLIANCE} placeholders with "success"' {
                Foreach ( $Line in $LINES_OF_CODE_TOTAL_COMPLIANCELines ) {
                    $Result[($Line - 1)] | Should Match 'success'
                }
            }
            It 'Should replace all {SCRIPTANALYZER_TOTAL_COMPLIANCE} placeholders with "success"' {
                Foreach ( $Line in $SCRIPTANALYZER_TOTAL_COMPLIANCELines ) {
                    $Result[($Line - 1)] | Should Match 'success'
                }
            }
            It 'Should replace all {SCRIPTANALYZER_ERRORS_COMPLIANCE} placeholders with "success"' {
                Foreach ( $Line in $SCRIPTANALYZER_ERRORS_COMPLIANCELines ) {
                    $Result[($Line - 1)] | Should Match 'success'
                }
            }
            It 'Should replace all {SCRIPTANALYZER_WARNINGS_COMPLIANCE} placeholders with "success"' {
                Foreach ( $Line in $SCRIPTANALYZER_WARNINGS_COMPLIANCELines ) {
                    $Result[($Line - 1)] | Should Match 'success'
                }
            }
            It 'Should replace all {SCRIPTANALYZER_INFO_COMPLIANCE} placeholders with "success"' {
                Foreach ( $Line in $SCRIPTANALYZER_INFO_COMPLIANCELines ) {
                    $Result[($Line - 1)] | Should Match 'success'
                }
            }
            It 'Should replace all {TESTS_PASS_RATE_COMPLIANCE} placeholders with "danger"' {
                Foreach ( $Line in $TESTS_PASS_RATE_COMPLIANCELines ) {
                    $Result[($Line - 1)] | Should Match 'danger'
                }
            }
            It 'Should replace all {TEST_COVERAGE_COMPLIANCE} placeholders with "danger"' {
                Foreach ( $Line in $TEST_COVERAGE_COMPLIANCELines ) {
                    $Result[($Line - 1)] | Should Match 'danger'
                }
            }
            It 'Should replace all {SCRIPTANALYZER_AVERAGE_COMPLIANCE} placeholders with "success"' {
                Foreach ( $Line in $SCRIPTANALYZER_AVERAGE_COMPLIANCELines ) {
                    $Result[($Line - 1)] | Should Match 'success'
                }
            }
            It 'Should replace all {COMPLEXITY_HIGHEST_COMPLIANCE} placeholders with "success"' {
                Foreach ( $Line in $COMPLEXITY_HIGHEST_COMPLIANCELines ) {
                    $Result[($Line - 1)] | Should Match 'success'
                }
            }
            It 'Should replace all {NESTING_DEPTH_HIGHEST_COMPLIANCE} placeholders with "success"' {
                Foreach ( $Line in $NESTING_DEPTH_HIGHEST_COMPLIANCELines ) {
                    $Result[($Line - 1)] | Should Match 'success'
                }
            }
            It 'Should replace all {LINES_OF_CODE_AVERAGE_COMPLIANCE} placeholders with "success"' {
                Foreach ( $Line in $LINES_OF_CODE_AVERAGE_COMPLIANCELines ) {
                    $Result[($Line - 1)] | Should Match 'success'
                }
            }
            It 'Should replace all {COMPLEXITY_AVERAGE_COMPLIANCE} placeholders with "success"' {
                Foreach ( $Line in $COMPLEXITY_AVERAGE_COMPLIANCELines ) {
                    $Result[($Line - 1)] | Should Match 'success'
                }
            }
            It 'Should replace all {NESTING_DEPTH_AVERAGE_COMPLIANCE} placeholders with "success"' {
                Foreach ( $Line in $NESTING_DEPTH_AVERAGE_COMPLIANCELines ) {
                    $Result[($Line - 1)] | Should Match 'success'
                }
            }
            It 'Should replace all {COMMANDS_MISSED_TOTAL_COMPLIANCE} placeholders with "warning"' {
                Foreach ( $Line in $COMMANDS_MISSED_TOTAL_COMPLIANCELines ) {
                    $Result[($Line - 1)] | Should Match 'warning'
                }
            }            
        }
        Context 'The input health report contains 2 FunctionHealthRecords' {

            $HealthReport = $Mocks.'Invoke-PSCodeHealth'.'2FunctionHealthRecords' | Where-Object { $_ }
            $HealthReport.psobject.TypeNames.Insert(0, 'PSCodeHealth.Overall.HealthReport')
            $BestPracticesRows = @'
                                    <tr>
                                        <td>Test-Function1</td>
                                        <td class="{Test-Function1_SCRIPTANALYZER_FINDINGS}">3</td>
                                        <td class="{Test-Function1_FINDINGS_DETAILS}"></td>
                                        <td class="{Test-Function1_CONTAINS_HELP}">False</td>
                                    </tr>
                                    <tr>
                                        <td>Test-Function2</td>
                                        <td class="{Test-Function2_SCRIPTANALYZER_FINDINGS}">6</td>
                                        <td class="{Test-Function2_FINDINGS_DETAILS}"></td>
                                        <td class="{Test-Function2_CONTAINS_HELP}">True</td>
                                    </tr>
'@
            $MaintainabilityRows = @'
                                    <tr>
                                        <td>Test-Function1</td>
                                        <td class="{Test-Function1_LINES_OF_CODE_COMPLIANCE}">101</td>
                                        <td class="{Test-Function1_COMPLEXITY_COMPLIANCE}">19</td>
                                        <td class="{Test-Function1_MAXIMUM_NESTING_DEPTH_COMPLIANCE}">5</td>
                                    </tr>
                                    <tr>
                                        <td>Test-Function2</td>
                                        <td class="{Test-Function2_LINES_OF_CODE_COMPLIANCE}">86</td>
                                        <td class="{Test-Function2_COMPLEXITY_COMPLIANCE}">12</td>
                                        <td class="{Test-Function2_MAXIMUM_NESTING_DEPTH_COMPLIANCE}">2</td>
                                    </tr>
'@
            $CoverageRows = @'
                                    <tr>
                                        <td>Test-Function1</td>
                                        <td class="{Test-Function1_TEST_COVERAGE_COMPLIANCE}">79</td>
                                        <td class="{Test-Function1_COMMANDS_MISSED_COMPLIANCE}">12</td>
                                    </tr>
                                    <tr>
                                        <td>Test-Function2</td>
                                        <td class="{Test-Function2_TEST_COVERAGE_COMPLIANCE}">83</td>
                                        <td class="{Test-Function2_COMMANDS_MISSED_COMPLIANCE}">11</td>
                                    </tr>
'@
            $HtmlPlaceholders = @{
                BEST_PRACTICES_TABLE_ROWS = $BestPracticesRows
                MAINTAINABILITY_TABLE_ROWS = $MaintainabilityRows
                COVERAGE_TABLE_ROWS = $CoverageRows
            }
            $HtmlContent = Set-PSCodeHealthPlaceholdersValue -Html $TestHtml -PlaceholdersData $HtmlPlaceholders
            $ExpectedBestPracticesRows = @'
                                    <tr>
                                        <td>Test-Function1</td>
                                        <td class="success">3</td>
                                        <td class="danger"></td>
                                        <td class="danger">False</td>
                                    </tr>
                                    <tr>
                                        <td>Test-Function2</td>
                                        <td class="success">6</td>
                                        <td class="danger"></td>
                                        <td class="success">True</td>
                                    </tr>
'@
            $ExpectedMaintainabilityRows = @'
                                    <tr>
                                        <td>Test-Function1</td>
                                        <td class="danger">101</td>
                                        <td class="warning">19</td>
                                        <td class="warning">5</td>
                                    </tr>
                                    <tr>
                                        <td>Test-Function2</td>
                                        <td class="danger">86</td>
                                        <td class="success">12</td>
                                        <td class="success">2</td>
                                    </tr>
'@
            $ExpectedCoverageRows = @'
                                    <tr>
                                        <td>Test-Function1</td>
                                        <td class="warning">79</td>
                                        <td class="warning">12</td>
                                    </tr>
                                    <tr>
                                        <td>Test-Function2</td>
                                        <td class="success">83</td>
                                        <td class="warning">11</td>
                                    </tr>
'@
            
            $FunctionHealthRecords = $HealthReport.FunctionHealthRecords
            $TestParams = @{
                HealthReport = $HealthReport
                Compliance = Test-PSCodeHealthCompliance -HealthReport $HealthReport
                PerFunctionCompliance = $FunctionHealthRecords.FunctionName.ForEach({ Test-PSCodeHealthCompliance $HealthReport -FunctionName $_ })
                Html = $HtmlContent
            }
            $Result = Set-PSCodeHealthHtmlColor @TestParams

            It 'Should return objects of the type "System.String"' {
                ($Result | Get-Member).TypeName[0] | Should Be 'System.String'
            }
            It 'Should replace all {LINES_OF_CODE_TOTAL_COMPLIANCE} placeholders with "success"' {
                Foreach ( $Line in $LINES_OF_CODE_TOTAL_COMPLIANCELines ) {
                    $Result[($Line - 1)] | Should Match 'success'
                }
            }
            It 'Should replace all {SCRIPTANALYZER_TOTAL_COMPLIANCE} placeholders with "success"' {
                Foreach ( $Line in $SCRIPTANALYZER_TOTAL_COMPLIANCELines ) {
                    $Result[($Line - 1)] | Should Match 'success'
                }
            }
            It 'Should replace all {SCRIPTANALYZER_ERRORS_COMPLIANCE} placeholders with "warning"' {
                Foreach ( $Line in $SCRIPTANALYZER_ERRORS_COMPLIANCELines ) {
                    $Result[($Line - 1)] | Should Match 'warning'
                }
            }
            It 'Should replace all {SCRIPTANALYZER_WARNINGS_COMPLIANCE} placeholders with "success"' {
                Foreach ( $Line in $SCRIPTANALYZER_WARNINGS_COMPLIANCELines ) {
                    $Result[($Line - 1)] | Should Match 'success'
                }
            }
            It 'Should replace all {SCRIPTANALYZER_INFO_COMPLIANCE} placeholders with "success"' {
                Foreach ( $Line in $SCRIPTANALYZER_INFO_COMPLIANCELines ) {
                    $Result[($Line - 1)] | Should Match 'success'
                }
            }
            It 'Should replace all {TESTS_PASS_RATE_COMPLIANCE} placeholders with "danger"' {
                Foreach ( $Line in $TESTS_PASS_RATE_COMPLIANCELines ) {
                    $Result[($Line - 1)] | Should Match 'danger'
                }
            }
            It 'Should replace all {TEST_COVERAGE_COMPLIANCE} placeholders with "success"' {
                Foreach ( $Line in $TEST_COVERAGE_COMPLIANCELines ) {
                    $Result[($Line - 1)] | Should Match 'success'
                }
            }
            It 'Should replace all {SCRIPTANALYZER_AVERAGE_COMPLIANCE} placeholders with "success"' {
                Foreach ( $Line in $SCRIPTANALYZER_AVERAGE_COMPLIANCELines ) {
                    $Result[($Line - 1)] | Should Match 'success'
                }
            }
            It 'Should replace all {COMPLEXITY_HIGHEST_COMPLIANCE} placeholders with "success"' {
                Foreach ( $Line in $COMPLEXITY_HIGHEST_COMPLIANCELines ) {
                    $Result[($Line - 1)] | Should Match 'success'
                }
            }
            It 'Should replace all {NESTING_DEPTH_HIGHEST_COMPLIANCE} placeholders with "success"' {
                Foreach ( $Line in $NESTING_DEPTH_HIGHEST_COMPLIANCELines ) {
                    $Result[($Line - 1)] | Should Match 'success'
                }
            }
            It 'Should replace all {LINES_OF_CODE_AVERAGE_COMPLIANCE} placeholders with "danger"' {
                Foreach ( $Line in $LINES_OF_CODE_AVERAGE_COMPLIANCELines ) {
                    $Result[($Line - 1)] | Should Match 'danger'
                }
            }
            It 'Should replace all {COMPLEXITY_AVERAGE_COMPLIANCE} placeholders with "warning"' {
                Foreach ( $Line in $COMPLEXITY_AVERAGE_COMPLIANCELines ) {
                    $Result[($Line - 1)] | Should Match 'warning'
                }
            }
            It 'Should replace all {NESTING_DEPTH_AVERAGE_COMPLIANCE} placeholders with "success"' {
                Foreach ( $Line in $NESTING_DEPTH_AVERAGE_COMPLIANCELines ) {
                    $Result[($Line - 1)] | Should Match 'success'
                }
            }
            It 'Should replace all {COMMANDS_MISSED_TOTAL_COMPLIANCE} placeholders with "success"' {
                Foreach ( $Line in $COMMANDS_MISSED_TOTAL_COMPLIANCELines ) {
                    $Result[($Line - 1)] | Should Match 'success'
                }
            }
            It 'Should replace the per-function best practices placeholders as expected' {
                ($Result | Where-Object { $_ -match 'Test-Function' })[0] | Should Be $ExpectedBestPracticesRows
            }
            It 'Should replace the per-function maintainability placeholders as expected' {
                ($Result | Where-Object { $_ -match 'Test-Function' })[1] | Should Be $ExpectedMaintainabilityRows
            }
            It 'Should replace the per-function test coverage placeholders as expected' {
                ($Result | Where-Object { $_ -match 'Test-Function' })[-1] | Should Be $ExpectedCoverageRows
            }
        }
    }
}