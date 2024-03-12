Import-Module Chocolatey-AU

$feed = 'http://downloads.mongodb.org.s3.amazonaws.com/current.json'

function global:au_SearchReplace {
  @{
    '.\tools\chocolateyInstall.ps1' = @{
      "(^[$]url64\s*=\s*)('.*')"          = "`$1'$($Latest.URL64)'"
      "(^[$]checksum64\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum64)'"
      "(^[$]checksumType64\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType64)'"
    }
    "$($Latest.PackageName).nuspec" = @{
      "(?i)(^\s*\<releaseNotes\>).*(\<\/releaseNotes\>)" = "`${1}$($Latest.ReleaseNotes)`${2}"
    }
  }
}

function CreateStream {
  param($url64bit, $version, $releaseNotes)

  $Result = @{
    Version      = $version
    URL64        = $url64bit
    ReleaseNotes = $releaseNotes
  }

  return $Result
}

function global:au_GetLatest {
  $json = Invoke-WebRequest -Uri $feed -UseBasicParsing  | ConvertFrom-Json

  $streams = @{ }

  $versions = $json.versions

  foreach ($version in $versions) {

    $releaseversion = Get-Version($version.version)

    $url = ($version.downloads | Where-Object { $_.target -eq "windows" -and $_.edition -eq "base" } | Select-Object -ExpandProperty archive).url

    $releaseNotes = $version.notes

    $streamVersion = $releaseversion.toString(2)

    if ($version.release_candidate) {
      $streamVersion += '-rc'
    }

    if ($url) {
      if ($streams.ContainsKey($streamVersion)) {
        $streams.Remove($streamVersion);
      }
      $streams.Add($streamVersion, (CreateStream $url $releaseversion $releaseNotes))
    }
  }

  return  @{ Streams = $streams }
}

if ($MyInvocation.InvocationName -ne '.') {
  update -ChecksumFor 64
}
