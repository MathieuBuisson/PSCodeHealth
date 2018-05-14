# PSCodeHealth  &nbsp; &nbsp; &nbsp;<img src= "https://github.com/MathieuBuisson/PSCodeHealth/raw/master/PSCodeHealth/Assets/PSCodeHealthLogo.png" alt="PSCodeHealth Logo" width="70" align="center"/>
  
  
[![Build status](https://ci.appveyor.com/api/projects/status/7lns5hedci8hfjm3/branch/master?svg=true)](https://ci.appveyor.com/project/MathieuBuisson/pscodehealth/branch/master) [![Coverage Status](https://coveralls.io/repos/github/MathieuBuisson/PSCodeHealth/badge.svg?branch=master)](https://coveralls.io/github/MathieuBuisson/PSCodeHealth?branch=master) [![Documentation Status](https://img.shields.io/badge/docs-latest-brightgreen.svg?style=flat)](http://pscodehealth.readthedocs.io/en/latest/?badge=latest) [![PS Gallery](https://img.shields.io/badge/install-PS%20Gallery-blue.svg)](https://www.powershellgallery.com/packages/PSCodeHealth/)  

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

## Installation  

The easiest and preferred way to install PSCodeHealth is via the [PowerShell Gallery](https://www.powershellgallery.com/). For more information, see the [PowerShell Gallery Getting Started](https://msdn.microsoft.com/en-us/powershell/gallery/psgallery/psgallery_gettingstarted) page.  

Run the following command to install PSCodeHealth and its 2 dependencies ([Pester](https://github.com/pester/Pester) and
[PSScriptAnalyzer](https://github.com/PowerShell/PSScriptAnalyzer)) :  

```powershell
Install-Module -Name PSCodeHealth -Repository PSGallery
```

If you prefer to manage PSCodeHealth as a Windows package, you can use Chocolatey. If you don't have Chocolatey, you can install it from the [Chocolately Install](https://chocolatey.org/install) page. With Chocolatey installed, execute the following command to install:

```powershell
choco install pscodehealth
```

As an alternative, you can clone this repository to a location on your system and copy the `PSCodeHealth` subfolder into :
`C:\Program Files\WindowsPowerShell\Modules\`.  

## Getting Started  

To evaluate the code quality of a single script, simply use the **`Invoke-PSCodeHealth`** command.  
Specify the relative or full path of the script file via the `Path` parameter and specify the location of the tests via the `TestsPath` parameter, like so :  

```powershell
PS C:\> Invoke-PSCodeHealth -Path '.\coveralls\Coveralls.ps1' -TestsPath '.\coveralls'

Files    Functions      LOC (Average)  Findings       Findings       Complexity    Test Coverage
                                       (Total)        (Average)      (Average)                  
-----    ---------      -------------  -------------- -------------- ------------- -------------
1        9              22.33          0              0              2             39.58 %      

```  

To evaluate the code quality of all the PowerShell code in a directory, specify the relative or full path of the directory via the `Path` parameter, like so :  

```powershell
PS C:\> Invoke-PSCodeHealth -Path '.\coveralls' -TestsPath '.\coveralls'

Files    Functions      LOC (Average)  Findings       Findings       Complexity    Test Coverage
                                       (Total)        (Average)      (Average)                  
-----    ---------      -------------  -------------- -------------- ------------- -------------
3        9              22.33          0              0              2             38.78 %      

```  

To view the per-function information, access the `FunctionHealthRecords` property of the output of **`Invoke-PSCodeHealth`** :

```powershell
C:\> $HealthReport = Invoke-PSCodeHealth -Path '.\coveralls' -TestsPath '.\coveralls'
C:\> $HealthReport.FunctionHealthRecords

Function Name               Lines of Code   Complexity     Contains Help  Test Coverage  ScriptAnalyzer
                                                                                            Findings   
-------------               -------------   ----------     -------------  -------------  --------------
Add-CoverageInfo            14              1              False          0 %                  0       
Merge-CoverageResult        21              1              False          0 %                  0       
Get-CoverageArray           30              5              False          94.44 %              0       
Format-FileCoverage         24              2              False          100 %                0       
Get-CommandsForFile         16              1              False          100 %                0       
Get-GitInfo                 23              2              False          0 %                  0       
Format-Coverage             39              3              False          0 %                  0       
Publish-Coverage            18              1              False          0 %                  0       
Get-CoveragePercentage      16              2              False          100 %                0       

```

To output the PSCodeHealth report as an HTML file, use the `HtmlReportPath` parameter to specify the full path of the HTML file :

```powershell
C:\> Invoke-PSCodeHealth -Path '.\coveralls' -TestsPath '.\coveralls' -HtmlReportPath "$env:USERPROFILE\Desktop\Report.html"

```
  
The above command will not output anything to the PowerShell pipeline, unless you add the `PassThru` parameter.  

Want to know more ? Head to the full documentation :  
<http://pscodehealth.readthedocs.io/en/latest/>  

## Contributing to PSCodeHealth

You are welcome to contribute to this project. There are many ways you can contribute :

1. Submit [issues](https://github.com/MathieuBuisson/PSCodeHealth/issues). In this case, please use the project's [issue template](https://github.com/MathieuBuisson/PSCodeHealth/blob/master/.github/ISSUE_TEMPLATE.md).  
2. Submit a fix for an issue.  
3. Submit a feature request.  
4. Submit test cases.  
5. Tell others about the project.  
6. Tell the developers how much you appreciate the project !  

For more information on how to contribute to PSCodeHealth, please refer to the [contributing guidelines](https://github.com/MathieuBuisson/PSCodeHealth/blob/master/.github/CONTRIBUTING.md) document.  
