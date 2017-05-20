#Import everything from Coveralls.ps1, allows for easier pester tests with code coverage.
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$here\Coveralls.ps1"