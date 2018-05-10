# New-PSCodeHealthTableData

## SYNOPSIS
Generate table rows for the HTML report, based on the data contained in a PSCodeHealth.Overall.HealthReport object.

## SYNTAX

```
New-PSCodeHealthTableData [-HealthReport] <PSObject> [<CommonParameters>]
```

## DESCRIPTION
Generate table rows for the HTML report, based on the data contained in a PSCodeHealth.Overall.HealthReport object.
 
This provides the rows for the following tables :  
  - Best Practices (per function)  
  - Maintainability (per function)  
  - Failed Tests Details  
  - Test Coverage (per function)

## EXAMPLES

### EXAMPLE 1
```
New-PSCodeHealthTableData -HealthReport $HealthReport
```

This generates the rows for the tables Best Practices, Maintainability, Failed Tests Details and Test Coverage tables, based on the data in $HealthReport.

## PARAMETERS

### -HealthReport
To specify the input PSCodeHealth.Overall.HealthReport object containing the data.

```yaml
Type: PSObject
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

### PSCustomObject

## NOTES

## RELATED LINKS
