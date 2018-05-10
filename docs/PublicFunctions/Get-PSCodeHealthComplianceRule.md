# Get-PSCodeHealthComplianceRule

## SYNOPSIS
Get the PSCodeHealth compliance rules (metrics thresholds, etc...) which are currently in effect.

## SYNTAX

```
Get-PSCodeHealthComplianceRule [[-CustomSettingsPath] <String>] [[-SettingsGroup] <String>]
 [[-MetricName] <String[]>] [<CommonParameters>]
```

## DESCRIPTION
Get the PSCodeHealth compliance rules (metrics warning and fail thresholds, etc...) which are currently in effect.
 
By default, all the compliance rules are coming from the file PSCodeHealthSettings.json in the module root.
 

Custom compliance rules can be specified in JSON format in a file, via the parameter CustomSettingsPath.
 
In this case, any compliance rules specified in the custom settings file override the default, and rules not specified in the custom settings file will use the defaults from PSCodeHealthSettings.json.
 

By default, this function outputs compliance rules for every metrics in every settings groups, but this can filtered via the MetricName and the SettingsGroup parameters.

## EXAMPLES

### EXAMPLE 1
```
Get-PSCodeHealthComplianceRule
```

Gets all the default PSCodeHealth compliance rules (metrics warning and fail thresholds, etc...).

### EXAMPLE 2
```
Get-PSCodeHealthComplianceRule -CustomSettingsPath .\MySettings.json -SettingsGroup OverallMetrics
```

Gets all PSCodeHealth compliance rules (metrics warning and fail thresholds, etc...) in effect in the group 'OverallMetrics'.
 
This also output any compliance rule overriding the defaults because they are specified in the file MySettings.json.

### EXAMPLE 3
```
Get-PSCodeHealthComplianceRule -MetricName 'TestCoverage','Complexity','MaximumNestingDepth'
```

Gets the default compliance rules in effect for the TestCoverage, Complexity and MaximumNestingDepth metrics.
 
In the case of TestCoverage, this metric exists in both PerFunctionMetrics and OverallMetrics, so the TestCoverage compliance rules from both groups will be output.

## PARAMETERS

### -CustomSettingsPath
To specify the path of a file containing user-defined compliance rules (metrics thresholds, etc...) in JSON format.
 
Any compliance rule specified in this file override the default, and rules not specified in this file will use the default from PSCodeHealthSettings.json.

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
To filter the output compliance rules to only the ones located in the specified group.
 
There are 2 settings groups in PSCodeHealthSettings.json, so there are 2 possible values for this parameter : 'PerFunctionMetrics' and 'OverallMetrics'.
 
Metrics in the PerFunctionMetrics group are generated for each individual function and metrics in the OverallMetrics group are calculated for the entire file or folder specified in the 'Path' parameter of Invoke-PSCodeHealth.
 
If not specified, compliance rules from both groups are output.

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
To filter the output compliance rules to only the ones for the specified metric or metrics.
 
There is a large number of metrics, so for convenience, all the possible values are available via tab completion.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### PSCodeHealth.Compliance.Rule

## NOTES

## RELATED LINKS
