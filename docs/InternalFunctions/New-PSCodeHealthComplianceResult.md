---
external help file: 
online version: 
schema: 2.0.0
---

# New-PSCodeHealthComplianceResult

## SYNOPSIS
Creates a new custom object and gives it the TypeName : 'PSCodeHealth.Compliance.Result'.

## SYNTAX

```
New-PSCodeHealthComplianceResult [-ComplianceRule] <PSObject> [-Value] <PSObject> [-Result] <String>
```

## DESCRIPTION
Creates a new custom object based on a PSCodeHealth.Compliance.Rule object and a compliance result, and gives it the TypeName : 'PSCodeHealth.Compliance.Result'.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
New-PSCodeHealthComplianceResult -ComplianceRule $Rule -Value 81.26 -Result Warning
```

Returns new custom object of the type PSCodeHealth.Compliance.Result.

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

## INPUTS

## OUTPUTS

### PSCodeHealth.Compliance.Result

## NOTES

## RELATED LINKS

