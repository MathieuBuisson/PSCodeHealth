# This file stores variables which are used by the build script

# Storing all values in a single $Settings variable to make it obvious that the values are coming from this BuildSettings file when accessing them.
$Settings = @{

    BuildOutput = "$PSScriptRoot\BuildOutput"
    Dependency = @('Coveralls','Pester','PsScriptAnalyzer','platyPS')
    SourceFolder = "$PSScriptRoot\$($env:APPVEYOR_PROJECT_NAME)"
    TestUploadUrl = "https://ci.appveyor.com/api/testresults/nunit/$($env:APPVEYOR_JOB_ID)"
    CoverallsKey = $env:Coveralls_Key
    Branch = $env:APPVEYOR_REPO_BRANCH

    UnitTestParams = @{
        Script = '.\Tests\Unit'
        CodeCoverage = (Get-ChildItem -Path '.\PSCodeHealth\' -File -Filter "*.ps1" -Recurse).FullName | Where-Object { $_ -Match "Public|Private" }
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

    IsPullRequest = ($env:APPVEYOR_PULL_REQUEST_NUMBER -gt 0)
    Version = $env:APPVEYOR_BUILD_VERSION
    ManifestPath = '{0}\{1}\{1}.psd1' -f $PSScriptRoot, $env:APPVEYOR_PROJECT_NAME
    VersionRegex = "ModuleVersion\s=\s'(?<ModuleVersion>\S+)'" -as [regex]

    ModuleName = $env:APPVEYOR_PROJECT_NAME
    HeaderPath = "$PSScriptRoot\header-mkdocs.yml"
    MkdocsPath = "$PSScriptRoot\mkdocs.yml"
    PublicFunctionDocsPath = "$PSScriptRoot\docs\PublicFunctions"
    PlatyPSParams = @{
        Module = $env:APPVEYOR_PROJECT_NAME        
        OutputFolder = "$PSScriptRoot\docs\PublicFunctions"
        NoMetadata = $True
        Force = $True
    }
    PrivateFunctionDocsPath = "$PSScriptRoot\docs\InternalFunctions"
    InternalDocsPlatyPSParams =  @{
        OutputFolder          = "$PSScriptRoot\docs\InternalFunctions"
        WarningAction         = 'SilentlyContinue'
        Force                 = $True
    }
    FunctionsToExclude = @('Write-VerboseOutput','Get-SwitchCombination')

    GitHubKey = $env:GitHub_Key
    Email = 'MathieuBuisson@users.noreply.github.com'
    Name = 'Mathieu Buisson'
}