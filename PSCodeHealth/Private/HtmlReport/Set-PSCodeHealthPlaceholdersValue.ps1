Function Set-PSCodeHealthPlaceholdersValue {
<#
.SYNOPSIS
    Replaces Placeholders in template files with their specified value.  

.DESCRIPTION
    Replaces Placeholders in template files with their specified string value and outputs the new content with the replaced value.  

.PARAMETER TemplatePath
    Path of the template file containing placeholders to replace.  

.PARAMETER PlaceholdersData
    Hashtable with a key-value pair for each placeholder. The key is corresponds to the name of the placeholder to replace and the value corresponds to its string value.  

.EXAMPLE
    PS C:\> $PlaceholdersData = @{
        REPORT_TITLE = $HealthReport.ReportTitle
        ANALYZED_PATH = $HealthReport.AnalyzedPath
    }
    PS C:\> Set-PSCodeHealthPlaceholdersValue -TemplatePath '.\HealthReportTemplate.html' -PlaceholdersData $PlaceholdersData

    Returns the content of the template file with the placeholders 'REPORT_TITLE' and 'ANALYZED_PATH' substituted by the string values specified in the hashtable $PlaceholdersData.  

.OUTPUTS
    System.String

.NOTES    
#>
    [CmdletBinding()]
    [OutputType([string[]])]
    Param (
        [Parameter(Position=0, Mandatory)]
        [ValidateScript({ Test-Path $_ -PathType Leaf })]
        [string]$TemplatePath,

        [Parameter(Position=1, Mandatory)]
        [Hashtable]$PlaceholdersData
    )

    $TemplateContent = Get-Content -Path $TemplatePath

    Foreach ( $Placeholder in $PlaceholdersData.GetEnumerator() ) {
        $PlaceholderPattern = '{{{0}}}' -f $Placeholder.Key

        # Handling values containing a collection
        $PlaceholderValue = If ( $($Placeholder.Value).Count -gt 1 ) { $Placeholder.Value | Out-String } Else { $Placeholder.Value }
        $TemplateContent = $TemplateContent.ForEach('Replace', $PlaceholderPattern, $PlaceholderValue)
    }
    $TemplateContent
}