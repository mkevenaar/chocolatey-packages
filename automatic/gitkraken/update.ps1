Import-Module Chocolatey-AU

$releases = 'https://www.gitkraken.com/download'

function global:au_SearchReplace {
  @{
    'tools\chocolateyInstall.ps1' = @{
      "(^[$]url32\s*=\s*)('.*')"          = "`$1'$($Latest.URL32)'"
      "(^[$]checksum32\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum32)'"
      "(^[$]checksumType32\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
      "(^[$]url64\s*=\s*)('.*')"          = "`$1'$($Latest.URL64)'"
      "(^[$]checksum64\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum64)'"
      "(^[$]checksumType64\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType64)'"
    }
  }
}

function global:au_GetLatest {
  $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing

  $re = 'Latest release: (.+)</span>'
  $version = ([regex]::Match($download_page.content, $re)).Captures.Groups[1].value

  $url32 = 'https://release.gitkraken.com/win32/GitKrakenSetup.exe'
  $url64 = 'https://release.gitkraken.com/win64/GitKrakenSetup.exe'

  return @{
    URL32   = $url32
    URL64   = $url64
    Version = $version
  }
}

update
