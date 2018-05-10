# New-PSCodeHealthComplianceRule

## SYNOPSIS
Creates a new custom object and gives it the TypeName : 'PSCodeHealth.Compliance.Rule'.

## SYNTAX

```
New-PSCodeHealthComplianceRule [-MetricRule] <PSObject> [-SettingsGroup] <String> [<CommonParameters>]
```

## DESCRIPTION
Creates a new custom object and gives it the TypeName : 'PSCodeHealth.Compliance.Rule'.

## EXAMPLES

### EXAMPLE 1
```
New-PSCodeHealthComplianceRule -MetricRule $MetricRule -SettingsGroup PerFunctionMetrics
```

Returns new custom object of the type PSCodeHealth.Compliance.Rule.

## PARAMETERS

### -MetricRule
To specify the original metric rule object.

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

### -SettingsGroup
To specify from which settings group the current metric rule comes from.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
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
