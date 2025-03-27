Import-Module Chocolatey-AU
Import-Module "$PSScriptRoot\..\..\scripts\au_extensions.psm1"

$repoUser = "signalapp"
$repoName = "Signal-Desktop"

function global:au_SearchReplace {
  return @{
    'tools\chocolateyInstall.ps1'   = @{
      "(?i)(^\s*url\s*=\s*)('.*')"      = "`$1'$($Latest.URL32)'"
      "(?i)(^\s*checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
    }
    "$($Latest.PackageName).nuspec" = @{
      "(\<releaseNotes\>).*?(\</releaseNotes\>)" = "`${1}$($Latest.ReleaseNotes)`$2"
    }
  }
}

function global:au_GetLatest {
  $release = Get-LatestGithubReleases $repoUser $repoName $false
  $version = $release.latest.Version
  return @{
    Version      = $version
    URL32        = "https://updates.signal.org/desktop/signal-desktop-win-$version.exe"
    ReleaseNotes = "https://github.com/WhisperSystems/Signal-Desktop/releases/tag/v$version"
  }
}

update
