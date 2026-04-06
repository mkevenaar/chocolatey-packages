Import-Module Chocolatey-AU

$downloadUrl = 'https://api.gitkraken.dev/releases/production/windows/x64/active/GitKrakenSetup.exe'

function global:au_SearchReplace {
  @{
    'tools\chocolateyInstall.ps1' = @{
      "(^[$]url64\s*=\s*)('.*')"          = "`$1'$($Latest.URL64)'"
      "(^[$]checksum64\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum64)'"
      "(^[$]checksumType64\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType64)'"
    }
  }
}

function global:au_GetLatest {
  $url64 = Get-RedirectedUrl $downloadUrl

  $version = ([regex]::Match($url64, '/windows/x64/([^/]+)/')).Groups[1].Value

  if (-not $version) {
    throw "Unable to determine GitKraken version from redirect URL: $url64"
  }

  return @{
    URL64   = $url64
    Version = $version
  }
}

update -ChecksumFor 64
