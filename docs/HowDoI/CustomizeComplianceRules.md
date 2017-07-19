# Customizing PSCodeHealth's compliance rules according to your metrics goals  

As seen in the page [**Check if my code meets metrics goals**](http://pscodehealth.readthedocs.io/en/latest/HowDoI/CheckCodeCompliance/), **PSCodeHealth** comes with a set of default compliance rules which help determining if the analyzed code is doing well (or not so well) for any given metric.  

These default compliance rules are based on community consensus, thresholds from reference projects, or other code quality tools.  
But your requirements or metrics goals for different project(s) may differ from these defaults, so you may need to customize the warning/fail threshold for 1, some, or all metrics.  

As reminder, here is how to view all the default compliance rules :  

```powershell
PS C:\> Get-PSCodeHealthComplianceRule

Metric Name                   Metric Group       Warning Threshold Fail Threshold    Higher Is Better 
-----------                   ------------       ----------------- --------------    ---------------- 
LinesOfCode                   PerFunctionMetrics 30                60                False            
ScriptAnalyzerFindings        PerFunctionMetrics 7                 12                False            
TestCoverage                  PerFunctionMetrics 80                70                True             
CommandsMissed                PerFunctionMetrics 6                 12                False            
Complexity                    PerFunctionMetrics 15                30                False            
MaximumNestingDepth           PerFunctionMetrics 4                 8                 False            
LinesOfCodeTotal              OverallMetrics     1000              2000              False            
LinesOfCodeAverage            OverallMetrics     30                60                False            
ScriptAnalyzerFindingsTotal   OverallMetrics     30                60                False            
ScriptAnalyzerErrors          OverallMetrics     1                 3                 False            
ScriptAnalyzerWarnings        OverallMetrics     10                20                False            
ScriptAnalyzerInformation     OverallMetrics     20                40                False            
ScriptAnalyzerFindingsAverage OverallMetrics     7                 12                False            
NumberOfFailedTests           OverallMetrics     1                 3                 False            
TestsPassRate                 OverallMetrics     99                97                True             
TestCoverage                  OverallMetrics     80                70                True             
CommandsMissedTotal           OverallMetrics     200               400               False            
ComplexityAverage             OverallMetrics     15                30                False            
ComplexityHighest             OverallMetrics     30                60                False            
NestingDepthAverage           OverallMetrics     4                 8                 False            
NestingDepthHighest           OverallMetrics     8                 16                False            

```

## Defining custom compliance rules  

The default compliance rules built into **PSCodeHealth** are stored in the file **PSCodeHealthSettings.json** in the module root. To customize the thresholds for some metrics, it is strongly **NOT** recommended to modify this file, but to create a new JSON file containing the rules you need to override.  

For example, you may have a specific project which require `Switch` statements containing large numbers of clauses. This has a high impact on the **Complexity** metric, even though in this specific case, the code is still readable and fairly easy to maintain. In other words, the **Complexity** metric (based on Cyclomatic Complexity) doesn't properly reflect complexity for your particular project.  
So you decide to increase all the complexity-related thresholds by 10.  

To view the default compliance rules for all complexity-related metrics, run the following command :  

```powershell
PS C:\> Get-PSCodeHealthComplianceRule -MetricName Complexity,ComplexityAverage,ComplexityHighest

Metric Name                   Metric Group       Warning Threshold Fail Threshold    Higher Is Better 
-----------                   ------------       ----------------- --------------    ---------------- 
Complexity                    PerFunctionMetrics 15                30                False            
ComplexityAverage             OverallMetrics     15                30                False            
ComplexityHighest             OverallMetrics     30                60                False            

```

Open a new file in your editor of choice and enter a JSON object for each compliance rule you need to override. For our current example, the content of the file would be :  

```json
{
    "PerFunctionMetrics": [
        {
            "Complexity": {
                "WarningThreshold": 25,
                "FailThreshold": 40,
                "HigherIsBetter": false
            }
        }
    ],
    "OverallMetrics": [
        {
            "ComplexityAverage": {
                "WarningThreshold": 25,
                "FailThreshold": 40,
                "HigherIsBetter": false
            }
        },
        {
            "ComplexityHighest": {
                "WarningThreshold": 40,
                "FailThreshold": 70,
                "HigherIsBetter": false
            }
        }
    ]
}
```

Any metric not specified in this file will use the default compliance rule.  
Save this file with the '.json' extension, like `MyProjectSettings.json` to a location of your choice.  

## Viewing the compliance rules, including custom rules  

To view all the compliance rules which are currently in effect (including your custom compliance rules), run `Get-PSCodeHealthComplianceRule` with the `CustomSettingsPath` parameter to specify the path of the file containing your custom rules :  

```powershell
PS C:\> Get-PSCodeHealthComplianceRule -CustomSettingsPath .\MyProjectSettings.json

Metric Name                   Metric Group       Warning Threshold Fail Threshold    Higher Is Better 
-----------                   ------------       ----------------- --------------    ---------------- 
LinesOfCode                   PerFunctionMetrics 30                60                False            
ScriptAnalyzerFindings        PerFunctionMetrics 7                 12                False            
TestCoverage                  PerFunctionMetrics 80                70                True             
CommandsMissed                PerFunctionMetrics 6                 12                False            
Complexity                    PerFunctionMetrics 25                40                False            
MaximumNestingDepth           PerFunctionMetrics 4                 8                 False            
LinesOfCodeTotal              OverallMetrics     1000              2000              False            
LinesOfCodeAverage            OverallMetrics     30                60                False            
ScriptAnalyzerFindingsTotal   OverallMetrics     30                60                False            
ScriptAnalyzerErrors          OverallMetrics     1                 3                 False            
ScriptAnalyzerWarnings        OverallMetrics     10                20                False            
ScriptAnalyzerInformation     OverallMetrics     20                40                False            
ScriptAnalyzerFindingsAverage OverallMetrics     7                 12                False            
NumberOfFailedTests           OverallMetrics     1                 3                 False            
TestsPassRate                 OverallMetrics     99                97                True             
TestCoverage                  OverallMetrics     80                70                True             
CommandsMissedTotal           OverallMetrics     200               400               False            
ComplexityAverage             OverallMetrics     25                40                False            
ComplexityHighest             OverallMetrics     40                70                False            
NestingDepthAverage           OverallMetrics     4                 8                 False            
NestingDepthHighest           OverallMetrics     8                 16                False           

```

To verify that the complexity-related compliance rules are overidden by your custom rules, run the following :  

```powershell
PS C:\> $ComplexityMetrics = 'Complexity','ComplexityAverage','ComplexityHighest'

PS C:\> Get-PSCodeHealthComplianceRule -CustomSettingsPath .\MyProjectSettings.json -MetricName $ComplexityMetrics

Metric Name                   Metric Group       Warning Threshold Fail Threshold    Higher Is Better 
-----------                   ------------       ----------------- --------------    ---------------- 
Complexity                    PerFunctionMetrics 25                40                False            
ComplexityAverage             OverallMetrics     25                40                False            
ComplexityHighest             OverallMetrics     40                70                False            

```

## checking if your code meets your customized compliance rules  

Now, that you have compliance rules matching the metrics goals for your particular project/needs, you can use **PSCodeHealth** to verify how your PowerShell code is doing against these goals, like so :  

```powershell
PS C:\> $HealthReport = Invoke-PSCodeHealth .\coveralls .\coveralls

PS C:\> Test-PSCodeHealthCompliance -HealthReport $HealthReport -CustomSettingsPath .\MyProjectSettings.json

Metric Name                   Warning Threshold  Fail Threshold    Value             Result           
-----------                   -----------------  --------------    -----             ------           
LinesOfCode                   30                 60                39                Warning          
ScriptAnalyzerFindings        7                  12                2                 Pass             
TestCoverage                  80                 70                0                 Fail             
CommandsMissed                6                  12                20                Fail             
Complexity                    25                 40                41                Warning             
MaximumNestingDepth           4                  8                 3                 Pass             
LinesOfCodeTotal              1000               2000              204               Pass             
LinesOfCodeAverage            30                 60                22.67             Pass             
ScriptAnalyzerFindingsTotal   30                 60                4                 Pass             
ScriptAnalyzerErrors          1                  3                 1                 Pass             
ScriptAnalyzerWarnings        10                 20                3                 Pass             
ScriptAnalyzerInformation     20                 40                0                 Pass             
ScriptAnalyzerFindingsAverage 7                  12                0.44              Pass             
NumberOfFailedTests           1                  3                 2                 Warning          
TestsPassRate                 99                 97                84.62             Fail             
TestCoverage                  80                 70                39.6              Fail             
CommandsMissedTotal           200                400               61                Pass             
ComplexityAverage             25                 40                24                Pass             
ComplexityHighest             40                 70                41                Warning             
NestingDepthAverage           4                  8                 1.11              Pass             
NestingDepthHighest           8                  16                3                 Pass             

```

Looking at the "Warning Threshold" and "Fail Threshold" columns above, we can see that the complexity-related metrics get the custom thresholds defined in the file `MyProjectSettings.json`.  
Also, the compliance results for the complexity-related metrics are now based on the customized thresholds.  
For example, the average complexity value of 24, would be a **Warning** according to the default compliance rule for this metric, but it is now a **Pass**.  
