Import-Module AU

$releases = 'https://grafana.com/grafana/download?platform=windows'

function global:au_GetLatest {
  $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing

  $re = "grafana-(.+\d).windows-amd64.zip"
  $url32 = $download_page.Links | Where-Object href -match $re | Select-Object -First 1 -expand href

  $version = ([regex]::Match($url32,$re)).Captures.Groups[1].value
  $version = Get-Version $version

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
