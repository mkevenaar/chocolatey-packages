Import-Module Chocolatey-AU

$releases = 'https://www.gitkraken.com/download'

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
  $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing

  $re = 'Latest release: ([\d\.]+)'
  $version = ([regex]::Match($download_page.content, $re)).Captures.Groups[1].value

  $url64 = 'https://api.gitkraken.dev/releases/production/windows/x64/active/GitKrakenSetup.exe'

  return @{
    URL64   = $url64
    Version = $version
  }
}

update -ChecksumFor 64
