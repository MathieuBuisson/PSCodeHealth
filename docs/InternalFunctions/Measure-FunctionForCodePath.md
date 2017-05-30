# Measure-FunctionForCodePath

## SYNOPSIS
Gets the number of additional code paths due to For loops.

## SYNTAX

```
Measure-FunctionForCodePath [-FunctionDefinition] <FunctionDefinitionAst>
```

## DESCRIPTION
Gets the number of additional code paths due to For loops (where the For statement contains a condition), in the specified function definition.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Measure-FunctionForCodePath -FunctionDefinition $MyFunctionAst
```

Gets the number of additional code paths due to for loops in the specified function definition.

## PARAMETERS

### -FunctionDefinition
To specify the function definition to analyze.

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

## INPUTS

## OUTPUTS

### System.Int32

## NOTES

## RELATED LINKS

