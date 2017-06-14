# Getting started  

To evaluate the code quality of a single script, simply use the **`Invoke-PSCodeHealth`** command.  
Specify the relative or full path of the script file via the `Path` parameter and specify the location of the tests via the `TestsPath` parameter, like so :  

```powershell
C:\> Invoke-PSCodeHealth -Path '.\coveralls\Coveralls.ps1' -TestsPath '.\coveralls'

Files    Functions      LOC (Average) Findings      Findings      Complexity    Test Coverage
                                      (Total)       (Average)     (Average)
-----    ---------      ------------- ------------- ------------- ------------- -------------  
1        9              22.33         0             0             2             21.88 %
```  

To evaluate the code quality of all the PowerShell code in a directory, specify the relative or full path of the directory via the `Path` parameter, like so :  

```powershell
C:\> Invoke-PSCodeHealth -Path '.\coveralls' -TestsPath '.\coveralls'

Files    Functions      LOC (Average) Findings      Findings      Complexity    Test Coverage
                                      (Total)       (Average)     (Average)
-----    ---------      ------------- ------------- ------------- ------------- -------------  
3        9              22.33         0             0             2             21.43 %

```  
## Viewing all the code metrics  

The above provides a simple table to view the most important metrics at a glance, but this is just the default view.  
To view all the metrics, you can pipe the output of **`Invoke-PSCodeHealth`** to **`Format-List`**, like so :  

```powershell
C:\> Invoke-PSCodeHealth -Path '.\coveralls' -TestsPath '.\coveralls' | Format-List

ReportTitle                   : coveralls
ReportDate                    : 2017-06-02 22:28:45Z
AnalyzedPath                  : C:\coveralls\
Files                         : 3
Functions                     : 9
LinesOfCodeTotal              : 201
LinesOfCodeAverage            : 22.33
ScriptAnalyzerFindingsTotal   : 0
ScriptAnalyzerErrors          : 0
ScriptAnalyzerWarnings        : 0
ScriptAnalyzerInformation     : 0
ScriptAnalyzerFindingsAverage : 0
FunctionsWithoutHelp          : 9
NumberOfTests                 : 10
NumberOfFailedTests           : 0
NumberOfPassedTests           : 10
TestsPassRate                 : 100
TestCoverage                  : 21.43
CommandsMissedTotal           : 77
ComplexityAverage             : 2
ComplexityHighest             : 5
NestingDepthAverage           : 1.11
NestingDepthHighest           : 3
FunctionHealthRecords         : {@{FunctionName=Add-CoverageInfo; FilePath=C:\coveralls\Coveralls.ps1; 
                                LinesOfCode=14; ScriptAnalyzerFindings=0; ScriptAnalyzerResultDetails=; 
                                ContainsHelp=False; TestCoverage=0; CommandsMissed=3; Complexity=1; 
                                MaximumNestingDepth=1}, @{FunctionName=Merge-CoverageResult; 
                                FilePath=C:\coveralls\Coveralls.ps1; LinesOfCode=21; 
                                ScriptAnalyzerFindings=0; ScriptAnalyzerResultDetails=; 
                                ContainsHelp=False; TestCoverage=0; CommandsMissed=6; Complexity=1; 
                                MaximumNestingDepth=0}, @{FunctionName=Get-CoverageArray; 
                                FilePath=C:\coveralls\Coveralls.ps1; LinesOfCode=30; 
                                ScriptAnalyzerFindings=0; ScriptAnalyzerResultDetails=; 
                                ContainsHelp=False; TestCoverage=0; CommandsMissed=18; Complexity=5; 
                                MaximumNestingDepth=3}, @{FunctionName=Format-FileCoverage; 
                                FilePath=C:\coveralls\Coveralls.ps1; LinesOfCode=24; 
                                ScriptAnalyzerFindings=0; ScriptAnalyzerResultDetails=; 
                                ContainsHelp=False; TestCoverage=100; CommandsMissed=0; Complexity=2; 
                                MaximumNestingDepth=1}...}  
```
## Viewing the per-function metrics  

To view the per-function information, access the `FunctionHealthRecords` property of the output of **`Invoke-PSCodeHealth`** :

```powershell
C:\> $HealthReport = Invoke-PSCodeHealth -Path '.\coveralls' -TestsPath '.\coveralls'
C:\> $HealthReport.FunctionHealthRecords

Function Name               Lines of Code  Complexity     Contains Help Test Coverage ScriptAnalyzer
                                                                                         Findings
-------------               -------------  ----------     ------------- ------------- -------------  
Add-CoverageInfo            14             1              False         0 %                 0
Merge-CoverageResult        21             1              False         0 %                 0
Get-CoverageArray           30             5              False         0 %                 0
Format-FileCoverage         24             2              False         100 %               0
Get-CommandsForFile         16             1              False         100 %               0
Get-GitInfo                 23             2              False         0 %                 0
Format-Coverage             39             3              False         0 %                 0
Publish-Coverage            18             1              False         0 %                 0
Get-CoveragePercentage      16             2              False         100 %               0

```
## Excluding files from the code analysis  

You may want to exclude some file(s) from the code analysis because they might not be relevant. You can do so with the `Exclude` parameter. The `Exclude` parameter can accept wildcards, for example :  

```powershell
C:\> Invoke-PSCodeHealth -Path '.\coveralls' -Exclude '*.psm1' -TestsPath '.\coveralls'

Files    Functions       LOC (Average)  Findings       Findings       Complexity     Test Coverage
                                        (Total)        (Average)      (Average)
-----    ---------       -------------  -------------- -------------- -------------- -------------
2        9               22.33          0              0              2              21.88 %  
```
