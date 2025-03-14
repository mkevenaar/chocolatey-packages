Import-Module Chocolatey-AU

$releases = 'https://downloadcenter.intel.com/download/30161'

$headers = @{
  "Accept" = "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/png,image/svg+xml,*/*;q=0.8"
  "Accept-Language" = "en-GB,en;q=0.5"
  "Accept-Encoding" = "gzip, deflate, br, zstd"
}

$options =
@{
  Headers = $headers
}

function global:au_SearchReplace {
  @{
    'tools\chocolateyInstall.ps1'   = @{
      "(^[$]url\s*=\s*)('.*')"          = "`$1'$($Latest.URL32)'"
      "(^[$]checksum\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum32)'"
      "(^[$]checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
    }

    "$($Latest.PackageName).nuspec" = @{
      "(\<releaseNotes\>).*?(\</releaseNotes\>)" = "`${1}$($Latest.ReleaseNotes)`$2"
    }
  }
}

function global:au_GetLatest {
  $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing -Headers $headers

  $re = 'data-href="(.+)">'
  $versionRe = '"DownloadVersion" content="(\d.+)"'

  $url = ([regex]::Match($download_page.content,$re)).Captures.Groups[1].value

  $version = ([regex]::Match($download_page.content,$versionRe)).Captures.Groups[1].value

  $releaseNotes = $download_page.Links | Where-Object href -Match ".pdf" | Where-Object href -Match "Release" | Select-Object -First 1 -ExpandProperty href

  $Latest = @{
    URL32        = $url
    Version      = $version
    ReleaseNotes = $releaseNotes
    Options      = $options
  }
  return $Latest
}

Update-Package -ChecksumFor 32 -NoCheckUrl
