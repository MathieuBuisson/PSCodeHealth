---
external help file: 
online version: 
schema: 2.0.0
---

# Measure-FunctionComplexity

## SYNOPSIS
Measures the code complexity.

## SYNTAX

```
Measure-FunctionComplexity [-FunctionDefinition] <FunctionDefinitionAst>
```

## DESCRIPTION
Measures the code complexity, in the specified function definition.
This complexity is measured according to the Cyclomatic complexity.
Cyclomatic complexity counts the number of possible paths through a given section of code.
The number of possible paths depends on the number of conditional logic constructs, because conditional logic constructs are where the flow of execution branches out to one or more different path(s).

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Measure-FunctionComplexity -FunctionDefinition $MyFunctionAst
```

Gets the number of additional code paths due to While statements in the specified function definition.

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
For more information on Cyclomatic complexity, please refer to the following article
https://en.wikipedia.org/wiki/Cyclomatic_complexity

A simple example of measuring the Cyclomatic complexity of a piece od code can be found here :
https://www.tutorialspoint.com/software_testing_dictionary/cyclomatic_complexity.htm

## RELATED LINKS

