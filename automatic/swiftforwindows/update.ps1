Import-Module Chocolatey-AU
Import-Module "$PSScriptRoot\..\..\scripts\au_extensions.psm1"

$repoUser = 'SwiftForWindows'
$repoName = 'SwiftForWindows'

function global:au_SearchReplace {
    @{
        '.\tools\chocolateyInstall.ps1' = @{
            "(^[$]url\s*=\s*)('.*')"      = "`$1'$($Latest.URL32)'"
            "(^[$]checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
        }
     }
}

function global:au_GetLatest {
    $release = Get-AllGithubReleases $repoUser $repoName |
        Where-Object { -not $_.IsPreRelease } |
        Select-Object -First 1

    if ($release.Version -notmatch '^v?(\d+(?:\.\d+){1,3})$') {
        throw "Unable to determine the Swift for Windows version from the latest stable GitHub release '$($release.Version)'."
    }
    $version = $Matches[1]

    $assetName = "SwiftForWindows-$version.exe"
    $urls = @($release.Assets | Where-Object { $_ -like "*/$assetName" })
    if ($urls.Count -ne 1) {
        throw "Expected one '$assetName' installer asset in GitHub release '$($release.Version)'."
    }

    return @{
        URL32 = $urls[0]
        Version = $version
    }
}
if ($MyInvocation.InvocationName -ne '.') {
    update -ChecksumFor 32
}
