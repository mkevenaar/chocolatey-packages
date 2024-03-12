Import-Module Chocolatey-AU

$releases = 'https://api.github.com/repos/elastic/elasticsearch/releases'

function global:au_SearchReplace {
  @{
    'tools\chocolateyInstall.ps1'      = @{
      "(^[$]url\s*=\s*)('.*')"          = "`$1'$($Latest.URL32)'"
      "(^[$]checksum\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum32)'"
      "(^[$]checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
      "(^[$]version\s*=\s*)`".*`""      = "`${1}`"$($Latest.Version)`""
    }
    'tools\chocolateyBeforeModify.ps1' = @{
      "(^[$]version\s*=\s*)`".*`"" = "`${1}`"$($Latest.Version)`""
    }
    "$($Latest.PackageName).nuspec"    = @{
      "(?i)(^\s*\<releaseNotes\>).*(\<\/releaseNotes\>)" = "`${1}$($Latest.ReleaseNotes)`${2}"
    }
  }
}

function CreateStream {
  param($url32bit, $version, $releaseNotes)

  $Result = @{
    Version      = $version
    URL32        = $url32bit
    ReleaseNotes = $releaseNotes
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

    $url = "https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-$($version)-windows-x86_64.zip"

    if ($version.toString(1) -eq 6) {
      $url = "https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-$($version).zip"
    }

    $majmin = $version.toString(2)

    $releasenotes = "https://www.elastic.co/guide/en/elasticsearch/reference/$($majmin)/release-notes-$($version).html"


    $streamVersion = $version.toString(2)
    if ($release.prerelease) {
      $streamVersion += '-rc'
    }

    if (!$streams.ContainsKey("$streamVersion")) {
      $streams.Add($streamVersion, (CreateStream $url $version $releaseNotes))
    }
  }

  return  @{ Streams = $streams }
}


if ($MyInvocation.InvocationName -ne '.') {
  update -ChecksumFor 32
}
