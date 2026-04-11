Import-Module Chocolatey-AU

$releases = 'https://learn.microsoft.com/en-us/windows/apps/windows-sdk/downloads?accept=text/markdown'

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
  $downloadPage = Invoke-WebRequest -Uri $releases -UseBasicParsing -DisableKeepAlive
  $sectionRe = '(?ms)^## Windows \d+\s*$\s*(.*?)(?=^## |\z)'
  $sectionMatch = [regex]::Match($downloadPage.Content, $sectionRe)

  if (-not $sectionMatch.Success) {
    throw "Failed to locate a stable Windows SDK section on $releases"
  }

  $releaseRe = '^\| \*\*Windows SDK for Windows [^|]+?\(([\d\.]+)\).*?\| \[Installer\]\(([^)]+)\)'
  $match = [regex]::Match($sectionMatch.Groups[1].Value, $releaseRe, [System.Text.RegularExpressions.RegexOptions]::Multiline)

  if (-not $match.Success) {
    throw "Failed to locate the latest stable Windows SDK installer in the current release section on $releases"
  }

  $version = $match.Groups[1].Value
  $url32 = $match.Groups[2].Value.Trim()

  if ($url32.StartsWith('//')) {
    $url32 = "https:$url32"
  }

  $url32 = Get-RedirectedUrl $url32

  return @{
    URL32    = $url32
    Version  = $version
  }
}


if ($MyInvocation.InvocationName -ne '.') {
  update -ChecksumFor 32
}
