Function New-FailedTestsInfo {
<#
.SYNOPSIS
    Creates one or more custom objects of the type : 'PSCodeHealth.Overall.FailedTestsInfo'.  

.DESCRIPTION
    Creates one or more custom objects of the type : 'PSCodeHealth.Overall.FailedTestsInfo'.  
    This outputs an object containing key information about each failed test. This information is used in the overall health report.  

.PARAMETER TestsResult
    To specify the Pester tests result object.

.EXAMPLE
    PS C:\> New-FailedTestsInfo -TestsResult $TestsResult

    Returns a new custom object of the type 'PSCodeHealth.Overall.FailedTestsInfo' for each failed test in the input $TestsResult.

.OUTPUTS
    PSCodeHealth.Overall.FailedTestsInfo

.NOTES    
#>
    [CmdletBinding()]
    [OutputType([PSCustomObject[]])]
    Param (
        [Parameter(Position=0, Mandatory)]
        [PSCustomObject]$TestsResult
    )
    $FailedTests = $TestsResult.TestResult.Where({ -not $_.Passed })

    Foreach ( $FailedTest in $FailedTests ) {

        $SplitStackTrace = $FailedTest.StackTrace -split ':\s'
        $File = ($SplitStackTrace[0] -split '\\')[-1]
        $Line = ((($SplitStackTrace[1] -split '\n') | Where-Object { $_ -match 'line' }) -split '\s')
        $LineNumber = $Line | Where-Object { $_ -match '\d+' }

        $ObjectProperties = [ordered]@{
            'File'         = $File
            'Line'         = $LineNumber
            'Describe'     = $FailedTest.Describe
            'TestName'     = $FailedTest.Name
            'ErrorMessage' = $FailedTest.FailureMessage
        }

        $CustomObject = New-Object -TypeName PSObject -Property $ObjectProperties
        $CustomObject.psobject.TypeNames.Insert(0, 'PSCodeHealth.Overall.FailedTestsInfo')
        $CustomObject
    }
}