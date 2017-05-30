---
external help file: 
online version: 
schema: 2.0.0
---

# Get-FunctionScriptAnalyzerResult

## SYNOPSIS
Gets the best practices violations details in the specified function definition, using PSScriptAnalyzer.

## SYNTAX

```
Get-FunctionScriptAnalyzerResult [-FunctionDefinition] <FunctionDefinitionAst>
```

## DESCRIPTION
Gets the best practices violations details in the specified function definition specified as a \[System.Management.Automation.Language.FunctionDefinitionAst\].
It uses the PSScriptAnalyzer PowerShell module.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
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

## INPUTS

## OUTPUTS

### Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord

## NOTES

## RELATED LINKS

