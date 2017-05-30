---
external help file: 
online version: 
schema: 2.0.0
---

# Merge-PSCodeHealthSetting

## SYNOPSIS
Merges user-defined settings (metrics thresholds, etc...) into the default PSCodeHealth settings.

## SYNTAX

```
Merge-PSCodeHealthSetting [-DefaultSettings] <PSObject> [-CustomSettings] <PSObject>
```

## DESCRIPTION
Merges user-defined settings (metrics thresholds, etc...) into the default PSCodeHealth settings.
 
The default PSCodeHealth settings are stored in PSCodeHealthSettings.json, but user-defined custom settings can override these defaults.
 
The custom settings are stored in JSON format in a file (similar to PSCodeHealthSettings.json).
Any setting specified in the custom settings file override the default, and settings not specified in the custom settings file will use the defaults from PSCodeHealthSettings.json.

## EXAMPLES

### Example 1
```
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -DefaultSettings
PSCustomObject converted from the JSON data in PSCodeHealthSettings.json.

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

### -CustomSettings
PSCustomObject converted from the JSON data in a user-defined custom settings file.

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases: 

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

### System.Management.Automation.PSCustomObject

## NOTES

## RELATED LINKS

