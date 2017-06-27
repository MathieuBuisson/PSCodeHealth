function Add-CoverageInfo {

    [CmdletBinding()]
    param
    (
        [parameter(Position=1)]
        $CoverageResultSet,
        [parameter(Mandatory = $true,Position=2)]
        $Value
    )

    foreach ($coverageResult in $CoverageResultSet) {
        $coverageResult | Add-Member -MemberType NoteProperty -Name CoverageResult -Value $Value        
    }
}

function Merge-CoverageResult {

    [CmdletBinding()]
    param
    (
        [parameter(Position=1)]
        $HitCommands,
        [parameter(Position=2)]
        $MissedCommands,
        [parameter(Mandatory = $true,Position=3)]
        $File
    )

    # check what has been analyzed and provide context
    Add-CoverageInfo -CoverageResultSet $HitCommands -Value 1
    Add-CoverageInfo -CoverageResultSet $MissedCommands -Value 0
    # add both arrays for easier enumeration
    $allCommandsArray = @();
    $allCommandsArray += $HitCommands
    $allCommandsArray += $MissedCommands
    return $allCommandsArray    
}

function Get-CoverageArray {

    [CmdletBinding()]
    param
    (
        [parameter(Mandatory = $true,Position=1)]
        $CoverageResultArray,
        [parameter(Mandatory = $true,Position=2)]
        $File
    )
    $SecurePassword = ConvertTo-SecureString 'Passw0rdForTesting' -AsPlainText -Force

    # count the lines
    $lineCount = (Get-Content $File).Count
    $coverageArray = @()
    # loop the lines and math with the provided results
    for($line=1; $line -lt ($lineCount + 1); $line++){
        $processedLine = $CoverageResultArray | Where-Object {$_.Line -eq $line}
        $coverageArray += if ($processedLine) {
            # make sure got the hit count correct (hate the indentation)
            $firstobject = $processedLine | Select-Object -First 1
            if ($processedLine.count -gt 1 -and $firstobject.CoverageResult -eq 1) {
                $processedLine.count
            } else {
                $firstobject.CoverageResult
            }
        } else {
            $null
        }
    }
    return $coverageArray
}

function Format-FileCoverage {

    [CmdletBinding()]
    param
    (
        [parameter(Mandatory = $true,Position=1)]
        $CoverageArray,
        [parameter(Mandatory = $true,Position=2)]
        $File,
        [parameter(Mandatory = $true,Position=3)]
        $RootFolder
    )

    $fileHash = Get-FileHash $File -Algorithm MD5
    $root = (Get-Item $RootFolder).FullName
    $fileName = (Get-Item $File).FullName.Replace($root, '').Replace('\','/')
    if ($fileName.StartsWith('/')) {
        $fileName = $fileName.Remove(0,1)
    }
    return New-Object -TypeName PSObject -Property @{
        name = $fileName
        source_digest = $fileHash.Hash
        coverage = $CoverageArray
    }
}

function Get-CommandsForFile {

    [CmdletBinding()]
    param
    (
        [parameter(Mandatory = $true,Position=1)]
        $Commands,
        [parameter(Mandatory = $true,Position=2)]
        $File
    )

    $fullName = (Get-Item $File).FullName
    $matchedCommands = $Commands | Where-Object {
        $_.File -eq $fullName
    }
    return $matchedCommands
}

function Get-GitInfo {

    [CmdletBinding()]
    param(
        [string]
        $BranchName
    )
    cd .

    if (!$BranchName) {
        $BranchName = (git rev-parse --abbrev-ref HEAD)
    }

    return New-Object -TypeName PSObject -Property @{
        head = New-Object -TypeName PSObject -Property @{
            id = (git log --format="%H" HEAD -1)
            author_name = (git log --format="%an" HEAD -1)
            author_email = (git log --format="%ae" HEAD -1)
            committer_name = (git log --format="%cn" HEAD -1)
            committer_email = (git log --format="%ce" HEAD -1)
            message = (git log --format="%s" HEAD -1)
        }
        branch = $BranchName
    }
}

function Format-Coverage {

    [CmdletBinding()]
    param
    (
        [parameter(Mandatory = $true, Position = 0, ParameterSetName = "PesterResults")]
        $PesterResults,
        [parameter(Mandatory = $true, Position = 1, ParameterSetName = "Include")]
        $Include,
        [parameter(Mandatory = $true,Position=2)]
        [string]
        $CoverallsApiToken,
        $BranchName,
        $RootFolder = $pwd
    )

    $fileCoverageArray = @()
    if (!$pesterResults) {
        $pesterResults = Invoke-Pester -CodeCoverage $Include -Quiet -PassThru
    }
    if (!$pesterResults.CodeCoverage) {
        Write-Error 'Please provide pester results with code coverage using the -CodeCoverage parameter'
        return;
    }
    foreach ($file in $pesterResults.CodeCoverage.AnalyzedFiles) {
        $hitcommands = Get-CommandsForFile -Commands $pesterResults.CodeCoverage.HitCommands -File $file
        $missedCommands = Get-CommandsForFile -Commands $pesterResults.CodeCoverage.MissedCommands -File $file
        $coverageResult = Merge-CoverageResult -HitCommands $hitcommands -MissedCommands $missedCommands -File $file 
        $coverageArray = Get-CoverageArray -CoverageResultArray $coverageResult -File $file 
        $fileCoverageArray += (Format-FileCoverage -CoverageArray $coverageArray -File $file -RootFolder $RootFolder)
    }
    $git = Get-GitInfo -BranchName $BranchName
    return New-Object -TypeName PSObject -Property @{
        repo_token = $CoverallsApiToken
        commit_sha = (git log --format="%H" HEAD -1)
        git = $git
        service_name = 'appveyor'
        source_files = $fileCoverageArray
    }
}

function Publish-Coverage {

    [CmdletBinding()]
    param
    (
        [parameter(Mandatory = $true,Position=1)]
        $Coverage
    )

    Add-Type -AssemblyName System.Net.Http
    $stringContent = New-Object System.Net.Http.StringContent (ConvertTo-Json $Coverage -Depth 3)
    $httpClient = New-Object System.Net.Http.Httpclient
    $formdata = New-Object System.Net.Http.MultipartFormDataContent
    $formData.Add($stringContent, "json_file", "coverage.json")
    $result = $httpClient.PostAsync('https://coveralls.io/api/v1/jobs', $formData).Result;
    $content = $result.Content.ReadAsStringAsync()
    $coverageResult = ConvertFrom-Json $content.Result
    return $coverageResult.url
}

function Get-CoveragePercentage {

    [CmdletBinding()]
    param
    (
        [parameter(Mandatory = $true,Position=1)]
        $RepositoryLink
    )
    cd .

    try { 
        $response = Invoke-WebRequest -UseBasicParsing "$RepositoryLink.json"
        $coverageInfo = ConvertFrom-Json $response.Content
        return $coverageInfo.covered_percent
    } catch {
        Write-Error 'We could not complete your request.'
    }    
}