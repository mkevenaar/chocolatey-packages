import-module au

$releases = 'https://www.collectorz.com/game/game-collector/signup-completed'
$softwareurl = 'https://www.collectorz.com/download?pf=w&p=game'

function global:au_SearchReplace {
  @{
    'tools\chocolateyInstall.ps1' = @{
      "(^[$]url\s*=\s*)('.*')"          = "`$1'$($Latest.URL32)'"
      "(^[$]checksum\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum32)'"
      "(^[$]checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
    }
  }
}

function global:au_GetLatest {
  $header = @{
    "User-Agent" = "Chocolatey AU update check. https://chocolatey.org"
  }

  $download_page = Invoke-WebRequest -Uri $releases -Headers $header

  $url = [System.Net.HttpWebRequest]::Create($softwareurl).GetResponse().ResponseUri.AbsoluteUri
  $versiondata = $download_page.ParsedHtml.getElementsByTagName('b') | Where-Object innerhtml -match "^Version" | Select-Object -First 1 -expand innerhtml
  $versionregex = "([0-9]+.[0-9]+.[0-9]+)"
  $version = ([regex]::Match($versiondata, $versionregex)).Captures.Groups[1].value

  return @{
    URL32   = $url
    Version = $version
  }
}

update
