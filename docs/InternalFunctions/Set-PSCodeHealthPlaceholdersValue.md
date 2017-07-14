# Set-PSCodeHealthPlaceholdersValue

## SYNOPSIS
Replaces Placeholders in template files with their specified value.

## SYNTAX

### File (Default)
```
Set-PSCodeHealthPlaceholdersValue [-TemplatePath] <String> [-PlaceholdersData] <Hashtable>
```

### Html
```
Set-PSCodeHealthPlaceholdersValue [-PlaceholdersData] <Hashtable> [-Html] <String[]>
```

## DESCRIPTION
Replaces Placeholders in template files with their specified string value and outputs the new content with the replaced value.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
$PlaceholdersData = @{
```

REPORT_TITLE = $HealthReport.ReportTitle
    ANALYZED_PATH = $HealthReport.AnalyzedPath
}
PS C:\\\> Set-PSCodeHealthPlaceholdersValue -TemplatePath '.\HealthReportTemplate.html' -PlaceholdersData $PlaceholdersData

Returns the content of the template file with the placeholders 'REPORT_TITLE' and 'ANALYZED_PATH' substituted by the string values specified in the hashtable $PlaceholdersData.

## PARAMETERS

### -TemplatePath
Path of the template file containing placeholders to replace.

```yaml
Type: String
Parameter Sets: File
Aliases: 

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PlaceholdersData
Hashtable with a key-value pair for each placeholder.
The key is corresponds to the name of the placeholder to replace and the value corresponds to its string value.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases: 

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Html
{{Fill Html Description}}

```yaml
Type: String[]
Parameter Sets: Html
Aliases: 

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

### System.String

## NOTES

## RELATED LINKS

