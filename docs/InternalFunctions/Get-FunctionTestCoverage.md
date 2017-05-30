# Get-FunctionTestCoverage

## SYNOPSIS
Gets the percentage of lines of code in the specified function that are tested by unit tests.

## SYNTAX

```
Get-FunctionTestCoverage [-FunctionDefinition] <FunctionDefinitionAst> [[-TestsPath] <String>]
```

## DESCRIPTION
Gets the percentage of lines of code in the specified function definition that are tested (executed) by unit tests.
It uses Pester with its CodeCoverage parameter.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-FunctionTestCoverage -FunctionDefinition $MyFunctionAst -TestsPath $MyModule.ModuleBase
```

Gets the percentage of lines of code in the function $MyFunctionAst that are tested by all tests found in the module's parent directory.

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

### -TestsPath
To specify the file or directory where the Pester tests are located.
If a directory is specified, the directory and all subdirectories will be searched recursively for tests.
If not specified, the directory of the file containing the specified function, and all subdirectories will be searched for tests.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

### System.Double

## NOTES

## RELATED LINKS

