Import-Module Chocolatey-AU

$releases = 'https://support.wdc.com/downloads.aspx?p=172'
$versionPage = 'https://support-en.wd.com/app/products/downloads/release-notes/note_id/29495'

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
  $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing
  $url = $download_page.Links | Where-Object href -Match ".zip" | Select-Object -First 1 -ExpandProperty href

  # $version = Get-Version $url
  $version_page = Invoke-WebRequest -Uri $versionPage -UseBasicParsing
  $re = '<p><strong>Version: (.+\d)\s'
  $version = ([regex]::Match($version_page.content, $re)).Captures.Groups[1].value

  $releaseNotes = $download_page.Links | Where-Object href -Match ".pdf" | Select-Object -First 1 -ExpandProperty href

  $Latest = @{ URL32 = $url; Version = $version; ReleaseNotes = $releaseNotes }
  return $Latest
}

update -ChecksumFor 32
