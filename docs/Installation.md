## Installation  

The easiest and preferred way to install PSCodeHealth is via the [PowerShell Gallery](https://www.powershellgallery.com/). For more information, see the [PowerShell Gallery Getting Started](https://msdn.microsoft.com/en-us/powershell/gallery/psgallery/psgallery_gettingstarted) page.  

Run the following command to install PSCodeHealth and its 2 dependencies ([Pester](https://github.com/pester/Pester) and
[PSScriptAnalyzer](https://github.com/PowerShell/PSScriptAnalyzer)) :  

```powershell
Install-Module -Name PSCodeHealth -Repository PSGallery
```
  
As an alternative, you can clone this repository to a location on your system and copy the `PSCodeHealth` subfolder into :
`C:\Program Files\WindowsPowerShell\Modules\`.  

