# Measure-FunctionIfCodePath

## SYNOPSIS
Gets the number of additional code paths due to If statements.

## SYNTAX

```
Measure-FunctionIfCodePath [-FunctionDefinition] <FunctionDefinitionAst>
```

## DESCRIPTION
Gets the number of additional code paths due to If statements (including If/Else and If/ElseIf/Else statements), in the specified function definition.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Measure-FunctionIfCodePath -FunctionDefinition $MyFunctionAst
```

Gets the number of additional code paths due to If statements in the specified function definition.

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

