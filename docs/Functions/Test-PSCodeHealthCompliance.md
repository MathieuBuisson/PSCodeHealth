# Test-PSCodeHealthCompliance

## SYNOPSIS
Gets the compliance level(s) of the analyzed PowerShell code, based on a PSCodeHealth report and compliance rules contained in PSCodeHealth settings.

## SYNTAX

```
Test-PSCodeHealthCompliance [-HealthReport] <PSObject> [[-CustomSettingsPath] <String>]
 [[-SettingsGroup] <String>] [[-MetricName] <String[]>]
```

## DESCRIPTION
Gets the compliance level(s) of the analyzed PowerShell code, based on a PSCodeHealth report and compliance rules contained in PSCodeHealth settings.
 
The values in the input PSCodeHealth report will be checked for compliance against the rules in the PSCodeHealth settings which are currently in effect.
 
By default, all compliance rules are coming from the file PSCodeHealthSettings.json in the module root.
Custom compliance rules can be specified in JSON format in a file, via the parameter CustomSettingsPath.
 

The possible compliance levels are :  
  - Pass  
  - Warning  
  - Fail  

By default, this function outputs the compliance levels for every metrics in every settings groups, but this can filtered via the MetricName and the SettingsGroup parameters.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Test-PSCodeHealthCompliance -HealthReport $MyProjectHealthReport
```

Gets the compliance levels for every metrics, based on the specified PSCodeHealth report ($MyProjectHealthReport) and the compliance rules in the default settings.

### -------------------------- EXAMPLE 2 --------------------------
```
Invoke-PSCodeHealth | Test-PSCodeHealthCompliance
```

Gets the compliance levels for every metrics, based on the PSCodeHealth report specified via pipeline input and the compliance rules in the default settings.

### -------------------------- EXAMPLE 3 --------------------------
```
Test-PSCodeHealthCompliance -HealthReport $MyProjectHealthReport -CustomSettingsPath .\MySettings.json -SettingsGroup OverallMetrics
```

Gets the compliance levels for the metrics in the settings group OverallMetrics, based on the specified PSCodeHealth report ($MyProjectHealthReport).
 
This checks compliance against compliance rules in the defaults compliance rules and any custom compliance rule from the file 'MySettings.json'.

### -------------------------- EXAMPLE 4 --------------------------
```
Test-PSCodeHealthCompliance -HealthReport $MyProjectHealthReport -MetricName TestCoverage
```

Gets the compliance levels for the metric(s) named 'TestCoverage'.
In this case, this metric exists in both PerFunctionMetrics and OverallMetrics, so this will output the compliance level for the TestCoverage metric from both groups.

## PARAMETERS

### -HealthReport
The PSCodeHealth report (object of the type PSCodeHealth.Overall.HealthReport) to analyze for compliance.
 
The ouput of the command Invoke-PSCodeHealth is a PSCodeHealth report and can be bound to this parameter via pipeline input.

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases: 

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -CustomSettingsPath
To specify the path of a file containing user-defined compliance rules (metrics thresholds, etc...) in JSON format.
 
Any compliance rule specified in this file override the default, and rules not specified in this file will use the default from PSCodeHealthSettings.json.

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

### -SettingsGroup
To get compliance levels only for the metrics located in the specified group.
 
There are 2 settings groups in PSCodeHealthSettings.json, so there are 2 possible values for this parameter : 'PerFunctionMetrics' and 'OverallMetrics'.
 
Metrics in the PerFunctionMetrics group are for each individual function and metrics in the OverallMetrics group are for the entire file or folder specified in the 'Path' parameter of Invoke-PSCodeHealth.
 
If not specified, compliance levels for metrics in both groups are output.

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

### -MetricName
To get compliance levels only for the specified metric or metrics.
There is a large number of metrics, so for convenience, all the possible values are available via tab completion.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: 

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

### System.Management.Automation.PSCustomObject

## NOTES

## RELATED LINKS

