# Test-FunctionHelpCoverage

## SYNOPSIS
Tells whether or not the specified function definition contains help information.

## SYNTAX

```
Test-FunctionHelpCoverage [-FunctionDefinition] <FunctionDefinitionAst> [<CommonParameters>]
```

## DESCRIPTION
Tells whether or not the specified function definition specified as a \[System.Management.Automation.Language.FunctionDefinitionAst\] contains help information.
This function returns $True if the specified function definition AST has a CommentHelpInfo or if the function name is listed in an external help file.

## EXAMPLES

### EXAMPLE 1
```
Test-FunctionHelpCoverage -FunctionDefinition $MyFunctionAst
```

Returns $True if the specified function definition contains help information, returns $False if not.

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

### System.Boolean

## NOTES

## RELATED LINKS
