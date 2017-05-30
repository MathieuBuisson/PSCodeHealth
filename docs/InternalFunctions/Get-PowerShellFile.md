---
external help file: 
online version: 
schema: 2.0.0
---

# Get-PowerShellFile

## SYNOPSIS
Gets all PowerShell files in the specified directory.

## SYNTAX

```
Get-PowerShellFile [-Path] <String> [-Recurse] [-Exclude <String[]>]
```

## DESCRIPTION
Gets all PowerShell files (.ps1, .psm1 and .psd1) in the specified directory.
The following PowerShell-related files are excluded : Tests, format data files and type data files.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-PowerShellFile -Path C:\GitRepos\MyModule\ -Recurse
```

Gets all PowerShell files in the directory C:\GitRepos\MyModule\ and any subdirectories.

### -------------------------- EXAMPLE 2 --------------------------
```
Get-PowerShellFile -Path C:\GitRepos\MyModule\ -Recurse -Exclude "*example*"
```

Gets PowerShell files in the directory C:\GitRepos\MyModule\ and any subdirectories, except for files containing "example" in their name.

## PARAMETERS

### -Path
To specify the path of the directory to search.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Recurse
To search the Path directory and all subdirectories recursively.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Exclude
To specify file(s) to exclude.
The value of this parameter qualifies the Path parameter.
Enter a path element or pattern, such as *example*.
Wildcards are permitted.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

### System.String

## NOTES

## RELATED LINKS

