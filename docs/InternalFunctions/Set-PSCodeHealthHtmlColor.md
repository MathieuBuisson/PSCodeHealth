# Set-PSCodeHealthHtmlColor

## SYNOPSIS
Sets classes to the elements in the HTML report which use color coding to reflect their compliance, and returns the modified HTML.

## SYNTAX

```
Set-PSCodeHealthHtmlColor [-HealthReport] <PSObject> [-Compliance] <PSObject[]>
 [-PerFunctionCompliance] <PSObject[]> [-Html] <String[]>
```

## DESCRIPTION
Sets the class attribute to the elements in the HTML report which use color coding to reflect their compliance.
 
These classes corresponds to CSS declaration blocks to apply the appropriate styling to the elements, in particular the colors.
 
Then, it returns the modified HTML content to the caller.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Set-PSCodeHealthHtmlColor -HealthReport $HealthReport -Compliance $OverallCompliance -PerFunctionCompliance $PerFunctionCompliance -Html $HtmlContent
```

This sets classes to the elements in the HTML report which use color coding to reflect their compliance and returns the modified HTML content.

## PARAMETERS

### -HealthReport
To specify the input PSCodeHealth.Overall.HealthReport object containing the data.

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases: 

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Compliance
To input the overall compliance information, based on the current health report and the compliance rules.

```yaml
Type: PSObject[]
Parameter Sets: (All)
Aliases: 

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PerFunctionCompliance
To input the per-function compliance information, based on the functions in the current health report and the compliance rules.

```yaml
Type: PSObject[]
Parameter Sets: (All)
Aliases: 

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Html
To input the original HTML content (containing placeholders to be substituted with the appropriate class values).

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: 

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

### System.String

## NOTES

## RELATED LINKS

