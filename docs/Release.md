# 2018-05-10  


## Getting the per-function test coverage information is much more efficient  

  - `Get-FunctionTestCoverage` will not run the whole tests suite for each function anymore.  
  - It runs only test script(s) referencing/running the currently evaluated function.  
