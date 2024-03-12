Import-Module Chocolatey-AU

$releases = 'https://developer.microsoft.com/en-us/windows/downloads/windows-sdk/'

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
  $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing -DisableKeepAlive
  $url32 = $download_page.links | Where-Object OuterHTML -match "Download the installer" | Select-Object -First 1 -expand href
  $url32 = Get-RedirectedUrl $url32

  $re = 'Windows SDK \(([\d\.]+)\)'
  $version = ([regex]::Match($download_page.Content,$re)).Captures.Groups[1].value

  return @{
    URL32    = $url32
    Version  = $version
  }
}


if ($MyInvocation.InvocationName -ne '.') {
  update -ChecksumFor 32
}
