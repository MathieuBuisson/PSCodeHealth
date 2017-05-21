Function New-PSCodeHealthHtmlReport {
<#
.SYNOPSIS
    

.DESCRIPTION
    
.PARAMETER HealthReport
    The PSCodeHealth report (object of the type PSCodeHealth.Overall.HealthReport) to analyze for compliance.  
    The ouput of the command Invoke-PSCodeHealth is a PSCodeHealth report and can be bound to this parameter via pipeline input.  

.OUTPUTS
    
#>
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    Param(
        [Parameter(Mandatory, Position=0, ValueFromPipeline=$True)]
        [PSTypeName('PSCodeHealth.Overall.HealthReport')]
        [PSCustomObject]$HealthReport
    )
    $HtmlTemplate = Get-Content -Path "$PSScriptRoot\..\..\Assets\HealthReportTemplate.html"

    $Placeholders = @{
        REPORT_TITLE = $HealthReport.ReportTitle
        ANALYZED_PATH = $HealthReport.AnalyzedPath
    }

    Foreach ( $Placeholder in $Placeholders.GetEnumerator() ) {
        $HtmlTemplate = $HtmlTemplate.ForEach('Replace',"{$($Placeholder.Key)}",$Placeholder.Value)
    }
    $HtmlTemplate
}