# Get-ExternalHelpCommand

## SYNOPSIS
Gets the name of the commands listed in external help files.

## SYNTAX

```
Get-ExternalHelpCommand [-Path] <String[]>
```

## DESCRIPTION
Gets the name of the commands listed in external (MAML-formatted) help files.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-ExternalHelpCommand -Path 'C:\GitRepos\MyModule'
```

Gets the name of all the commands listed in external help files found in the folder : C:\GitRepos\MyModule\.

## PARAMETERS

### -Path
Root directory where the function looks for external help files.
 
The function looks for files with a name ending with "-help.xml" in a "en-US" subdirectory.

```yaml
Type: String[]
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

## NOTES
https://info.sapien.com/index.php/scripting/scripting-help/writing-xml-help-for-advanced-functions

## RELATED LINKS

