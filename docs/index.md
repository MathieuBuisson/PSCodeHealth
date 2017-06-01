# PSCodeHealth  &nbsp; &nbsp; &nbsp;<img src= "https://github.com/MathieuBuisson/PSCodeHealth/raw/master/PSCodeHealth/Assets/PSCodeHealthLogo.png" alt="PSCodeHealth Logo" width="70" align="center"/>
  
  
## Overview  

> "**If you can't measure it, you can't improve it.**"  
Peter Drucker

PSCodeHealth allows you to measure the quality and maintainability of your PowerShell code, based on a variety of metrics related to :  
  - Length of functions  
  - Complexity of functions  
  - Code smells, styling issues and violations of best practices  
  - Tests and test coverage  
  - Comment-based help in functions  

It can allow you to ensure that your code is compliant with metrics goals (quality gates). You can use the default (built-in) compliance rules, and you can also customize some (or all) compliance rules to fit your goals.  

These features can be leveraged from within you PowerShell release pipeline.  

Want to know more ? Head to the full documentation :  
<http://pscodehealth.readthedocs.io/en/latest/>
## Requirements  

Before using PSCodeHealth, you need :  
  - PowerShell 5.x  
  - The **[Pester](https://github.com/pester/Pester)** PowerShell module (version 4.0.x or later)  
  - The **[PSScriptAnalyzer](https://github.com/PowerShell/PSScriptAnalyzer)** PowerShell module  
