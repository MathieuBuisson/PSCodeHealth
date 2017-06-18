# New-FailedTestsInfo

## SYNOPSIS
Creates one or more custom objects of the type : 'PSCodeHealth.Overall.FailedTestsInfo'.

## SYNTAX

```
New-FailedTestsInfo [-TestsResult] <PSObject>
```

## DESCRIPTION
Creates one or more custom objects of the type : 'PSCodeHealth.Overall.FailedTestsInfo'.
 
This outputs an object containing key information about each failed test.
This information is used in the overall health report.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
New-FailedTestsInfo -TestsResult $TestsResult
```

Returns a new custom object of the type 'PSCodeHealth.Overall.FailedTestsInfo' for each failed test in the input $TestsResult.

## PARAMETERS

### -TestsResult
To specify the Pester tests result object.

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

## INPUTS

## OUTPUTS

### PSCodeHealth.Overall.FailedTestsInfo

## NOTES

## RELATED LINKS

