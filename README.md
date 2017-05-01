# PSCodeHealth  &nbsp; &nbsp; &nbsp;<img src= "https://github.com/MathieuBuisson/PSCodeHealth/raw/master/PSCodeHealth/Assets/PSCodeHealthLogo.png" alt="PSCodeHealth Logo" width="70" align="center"/>
  
  
[![Build status](https://ci.appveyor.com/api/projects/status/7lns5hedci8hfjm3/branch/master?svg=true)](https://ci.appveyor.com/project/MathieuBuisson/pscodehealth/branch/master) [![Coverage Status](https://coveralls.io/repos/github/MathieuBuisson/PSCodeHealth/badge.svg?branch=master)](https://coveralls.io/github/MathieuBuisson/PSCodeHealth?branch=master) [![Documentation Status](https://readthedocs.org/projects/pscodehealth/badge/?version=latest)](http://pscodehealth.readthedocs.io/en/latest/?badge=latest)  

PowerShell module which generates (and reports on) quality and maintainability metrics for PowerShell code contained in scripts, modules or directories.  
These metrics relate to :  
  - Length of functions  
  - Complexity of functions  
  - Code smells, styling issues and violations of best practices (using PSScriptAnalyzer)  
  - Tests and test coverage (using Pester to run tests)  
  - Comment-based help in functions  
