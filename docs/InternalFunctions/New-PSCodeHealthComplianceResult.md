# New-PSCodeHealthComplianceResult

## SYNOPSIS
Creates a new custom object and gives it the TypeName : 'PSCodeHealth.Compliance.Result'.

## SYNTAX

```
New-PSCodeHealthComplianceResult [-ComplianceRule] <PSObject> [-Value] <PSObject> [-Result] <String>
 [[-FunctionName] <String>] [<CommonParameters>]
```

## DESCRIPTION
Creates a new custom object based on a PSCodeHealth.Compliance.Rule object and a compliance result, and gives it the TypeName : 'PSCodeHealth.Compliance.Result'.

## EXAMPLES

### EXAMPLE 1
```
New-PSCodeHealthComplianceResult -ComplianceRule $Rule -Value 81.26 -Result Warning
```

Returns new custom object of the type PSCodeHealth.Compliance.Result.

### EXAMPLE 2
```
New-PSCodeHealthComplianceResult -ComplianceRule $Rule -Value 81.26 -Result Warning -FunctionName 'Get-Something'
```

Returns new custom object of the type PSCodeHealth.Compliance.FunctionResult for the function 'Get-Something'.

## PARAMETERS

### -ComplianceRule
The compliance rule which was evaluated.

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

### -Value
The value from the health report for the evaluated metric.

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

### -Result
The compliance result, based on the compliance rule and the actual value from the health report.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FunctionName
To get compliance results for a specific function.
 
If this parameter is specified, this creates a PSCodeHealth.Compliance.FunctionResult object, instead of PSCodeHealth.Compliance.Result.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### PSCodeHealth.Compliance.Result, PSCodeHealth.Compliance.FunctionResult

## NOTES

## RELATED LINKS
