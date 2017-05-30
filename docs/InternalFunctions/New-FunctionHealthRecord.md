---
external help file: 
online version: 
schema: 2.0.0
---

# New-FunctionHealthRecord

## SYNOPSIS
Creates a new custom object and gives it the TypeName : 'PSCodeHealth.Function.HealthRecord'.

## SYNTAX

```
New-FunctionHealthRecord [-FunctionDefinition] <FunctionDefinitionAst> [-FunctionTestCoverage] <Double>
```

## DESCRIPTION
Creates a new custom object and gives it the TypeName : 'PSCodeHealth.Function.HealthRecord'.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
New-FunctionHealthRecord -FunctionDefinition $MyFunctionAst -FunctionTestCoverage $TestCoverage
```

Returns new custom object of the type PSCodeHealth.Function.HealthRecord.

## PARAMETERS

### -FunctionDefinition
To specify the function definition.

```yaml
Type: FunctionDefinitionAst
Parameter Sets: (All)
Aliases: 

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FunctionTestCoverage
To specify the percentage of lines of code in the specified function that are tested by unit tests.

```yaml
Type: Double
Parameter Sets: (All)
Aliases: 

Required: True
Position: 2
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

### PSCodeHealth.Function.HealthRecord

## NOTES

## RELATED LINKS

