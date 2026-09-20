Import-Module Chocolatey-AU

$releases = 'https://www.viofo.com/pages/viofo-app'

function global:au_SearchReplace {
  @{
    'tools\chocolateyinstall.ps1' = @{
      "(^[$]url\s*=\s*)('.*')"          = "`$1'$($Latest.URL64)'"
      "(^[$]checksum\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum64)'"
      "(^[$]checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType64)'"
    }
  }
}

function global:au_GetLatest {
  $downloadPage = Invoke-WebRequest -Uri $releases -UseBasicParsing

  # The page also contains mobile apps, macOS downloads and earlier releases.
  $player = [regex]::Match($downloadPage.Content, '(?is)<h2\b[^>]*>\s*VIOFO Player\s*</h2>(.*?)</section>')
  $windows = [regex]::Match($player.Groups[1].Value, '(?is)<div\b[^>]*data-platform=["'']windows["''][^>]*>(.*?)(?=<div\b[^>]*data-platform=|$)')
  $version = [regex]::Match($windows.Groups[1].Value, '(?is)<p\b[^>]*>\s*Windows\s+V?(\d+(?:\.\d+){1,3})\s*</p>')
  $link = [regex]::Match($windows.Groups[1].Value, '(?is)<a\b(?=[^>]*\bclass=["'']st-dl["''])[^>]*\bhref=["'']([^"'']+\.exe(?:\?[^"'']*)?)["'']')

  if (!$player.Success -or !$windows.Success -or !$version.Success -or !$link.Success) {
    throw 'Unable to find the current VIOFO Player Windows version and installer on the download page.'
  }

  $url = [uri]::new([uri]$releases, [System.Net.WebUtility]::HtmlDecode($link.Groups[1].Value))
  if ($url.Scheme -ne 'https') {
    throw 'The VIOFO Player Windows download must use HTTPS.'
  }

  @{
    Version  = $version.Groups[1].Value
    URL64    = $url.AbsoluteUri
    FileType = 'exe'
  }
}

if ($MyInvocation.InvocationName -ne '.') {
  update -ChecksumFor 64
}
