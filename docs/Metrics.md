# Metrics collected by PSCodeHealth

## Metrics collected for each function

### LinesOfCode  
It measures the number of lines of code in the specified function definition.  
The single line comments, multiple lines comments and comment-based help are not executable code, so they are not counted.  

Lower is better, because lenghty functions tend to be difficult to read and maintain.  

#### Default thresholds : ([Source](http://www.ndepend.com/docs/code-metrics#NbLinesOfCode))  
The thresholds are 50% higher than the recommendations in the above article because PowerShell advanced functions tend have more boilerplate code than C# methods (mainly due to the various parameter attributes being more widely used in PowerShell, for validation purposes, pipeline input, etc...).  
  - Warning : greater or equal to 30  
  - Fail : greater or equal to 60  
           
### ScriptAnalyzerFindings  
It counts the total number of best practice violations found by [PSScriptAnalyzer](https://github.com/PowerShell/PSScriptAnalyzer) in the specified function definition, regardless of their severity.  

**PSScriptAnalyzer** is a static code checker for PowerShell. It checks readability, quality and security best practices in PowerShell code by running a set of rules. The rules are based on PowerShell best practices identified by PowerShell Team and the community.  

PSCodeHealth uses the default PSScriptAnalyzer rules.  

Lower is better, because high numbers of PSScriptAnlyzer findings generally reflects low code quality, maintainability or safety.  

#### Default thresholds :  
  - Warning : greater or equal to 7  
  - Fail : greater or equal to 12  
  
### ContainsHelp  
Tells whether or not the specified function definition contains comment-based help. Possible values are : True or False.  

It is an important best practice to have help information for each function, even private function (for contributors, or code reviewers).  
At the very least, it should have a short statement describing the function's purpose. That is the **Synopsis**.

### TestCoverage  
It measures the percentage of lines of code in the specified function definition that are exercised (executed) during a suite of tests.  
Note : the code **executed** during tests cannot always be considered as **tested**. It is only **tested** if it is executed **and** there is one or more test(s) specifically designed to validate that the code behaves as expected.  

Higher is better. Good tests provide confidence that the code behaves as expected. How confident depends mostly on the percentage of code which is covered by the tests. This is why code coverage of the tests is an important metric. It is an indicator of how thoroughly the different possible code paths and edge cases are tested.  

#### Default thresholds : ([Source](https://github.com/PowerShell/DscResources/blob/master/HighQualityModuleGuidelines.md))  
  - Warning : less than 80  
  - Fail : less than 70  

### Complexity  
This is the cyclomatic complexity of a given function. Cyclomatic complexity measures the number of possible execution paths through a given section of code. This is intended to evaluation code complexity.  

Lower is better, because complex code tends to have the following properties :  
  - Difficult to read/understand  
  - Difficult to test  
  - More prone to defects  
  - Make defects more difficult to identify
  - More difficult and risky to change/refactor/maintain  

#### Default thresholds : ([Source](http://www.ndepend.com/docs/code-metrics#CC))  
  - Warning : greater or equal to 15  
  - Fail : greater or equal to 30  

For more details on how the cyclomatic complexity is calculated, please refer to [this article](http://theshellnut.com/measuring-powershell-code-complexity-why-and-how/).

### MaximumNestingDepth  
This is the depth of the most deeply nested code in a given piece of code (a function, here). This measures a different aspect of complexity from the "cyclomatic complexity", so these 2 metrics are complementary. The nesting depth of a piece of code can measure the complexity of its context.  

Again, lower is better.  

#### Default thresholds : ([Source](http://www.ndepend.com/docs/code-metrics#ILNestingDepth))  
  - Warning : greater or equal to 4  
  - Fail : greater or equal to 8  

For more details on how the maximum nesting depth is calculated, please refer to [this article](http://theshellnut.com/measuring-powershell-code-complexity-why-and-how/).
  
## Metrics collected for the overall health report  

These are the overall metrics for all PowerShell code in the files or folder specified via the **Path** parameter.

### Files  
The number of PowerShell files. These are files with an extension like : '\*.ps\*1'.  
Test scripts are excluded, as are '\*.ps1xml' files because these don't contain any code.  

### Functions  
The overall number of function definitions found.  

### LinesOfCodeTotal  
The total number of lines of code across all files and functions.  

#### Default thresholds :  
  - Warning : greater or equal to 1000  
  - Fail : greater or equal to 2000  
  
### LinesOfCodeAverage  
The average number of lines of code per function.  

#### Default thresholds : ([Source](http://www.ndepend.com/docs/code-metrics#NbLinesOfCode))  
The thresholds are 50% higher than the recommendations in the above article because PowerShell advanced functions tend have more boilerplate code than C# methods (mainly due to the various parameter attributes being more widely used in PowerShell, for validation purposes, pipeline input, etc...).  
  - Warning : greater or equal to 30  
  - Fail : greater or equal to 60  
           
### ScriptAnalyzerFindingsTotal  
The total number of best practice violations found by [PSScriptAnalyzer](https://github.com/PowerShell/PSScriptAnalyzer) across all files.  

#### Default thresholds :  
  - Warning : greater or equal to 30  
  - Fail : greater or equal to 60  
           
### ScriptAnalyzerErrors  
The total number of best practice violations of 'Error' severity found by [PSScriptAnalyzer](https://github.com/PowerShell/PSScriptAnalyzer) across all files.  

#### Default thresholds :  
  - Warning : greater or equal to 1  
  - Fail : greater or equal to 3  
           
### ScriptAnalyzerWarnings  
The total number of best practice violations of 'Warning' severity found by [PSScriptAnalyzer](https://github.com/PowerShell/PSScriptAnalyzer) across all files. 

#### Default thresholds :  
  - Warning : greater or equal to 10  
  - Fail : greater or equal to 20  
           
### ScriptAnalyzerInformation  
The total number of best practice violations of 'Information' severity found by [PSScriptAnalyzer](https://github.com/PowerShell/PSScriptAnalyzer) across all files.  

#### Default thresholds :  
  - Warning : greater or equal to 20  
  - Fail : greater or equal to 40  
           
### ScriptAnalyzerFindingsAverage  
The average number of best practice violations found by [PSScriptAnalyzer](https://github.com/PowerShell/PSScriptAnalyzer) per function.

### NumberOfTests  
The total number of tests found by Pester.

### NumberOfFailedTests  
The total number of failed tests.  
Lower is better, 0 is highly recommended.  

### NumberOfPassedTests  
The total number of failed tests.  

### TestsPassRate  
The overall percentage of passing tests.  
The higher the better.  

### TestCoverage  
The overall percentage of code which is exercised across all PowerShell files by the tests.  
The higher the better.  

'CommandsMissedTotal'           
'ComplexityAverage'             
'NestingDepthAverage'           
'FunctionHealthRecords'         