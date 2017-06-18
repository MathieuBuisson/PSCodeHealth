# New-PSCodeHealthReport

## SYNOPSIS
Creates a new custom object and gives it the TypeName : 'PSCodeHealth.Overall.HealthReport'.

## SYNTAX

```
New-PSCodeHealthReport [-ReportTitle] <String> [-AnalyzedPath] <String> [-Path] <String[]>
 [-FunctionHealthRecord] <PSObject[]> [-TestsPath] <String> [[-TestsResult] <PSObject>]
```

## DESCRIPTION
Creates a new custom object and gives it the TypeName : 'PSCodeHealth.Overall.HealthReport'.
This output object contains metrics for the code in all the PowerShell files specified via the Path parameter, uses the function health records specified via the FunctionHealthRecord parameter.
The value of the TestsPath parameter specifies the location of the tests when calling Pester to generate test coverage information.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
New-PSCodeHealthReport -ReportTitle 'MyTitle' -AnalyzedPath 'C:\Folder' -Path $MyPath -FunctionHealthRecord $FunctionHealthRecords -TestsPath "$MyPath\Tests"
```

Returns new custom object of the type PSCodeHealth.Overall.HealthReport, containing metrics for the code in all the PowerShell files in $MyPath, using the function health records in $FunctionHealthRecords and running all tests in "$MyPath\Tests" (and its subdirectories) to generate test coverage information.

## PARAMETERS

### -ReportTitle
To specify the title of the health report.
 
This is mainly used when generating an HTML report.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AnalyzedPath
To specify the code path being analyzed.
 
This corresponds to the original Path value of Invoke-PSCodeHealth.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path
To specify the path of one or more PowerShell file(s) to analyze.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: 

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FunctionHealthRecord
To specify the PSCodeHealth.Function.HealthRecord objects which will be the basis for the report.

```yaml
Type: PSObject[]
Parameter Sets: (All)
Aliases: 

Required: True
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TestsPath
To specify the file or directory where the Pester tests are located.
If a directory is specified, the directory and all subdirectories will be searched recursively for tests.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TestsResult
To use an existing Pester tests result object for generating the following metrics :  
  - NumberOfTests  
  - NumberOfFailedTests  
  - FailedTestsDetails  
  - NumberOfPassedTests  
  - TestsPassRate (%)  
  - TestCoverage (%)  
  - CommandsMissedTotal

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases: 

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

### PSCodeHealth.Overall.HealthReport

## NOTES

## RELATED LINKS

