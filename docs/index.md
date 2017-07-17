# PSCodeHealth  &nbsp; &nbsp; &nbsp;<img src= "https://github.com/MathieuBuisson/PSCodeHealth/raw/master/PSCodeHealth/Assets/PSCodeHealthLogo.png" alt="PSCodeHealth Logo" width="70" align="center"/>
  
  
## Overview  

> "**If you can't measure it, you can't improve it.**"  
Peter Drucker

PSCodeHealth allows you to measure the quality and maintainability of your PowerShell code, based on a variety of metrics related to :  
  - Code length  
  - Code complexity  
  - Code smells, styling issues and violations of best practices  
  - Tests and test coverage  
  - Comment-based help  

It can allow you to ensure that your code is compliant with metrics goals (quality gates). You can use the default (built-in) compliance rules, and you can also customize some (or all) compliance rules to fit your goals.  

These features can be leveraged from within you PowerShell release pipeline.  

PSCodeHealth can also generate a highly visual HTML report so that you can interpret the results at a glance, and easily share them.  
For example, here is what the **Summary** tab looks like :  
![HTML report - Summary section](https://raw.githubusercontent.com/MathieuBuisson/PSCodeHealth/master/Examples/SummarySectionScreenshot.png "HTML report - Summary section")  
&nbsp;  

And here is an example of what the **Style & Best Practices** tab looks like :  
![HTML report - Style & Best Practices section](https://raw.githubusercontent.com/MathieuBuisson/PSCodeHealth/master/Examples/BestPracticesSectionScreenshot.png "HTML report - Style & Best Practices section")  

## Requirements  

Before using PSCodeHealth, you need :  
  - PowerShell 5.x  
  - The **[Pester](https://github.com/pester/Pester)** PowerShell module (version 3.4.0 or later)  
  - The **[PSScriptAnalyzer](https://github.com/PowerShell/PSScriptAnalyzer)** PowerShell module  
  - Internet access when opening the HTML report (to download some CSS and Javascript for Bootstrap, jQuery and Chart.js)  
