# Using PSCodeHealth to check if your code meets metrics goals  

Running `Invoke-PSCodeHealth` provides quite a few metrics related to the quality and maintainability of your PowerShell code. That's nice, but what is more important is how you can use this information.  

**PSCodeHealth** comes with a set of default compliance rules for most of the code metrics it gathers. The purpose of these compliance rules is to help answer questions like :  
  - Which functions are nice and clean, and which ones are negatively impacting the overall quality and maintainability of my project ?  
  - Which aspect of quality or maintainability should I focus on to improve my code ? Complexity ? Test coverage ?  
  - The average complexity in my project is : 11. Is it bad, okay, or awesome ?

## Viewing all the compliance rules  

To view all the default compliance rules, simply run the following command :

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

For example, regarding the **TestCoverage** metric, the higher the value, the better it is. So below 70% is considered a "Fail", between 70% and 80% is a "Warning" and 80% or above is a "Pass".  

For a brief explanation of the metrics and how the thresholds are set (hint: not arbitrarily), please refer to the page [**Metrics collected by PSCodeHealth**](http://pscodehealth.readthedocs.io/en/latest/Metrics/).  

## Viewing the compliance rules in a specific metrics group  

There are 2 groups of metrics : **OverallMetrics** (aggregated for the whole health report) and **PerFunctionMetrics** (at the function level).  
To view only the compliance rules for per-function metrics, use the `SettingsGroup` parameter of `Get-PSCodeHealthComplianceRule`, like so :  

```powershell
PS C:\> Get-PSCodeHealthComplianceRule -SettingsGroup PerFunctionMetrics

Metric Name                   Metric Group       Warning Threshold Fail Threshold    Higher Is Better 
-----------                   ------------       ----------------- --------------    ---------------- 
LinesOfCode                   PerFunctionMetrics 30                60                False            
ScriptAnalyzerFindings        PerFunctionMetrics 7                 12                False            
TestCoverage                  PerFunctionMetrics 80                70                True             
CommandsMissed                PerFunctionMetrics 6                 12                False            
Complexity                    PerFunctionMetrics 15                30                False            
MaximumNestingDepth           PerFunctionMetrics 4                 8                 False           

```

## Viewing the compliance rules for 1 or more specific metric(s)  

In case you are only interested in 3 specific metrics, let's say NestingDepthAverage, NestingDepthHighest and TestCoverage, you can specify these metrics via the `MetricName` parameter :  

```powershell
PS C:\> Get-PSCodeHealthComplianceRule -MetricName NestingDepthAverage,NestingDepthHighest,TestCoverage

Metric Name                   Metric Group       Warning Threshold Fail Threshold    Higher Is Better 
-----------                   ------------       ----------------- --------------    ---------------- 
TestCoverage                  PerFunctionMetrics 80                70                True             
TestCoverage                  OverallMetrics     80                70                True             
NestingDepthAverage           OverallMetrics     4                 8                 False            
NestingDepthHighest           OverallMetrics     8                 16                False            
```

Have you noticed that this outputs 2 compliance rules for **TestCoverage** ?  
This is because this metric is measured at 2 different levels :  
  - Across the entire set of analyzed PowerShell files (in the OverallMetrics metrics group)  
  - At the function level (in the PerFunctionMetrics metrics group)  

Also, you don't have to memorize and type all the metric names, they are discoverable via tab-completion.

## Checking some PowerShell code against all compliance rules  

The cmdlet which brings together the values in a code health report and the compliance rules is `Test-PSCodeHealthCompliance`.  
This cmdlet output objects of the type `PSCodeHealth.Compliance.Result` and the most important piece of information is in their **Result** property.  
This **Result** property contains a string, and its possible values are :  
  - Fail  
  - Warning  
  - Pass  

Here is the simplest way of using `Test-PSCodeHealthCompliance` :  

```powershell
PS C:\> $HealthReport = ipch C:\coveralls C:\coveralls

PS C:\> Test-PSCodeHealthCompliance -HealthReport $HealthReport

Metric Name                   Warning Threshold  Fail Threshold    Value             Result           
-----------                   -----------------  --------------    -----             ------           
LinesOfCode                   30                 60                39                Warning          
ScriptAnalyzerFindings        7                  12                2                 Pass             
TestCoverage                  80                 70                0                 Fail             
CommandsMissed                6                  12                20                Fail             
Complexity                    15                 30                5                 Pass             
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
ComplexityAverage             15                 30                2                 Pass             
ComplexityHighest             30                 60                5                 Pass             
NestingDepthAverage           4                  8                 1.11              Pass             
NestingDepthHighest           8                  16                3                 Pass            

```

**Note :** `ipch` is an alias for `Invoke-PSCodeHealth`.  
An existing code health report needs to be input, so the `HealthReport` parameter is mandatory.  

**Note :** `Test-PSCodeHealthCompliance` outputs a single compliance result for each per-function metric, even if there are multiple functions in the input health report. This is because, for a given per-function metric, the retained value will be the worst value of all functions.  
So, for a metric where "Higher Is Better", the retained value is the value from the function which has the lowest value. This retained value is the single value that is compared with the warning threshold and fail threshold for this particular metric to determine the compliance result.  

Also, if you use `Invoke-PSCodeHealth` to generate an HTML report, many HTML elements are styled (colored) according to their compliance result.  

## Checking some PowerShell code against specific compliance rules  

Just like for `Get-PSCodeHealthComplianceRule`, `Test-PSCodeHealthCompliance` has the `SettingsGroup` and `MetricName` parameters, which can be used to filter compliance results.  
The `SettingsGroup` parameter filters the compliance results for a specific group of metrics (OverallMetrics or PerFunctionMetrics).  
The `MetricName` parameter filters the compliance results for 1 or more metric(s).  
They can even be used in combination :  

```powershell
PS C:\> Test-PSCodeHealthCompliance $HealthReport -SettingsGroup OverallMetrics -MetricName TestCoverage

Metric Name                   Warning Threshold  Fail Threshold    Value             Result           
-----------                   -----------------  --------------    -----             ------           
TestCoverage                  80                 70                39.6              Fail             

```

The above tells us that it would be a good idea to spend some time on improving the code coverage of the tests in this project.  
Also, the value 39.6% is below the generally accepted targets by a large margin, so this is likely a low hanging fruit : we could probably improve significantly this metric without a huge amount of effort.  
