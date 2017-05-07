# Get-PSCodeHealthSetting

## SYNOPSIS
Get the PSCodeHealth settings (metrics thresholds, etc...) which are currently in effect.

## SYNTAX

```
Get-PSCodeHealthSetting [[-CustomSettingsPath] <String>] [[-SettingsGroup] <String>] [[-MetricName] <String>]
```

## DESCRIPTION
Get the PSCodeHealth settings (metrics thresholds, etc...) which are currently in effect.
 
By default, all the settings are coming from the file PSCodeHealthSettings.json in the module root.
 

Custom settings can be specified in JSON format in a file, via the parameter CustomSettingsPath.
 
In this case, any setting specified in the custom settings file override the default, and settings not specified in the custom settings file will use the defaults from PSCodeHealthSettings.json.

## EXAMPLES

### Example 1
```
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -CustomSettingsPath
To specify the path of a file containing user-defined settings (metrics thresholds, etc...) in JSON format.
 
Any setting specified in this file override the default, and settings not specified in this file will use the default from PSCodeHealthSettings.json.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SettingsGroup
To filter the output settings to only the settings located in the specified group.
 
There 2 settings group in PSCodeHealthSettings.json, so there are 2 possible values for this parameter : 'FunctionHealthRecordMetricsRules' and 'OverallHealthReportMetricsRules'.
 
If not specified, all the settings are output.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MetricName
{{Fill MetricName Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

### System.Management.Automation.PSCustomObject

## NOTES

## RELATED LINKS

