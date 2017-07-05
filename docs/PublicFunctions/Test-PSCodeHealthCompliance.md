# Test-PSCodeHealthCompliance

## SYNOPSIS
Gets the compliance result(s) of the analyzed PowerShell code, based on a PSCodeHealth report and compliance rules contained in PSCodeHealth settings.

## SYNTAX

```
Test-PSCodeHealthCompliance [-HealthReport] <PSObject> [[-CustomSettingsPath] <String>]
 [[-SettingsGroup] <String>] [[-MetricName] <String[]>] [-Summary]
```

## DESCRIPTION
Gets the compliance result(s) of the analyzed PowerShell code, based on a PSCodeHealth report and compliance rules contained in PSCodeHealth settings.
 
The values in the input PSCodeHealth report will be checked for compliance against the rules in the PSCodeHealth settings which are currently in effect.
 
By default, all compliance rules are coming from the file PSCodeHealthSettings.json in the module root.
Custom compliance rules can be specified in JSON format in a file, via the parameter CustomSettingsPath.
 

The possible compliance levels are :  
  - Pass  
  - Warning  
  - Fail  

By default, this function outputs the compliance results for every metrics in every settings groups, but this can filtered via the MetricName and the SettingsGroup parameters.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Test-PSCodeHealthCompliance -HealthReport $MyProjectHealthReport
```

Gets the compliance results for every metrics, based on the specified PSCodeHealth report ($MyProjectHealthReport) and the compliance rules in the default settings.

### -------------------------- EXAMPLE 2 --------------------------
```
Invoke-PSCodeHealth | Test-PSCodeHealthCompliance
```

Gets the compliance results for every metrics, based on the PSCodeHealth report specified via pipeline input and the compliance rules in the default settings.

### -------------------------- EXAMPLE 3 --------------------------
```
Test-PSCodeHealthCompliance -HealthReport $MyProjectHealthReport -CustomSettingsPath .\MySettings.json -SettingsGroup OverallMetrics
```

Evaluates the compliance results for the metrics in the settings group OverallMetrics, based on the specified PSCodeHealth report ($MyProjectHealthReport).
 
This checks compliance against compliance rules in the defaults compliance rules and any custom compliance rule from the file 'MySettings.json'.

### -------------------------- EXAMPLE 4 --------------------------
```
Test-PSCodeHealthCompliance -HealthReport $MyProjectHealthReport -MetricName 'TestCoverage','Complexity','MaximumNestingDepth'
```

Evaluates the compliance results only for the TestCoverage, Complexity and MaximumNestingDepth metrics.
 
In the case of TestCoverage, this metric exists in both PerFunctionMetrics and OverallMetrics, so this evaluates the compliance result for the TestCoverage metric from both groups.

### -------------------------- EXAMPLE 5 --------------------------
```
Test-PSCodeHealthCompliance -HealthReport $MyProjectHealthReport -FunctionName 'Get-Something'
```

Evaluates the compliance results specifically for the function Get-Something.
Because this is the compliance of a specific function, only the per function metrics are evaluated.
 
If the value of the FunctionName parameter doesn't match any function name in the HealthReport the parameter validation will fail and state the set of possible values.

### -------------------------- EXAMPLE 6 --------------------------
```
Invoke-PSCodeHealth | Test-PSCodeHealthCompliance -Summary
```

Evaluates the compliance results for every metrics, based on the PSCodeHealth report specified via pipeline input and the compliance rules in the default settings.
 
This outputs an overall 'Fail','Warning' or 'Pass' value for all the evaluated metrics.

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
To evaluate compliance only for the metrics located in the specified group.
 
There are 2 settings groups in PSCodeHealthSettings.json, so there are 2 possible values for this parameter : 'PerFunctionMetrics' and 'OverallMetrics'.
 
Metrics in the PerFunctionMetrics group are for each individual function and metrics in the OverallMetrics group are for the entire file or folder specified in the 'Path' parameter of Invoke-PSCodeHealth.
 
If not specified, compliance is evaluated for metrics in both groups.

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
To get compliance results only for the specified metric(s).
There is a large number of metrics, so for convenience, all the possible values are available via tab completion.
If not specified, compliance is evaluated for all metrics.

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

### -Summary
To output a single overall compliance result based on all the evaluated metrics.
 
This retains the worst compliance level, meaning :  
  - If any evaluated metric has the 'Fail' compliance level, the overall result is 'Fail'  
  - If any evaluated metric has the 'Warning' compliance level and none has 'Fail', the overall result is 'Warning'  
  - If all evaluated metrics has the 'Pass' compliance level, the overall result is 'Pass'

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

### PSCodeHealth.Compliance.Result, PSCodeHealth.Compliance.FunctionResult, System.String

## NOTES

## RELATED LINKS

