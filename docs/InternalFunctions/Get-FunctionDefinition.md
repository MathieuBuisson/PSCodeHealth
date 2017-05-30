---
external help file: 
online version: 
schema: 2.0.0
---

# Get-FunctionDefinition

## SYNOPSIS
Gets all the function definitions in the specified files.

## SYNTAX

```
Get-FunctionDefinition [-Path] <String[]>
```

## DESCRIPTION
Gets all the function definitions (including private functions but excluding nested functions) in the specified PowerShell file.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-FunctionDefinition -Path C:\GitRepos\MyModule\MyModule.psd1
```

Gets all function definitions in the module specified by its manifest, as FunctionDefinitionAst objects.

## PARAMETERS

### -Path
To specify the path of the file to analyze.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: 

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

### System.Management.Automation.Language.FunctionDefinitionAst

## NOTES

## RELATED LINKS

