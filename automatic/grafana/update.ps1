Import-Module AU

$releases = 'https://github.com/grafana/grafana/releases/latest'
function global:au_GetLatest {
  $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing

  $version = (($download_page.Links | Where-Object href -Match "releases/tag" | Select-Object -First 1 -ExpandProperty href) -Split "/" | Select-Object -Last 1) -replace "v"
  $url32 = "https://dl.grafana.com/oss/release/grafana-$version.windows-amd64.zip"

  return @{
        URL32 = $url32
        Version = $version
    }
}

function global:au_SearchReplace {
  return @{
    ".\tools\chocolateyInstall.ps1" = @{
            "(^[$]url\s*=\s*)('.*')"      = "`$1'$($Latest.URL32)'"
            "(^[$]checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
            "(^[$]checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
        }
    }
 }



if ($MyInvocation.InvocationName -ne '.') {
    update -ChecksumFor 32
}
