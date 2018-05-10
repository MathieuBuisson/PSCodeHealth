# Measure-FunctionTrapCatchCodePath

## SYNOPSIS
Gets the number of additional code paths due to Trap statements and Catch clauses in Try statements.

## SYNTAX

```
Measure-FunctionTrapCatchCodePath [-FunctionDefinition] <FunctionDefinitionAst> [<CommonParameters>]
```

## DESCRIPTION
Gets the number of additional code paths due to Trap statements and Catch clauses in Try statements, in the specified function definition.

## EXAMPLES

### EXAMPLE 1
```
Measure-FunctionTrapCatchCodePath -FunctionDefinition $MyFunctionAst
```

Gets the number of additional code paths due to Trap statements and Catch clauses in Try statements, in the specified function definition.

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
