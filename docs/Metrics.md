# Metrics collected by PSCodeHealth

## Metrics collected for each function

### LinesOfCode  
It measures the number of lines of code in the specified function definition.  
The single line comments, multiple lines comments and comment-based help are not executable code, so they are not counted.  

This metric should be kept as low as possible because lenghty functions tend to be difficult to read and maintain.  

#### Default thresholds : ([Source](http://www.ndepend.com/docs/code-metrics#NbLinesOfCode))  
  - Warning : greater or equal to 20  
  - Fail : greater or equal to 40  
           
### ScriptAnalyzerFindings  
It counts the total number of best practice violations found by [PSScriptAnalyzer](https://github.com/PowerShell/PSScriptAnalyzer) in the specified function definition, regardless of their severity.  

**PSScriptAnalyzer** is a static code checker for PowerShell. It checks readability, quality and security best practices in PowerShell code by running a set of rules. The rules are based on PowerShell best practices identified by PowerShell Team and the community.  

PSCodeHealth uses the default PSScriptAnalyzer rules.  

This metric should be kept as low as possible because high numbers of PSScriptAnlyzer findings generally reflects low code quality, maintainability or safety.  

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

Good tests provide confidence that the code behaves as expected. How confident depends mostly on the percentage of code which is covered by the tests. This is why code coverage of the tests is an important metric. It is an indicator of how thoroughly the different possible code paths and edge cases are tested.  

#### Default thresholds : ([Source](https://github.com/PowerShell/DscResources/blob/master/HighQualityModuleGuidelines.md))  
  - Warning : less than 80  
  - Fail : less than 70  

### Complexity  


#### Default thresholds : ([Source](http://www.ndepend.com/docs/code-metrics#CC))  
  - Warning : greater or equal to 15  
  - Fail : greater or equal to 30  

For more details on how the cyclomatic complexity is calculated, please refer to [this article](http://theshellnut.com/measuring-powershell-code-complexity-why-and-how/).

### MaximumNestingDepth  


#### Default thresholds : ([Source](http://www.ndepend.com/docs/code-metrics#ILNestingDepth))  
  - Warning : greater or equal to 4  
  - Fail : greater or equal to 8  

For more details on how the maximum nesting depth is calculated, please refer to [this article](http://theshellnut.com/measuring-powershell-code-complexity-why-and-how/).
