# Measure-FunctionMaxNestingDepth

## SYNOPSIS
Gets the depth of the most deeply nested statement in the function.

## SYNTAX

```
Measure-FunctionMaxNestingDepth [-FunctionDefinition] <FunctionDefinitionAst> [<CommonParameters>]
```

## DESCRIPTION
Gets the depth of the most deeply nested statement in the function.
Measuring the maximum nesting depth in a function is a way of evaluating its complexity.

## EXAMPLES

### EXAMPLE 1
```
Measure-FunctionMaxNestingDepth -FunctionDefinition $MyFunctionAst
```

Gets the depth of the most deeply nested statement in the specified function definition.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Int32

## NOTES

## RELATED LINKS

[Additional information on why maximum nesting depth is an interesting measure of code complexity :
https://www.cqse.eu/en/blog/mccabe-cyclomatic-complexity/]()

