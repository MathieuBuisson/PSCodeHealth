$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")
. "$here\$sut"

Describe "Get-CoveragePercentage" {
    Context "Providing a correct return" {
        BeforeAll {
            $content = "{""created_at"":""2017-03-16T12:37:17Z"",""url"":null,""commit_message"":""Add fake data to CA_KEY when it's not present"",""branch"":""master"",""committer_name"":""Jan De Dobbeleer"",""committer_email"":""jan@gmail.com"",""commit_sha"":""ba5947862030d86208d0181189c160df04e5c309"",""repo_name"":""JanJoris/coveralls"",""badge_url"":""https://s3.amazonaws.com/assets.coveralls.io/badges/coveralls_13.svg"",""coverage_change"":0.0,""covered_percent"":%percentage%}"
        }
        It "has a coverage percentage of 13" {
            Mock Invoke-WebRequest { return @{ Content = $content.Replace('%percentage%', '13') }}
            Get-CoveragePercentage -RepositoryLink coveralls | Should Be 13
        }
        It "has a coverage percentage of 28" {
            Mock Invoke-WebRequest { return @{ Content = $content.Replace('%percentage%', '28') }}
            Get-CoveragePercentage -RepositoryLink coveralls | Should Be 28
        }
    }
    Context "Providing an exception return" {
        It "throws an error when providing bogus info" {
            { Get-CoveragePercentage -RepositoryLink coveralls -ErrorAction Stop } | Should Throw
        }
        It "throws an error when providing a non-existing repository" {
            { Get-CoveragePercentage -RepositoryLink https://coveralls.io/coveralls/coveralls -ErrorAction Stop } | Should Throw
        }
    }
    Context "Providing crappy data" {
        It "has no content object to parse" {
            Mock Invoke-WebRequest { return @{ NotContent = "I am so crappy" }}
            { Get-CoveragePercentage -RepositoryLink coveralls -ErrorAction Stop } | Should Throw
        }
    }
}

Describe "Get-CommandsForFile" {
    Context "Receiving proper input" {
        It "has 2 commands that match the file" {
            $commands = @(
                @{
                    File = "file.ps1"
                    Line = 1
                },
                @{
                    File = "file.ps1"
                    Line = 2
                },
                @{
                    File = "file2.ps1"
                    Line = 3
                }
            )            
            Mock Get-Item { return @{ FullName = 'file.ps1' }}
            $result = Get-CommandsForFile -Commands $commands -File 'file.ps1'
            $result.Count | Should be 2
        }
        It "has 0 commands that match the file" {
            $commands = @(
                @{
                    File = "file2.ps1"
                    Line = 1
                },
                @{
                    File = "file2.ps1"
                    Line = 2
                }
            )            
            Mock Get-Item { return @{ FullName = 'file.ps1' }}
            $result = Get-CommandsForFile -Commands $commands -File 'file.ps1'
            $result.Count | Should be 0
        }
    }
    Context "Receiving crappy input" {
        It "should not output any match" {
            $commands = @{
                Balony = "garbage"
                Ohn0 = 1324343
            }         
            Mock Get-Item { return @{ FullName = 'file.ps1' }}
            $result = Get-CommandsForFile -Commands $commands -File 'file.ps1'
            $result.Count | Should be 0
        }
    }
}

Describe "Format-FileCoverage" {
    Context "Receiving proper input" {
        It "outputs the expected information" {
            $expected = New-Object -TypeName PSObject -Property @{
                name = 'file.ps1'
                source_digest = '123456789'
                coverage = 'Test'
            }
            Mock Get-FileHash { return @{ Hash = '123456789' }}
            Mock Get-Item -ParameterFilter { $Path -eq 'RootFolder' } { @{ FullName = 'root' } }
            Mock Get-Item -ParameterFilter { $Path -eq 'File' } { @{ FullName = 'root\file.ps1' } }
            $result = Format-FileCoverage -CoverageArray 'Test' -File 'File' -RootFolder 'RootFolder'
            $result | Should MatchExactly $expected 
        }
        It "handles the paths without an issue" {
            $expected = New-Object -TypeName PSObject -Property @{
                name = 'file.ps1'
                source_digest = '123456789'
                coverage = 'Test'
            }
            Mock Get-FileHash { return @{ Hash = '123456789' }}
            Mock Get-Item -ParameterFilter { $Path -eq 'RootFolder' } { @{ FullName = 'root' } }
            Mock Get-Item -ParameterFilter { $Path -eq 'File' } { @{ FullName = 'file.ps1' } }
            $result = Format-FileCoverage -CoverageArray 'Test' -File 'File' -RootFolder 'RootFolder'
            $result | Should MatchExactly $expected 
        }
    }
}