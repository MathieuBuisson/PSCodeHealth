# Get-FunctionScriptAnalyzerResult

## SYNOPSIS
Gets the best practices violations details in the specified function definition, using PSScriptAnalyzer.

## SYNTAX

```
Get-FunctionScriptAnalyzerResult [-FunctionDefinition] <FunctionDefinitionAst> [<CommonParameters>]
```

## DESCRIPTION
Gets the best practices violations details in the specified function definition specified as a \[System.Management.Automation.Language.FunctionDefinitionAst\].
It uses the PSScriptAnalyzer PowerShell module.

## EXAMPLES

### EXAMPLE 1
```
Get-FunctionScriptAnalyzerResult -FunctionDefinition $MyFunctionAst
```

Returns the best practices violations details (PSScriptAnalyzer results) in the specified function definition.

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

### Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord

## NOTES

## RELATED LINKS
