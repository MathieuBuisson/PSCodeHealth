# This file stores variables which are used by the build script

# Storing all values in a single $Settings variable to make it obvious that the values are coming from this BuildSettings file when accessing them.
$Settings = @{
    
    BuildOutput = "$PSScriptRoot\BuildOutput"
    Dependency = @('Coveralls','Pester','PsScriptAnalyzer')
    SourceFolder = "$PSScriptRoot\$($env:APPVEYOR_PROJECT_NAME)"
    TestUploadUrl = "https://ci.appveyor.com/api/testresults/nunit/$($env:APPVEYOR_JOB_ID)"
    CoverallsKey = $env:Coveralls_Key
    Branch = $env:APPVEYOR_REPO_BRANCH

    UnitTestParams = @{
        Script = '.\Tests\Unit'
        CodeCoverage = '.\PSCodeHealth\P*\*'
        OutputFile = "$PSScriptRoot\BuildOutput\UnitTestsResult.xml"
        PassThru = $True
    }

    IntegrationTestParams = @{
        Script = '.\Tests\Integration'
        OutputFile = "$PSScriptRoot\BuildOutput\IntegrationTestsResult.xml"
        PassThru = $True
    }

    AnalyzeParams = @{
        Path = "$PSScriptRoot\$($env:APPVEYOR_PROJECT_NAME)"
        Severity = 'Error'
        Recurse = $True
    }
}