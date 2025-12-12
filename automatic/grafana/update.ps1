Import-Module Chocolatey-AU

$releases = "https://api.github.com/repos/grafana/grafana/releases"

function global:au_SearchReplace {
  return @{
    ".\tools\chocolateyInstall.ps1" = @{
      "(^[$]url32\s*=\s*)('.*')"         = "`$1'$($Latest.URL32)'"
      "(^[$]checksum32\s*=\s*)('.*')"    = "`$1'$($Latest.Checksum32)'"
      "(^[$]checksumType32\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
    }
  }
}

function CreateStream {
  param($url32bit, $version)

  $Result = @{
    Version = $version
    URL32   = $url32bit
  }

  return $Result
}

function global:au_GetLatest {
  $header = @{
    "Authorization" = "token $env:github_api_key"
  }
  $json = Invoke-RestMethod -Uri $releases -Headers $header

  $streams = @{ }

  foreach ($release in $json) {
    $version = $release.tag_name.Replace('v', '')
    $version = Get-Version($version)

    $url = "https://dl.grafana.com/oss/release/grafana-$version.windows-amd64.zip"

    $streamVersion = $version.toString(2)
    if ($release.prerelease) {
      $streamVersion += '-rc'
    }
    if (!$streams.ContainsKey("$streamVersion")) {
      $streams.Add($streamVersion, (CreateStream $url $version))
    }

  }
  return  @{ Streams = $streams }
}

if ($MyInvocation.InvocationName -ne ".") {
  update -ChecksumFor 32
}
