# PSCodeHealth  &nbsp; &nbsp; &nbsp;<img src= "https://github.com/MathieuBuisson/PSCodeHealth/raw/master/PSCodeHealth/Assets/PSCodeHealthLogo.png" alt="PSCodeHealth Logo" width="70" align="center"/>
  
  
[![Build status](https://ci.appveyor.com/api/projects/status/7lns5hedci8hfjm3/branch/master?svg=true)](https://ci.appveyor.com/project/MathieuBuisson/pscodehealth/branch/master) [![Coverage Status](https://coveralls.io/repos/github/MathieuBuisson/PSCodeHealth/badge.svg?branch=master)](https://coveralls.io/github/MathieuBuisson/PSCodeHealth?branch=master) [![Documentation Status](https://img.shields.io/badge/docs-latest-brightgreen.svg?style=flat)](http://pscodehealth.readthedocs.io/en/latest/?badge=latest)  

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

These features can be leveraged from within your PowerShell release pipeline.  

Want to know more ? Head to the full documentation :  
<http://pscodehealth.readthedocs.io/en/latest/>
## Requirements  

Before using PSCodeHealth, you need :  
  - PowerShell 5.x  
  - The **[Pester](https://github.com/pester/Pester)** PowerShell module (version 4.0.x or later)  
  - The **[PSScriptAnalyzer](https://github.com/PowerShell/PSScriptAnalyzer)** PowerShell module  

## Installation  

The easiest and preferred way to install PSCodeHealth is via the [PowerShell Gallery](https://www.powershellgallery.com/). For more information, see the [PowerShell Gallery Getting Started](https://msdn.microsoft.com/en-us/powershell/gallery/psgallery/psgallery_gettingstarted) page.  

Run the following command to install PSCodeHealth and the 2 dependencies ([Pester](https://github.com/pester/Pester) and
[PSScriptAnalyzer](https://github.com/PowerShell/PSScriptAnalyzer)) :  

```powershell
Install-Module -Name PSCodeHealth -Repository PSGallery
```
  
As an alternative, you can clone this repository to a location on your system and copy the `PSCodeHealth` subfolder into :
`C:\Program Files\WindowsPowerShell\Modules\`.  

## Contributing to PSCodeHealth

You are welcome to contribute to this project. There are many ways you can contribute :

1. Submit [issues](https://github.com/MathieuBuisson/PSCodeHealth/issues). In this case, please use the project's [issue template](https://github.com/MathieuBuisson/PSCodeHealth/blob/master/.github/ISSUE_TEMPLATE.md).  
2. Submit a fix for an issue.  
3. Submit a feature request.  
4. Submit test cases.  
5. Tell others about the project.  
6. Tell the developers how much you appreciate the project !  

For more information on how to contribute to PSCodeHealth, please refer to the [contributing guidelines](https://github.com/MathieuBuisson/PSCodeHealth/blob/master/.github/CONTRIBUTING.md) document.  
