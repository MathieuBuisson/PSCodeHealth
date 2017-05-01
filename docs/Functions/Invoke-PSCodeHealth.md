# Invoke-PSCodeHealth

## SYNOPSIS
Gets quality and maintainability metrics for PowerShell code contained in scripts, modules or directories.

## SYNTAX

```
Invoke-PSCodeHealth [[-Path] <String>] [[-TestsPath] <String>] [-Recurse] [-Exclude <String[]>]
```

## DESCRIPTION
Gets quality and maintainability metrics for PowerShell code contained in scripts, modules or directories.
These metrics relate to :  
  - Length of functions  
  - Complexity of functions  
  - Code smells, styling issues and violations of best practices (using PSScriptAnalyzer)  
  - Tests and test coverage (using Pester to run tests)  
  - Comment-based help in functions

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Invoke-PSCodeHealth -Path 'C:\GitRepos\MyModule' -Recurse -TestsPath 'C:\GitRepos\MyModule\Tests\Unit'
```

Gets quality and maintainability metrics for code from PowerShell files in the directory C:\GitRepos\MyModule\ and any subdirectories.
 
This command will look for tests located in the directory C:\GitRepos\MyModule\Tests\Unit, and any subdirectories.

### -------------------------- EXAMPLE 2 --------------------------
```
Invoke-PSCodeHealth -Path 'C:\GitRepos\MyModule' -TestsPath 'C:\GitRepos\MyModule\Tests' -Recurse -Exclude "*example*"
```

Gets quality and maintainability metrics for code from PowerShell files in the directory C:\GitRepos\MyModule\ and any subdirectories, except for files containing "example" in their name.
 
This command will look for tests located in the directory C:\GitRepos\MyModule\Tests\, and any subdirectories.

## PARAMETERS

### -Path
To specify the path of the directory to search for PowerShell files to analyze.
 
If the Path is not specified and the current location is in a FileSystem PowerShell drive, this will default to the current directory.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -TestsPath
To specify the file or directory where tests are located.
 
If not specified, the command will look for tests in the same directory as each function.

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

### -Recurse
To search PowerShell files in the Path directory and all subdirectories recursively.

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
To specify file(s) to exclude from both the code analysis point of view and the test coverage point of view.
 
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

### PSCodeHealth.Overall.HealthReport

## NOTES

## RELATED LINKS

