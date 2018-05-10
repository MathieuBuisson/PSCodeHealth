# Get-FunctionDefinition

## SYNOPSIS
Gets all the function definitions in the specified files.

## SYNTAX

```
Get-FunctionDefinition [-Path] <String[]> [<CommonParameters>]
```

## DESCRIPTION
Gets all the function definitions (including private functions but excluding nested functions) in the specified PowerShell file.

## EXAMPLES

### EXAMPLE 1
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Management.Automation.Language.FunctionDefinitionAst

## NOTES

## RELATED LINKS
