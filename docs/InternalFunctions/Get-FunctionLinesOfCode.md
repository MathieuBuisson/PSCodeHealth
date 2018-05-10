# Get-FunctionLinesOfCode

## SYNOPSIS
Gets the number of lines in the specified function definition (excluding comments).

## SYNTAX

```
Get-FunctionLinesOfCode [-FunctionDefinition] <FunctionDefinitionAst> [<CommonParameters>]
```

## DESCRIPTION
Gets the number of lines of code in the specified function definition specified as a \[System.Management.Automation.Language.FunctionDefinitionAst\].
The single line comments, multiple lines comments and comment-based help are not executable code, so they are excluded.

## EXAMPLES

### EXAMPLE 1
```
Get-FunctionLinesOfCode -FunctionDefinition $MyFunctionAst
```

Returns the number of lines of code in the specified function definition.

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
