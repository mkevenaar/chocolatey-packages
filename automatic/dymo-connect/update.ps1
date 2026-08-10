Import-Module Chocolatey-AU
Add-Type -AssemblyName System.Net.Http

$releases = 'https://www.dymo.com/support?cfid=user-guide'
$releaseBase = 'https://dymoreleasecontent.blob.core.windows.net/dymo-release/DCDWIN'

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(^[$]url32\s*=\s*)('.*')"          = "`$1'$($Latest.URL32)'"
            "(^[$]checksum32\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum32)'"
            "(^[$]checksumType32\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
            "(^[$]url64\s*=\s*)('.*')"          = "`$1'$($Latest.URL64)'"
            "(^[$]checksum64\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum64)'"
            "(^[$]checksumType64\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType64)'"
        }
     }
}

function Get-CurrentInstallerVersion {
    $installScriptPath = Join-Path $PSScriptRoot 'tools\chocolateyInstall.ps1'
    $installScript = Get-Content -Path $installScriptPath -Raw
    $versionMatch = [regex]::Match($installScript, 'DCDSetup(?<Version>\d+(?:\.\d+){1,3})(?:-(?:X86|X64))?\.exe')

    if (-not $versionMatch.Success) {
        throw "Unable to determine the current DYMO Connect installer version from $installScriptPath"
    }

    return [version]$versionMatch.Groups['Version'].Value
}

function Get-CandidateVersion {
    param(
        [version]$Baseline
    )

    $patch = if ($Baseline.Build -ge 0) { $Baseline.Build } else { 0 }
    $build = if ($Baseline.Revision -ge 0) { $Baseline.Revision } else { 0 }

    $streams = @(
        @{ Major = $Baseline.Major; Minor = $Baseline.Minor + 2; Patch = 0; BuildStart = 99; BuildEnd = 0 }
        @{ Major = $Baseline.Major; Minor = $Baseline.Minor + 1; Patch = 1; BuildStart = 99; BuildEnd = 0 }
        @{ Major = $Baseline.Major; Minor = $Baseline.Minor + 1; Patch = 0; BuildStart = 99; BuildEnd = 0 }
        @{ Major = $Baseline.Major; Minor = $Baseline.Minor; Patch = $patch + 1; BuildStart = 99; BuildEnd = 0 }
        @{ Major = $Baseline.Major; Minor = $Baseline.Minor; Patch = $patch; BuildStart = [Math]::Max($build + 99, 99); BuildEnd = 0 }
    )

    $versions = New-Object 'System.Collections.Generic.HashSet[string]'

    foreach ($stream in $streams) {
        for ($buildNumber = $stream.BuildStart; $buildNumber -ge $stream.BuildEnd; $buildNumber--) {
            $null = $versions.Add("$($stream.Major).$($stream.Minor).$($stream.Patch).$buildNumber")
        }
    }

    return $versions | Sort-Object { [version]$_ } -Descending
}

function Test-RemoteFile {
    param(
        [System.Net.Http.HttpClient]$Client,
        [string]$Url
    )

    $request = [System.Net.Http.HttpRequestMessage]::new([System.Net.Http.HttpMethod]::Head, $Url)

    try {
        $response = $Client.SendAsync($request).GetAwaiter().GetResult()
        return $response.IsSuccessStatusCode
    }
    catch {
        return $false
    }
    finally {
        if ($response) {
            $response.Dispose()
        }

        $request.Dispose()
    }
}

function Find-ExistingVersion {
    param(
        [System.Net.Http.HttpClient]$Client,
        [string[]]$Versions
    )

    $requests = foreach ($version in $Versions) {
        $url = "$releaseBase/DCDSetup$version-X64.exe"
        $request = [System.Net.Http.HttpRequestMessage]::new([System.Net.Http.HttpMethod]::Head, $url)

        [PSCustomObject]@{
            Version = $version
            URL     = $url
            Request = $request
            Task    = $Client.SendAsync($request)
        }
    }

    try {
        [System.Threading.Tasks.Task]::WaitAll([System.Threading.Tasks.Task[]]$requests.Task)
    }
    catch [System.AggregateException] {
        Write-Verbose "One or more DYMO Connect release probes failed: $($_.Exception.Message)"
    }

    foreach ($request in $requests) {
        $response = $null

        try {
            if ($request.Task.Status -eq [System.Threading.Tasks.TaskStatus]::RanToCompletion) {
                $response = $request.Task.Result
            }

            if ($response -and $response.IsSuccessStatusCode) {
                return @{
                    Version = $request.Version
                    URL64   = $request.URL
                }
            }
        }
        finally {
            if ($response) {
                $response.Dispose()
            }

            $request.Request.Dispose()
        }
    }

    return $null
}

function global:au_GetLatest {
    $baseline = Get-CurrentInstallerVersion
    $client = [System.Net.Http.HttpClient]::new()
    $candidateVersions = @(Get-CandidateVersion -Baseline $baseline)
    $batchSize = 32

    try {
        for ($i = 0; $i -lt $candidateVersions.Count; $i += $batchSize) {
            $end = [Math]::Min($i + $batchSize - 1, $candidateVersions.Count - 1)
            $release = Find-ExistingVersion -Client $client -Versions $candidateVersions[$i..$end]

            if (-not $release) {
                continue
            }

            $url32 = "$releaseBase/DCDSetup$($release.Version)-X86.exe"

            if (-not (Test-RemoteFile -Client $client -Url $url32)) {
                throw "Found DYMO Connect $($release.Version) x64 installer, but x86 installer was not available at $url32"
            }

            return @{
                URL32   = $url32
                URL64   = $release.URL64
                Version = $release.Version
            }
        }
    }
    finally {
        $client.Dispose()
    }

    throw "Unable to find a DYMO Connect release on $releaseBase. DYMO's support page ($releases) is Cloudflare-protected for Invoke-WebRequest, so AU probes the official release blob naming pattern."
}

if ($MyInvocation.InvocationName -ne '.') {
    update -ChecksumFor all
}
