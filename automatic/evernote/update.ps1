Import-Module AU

$releases = 'https://evernote.com/download'

function global:au_SearchReplace {
    @{
        'tools\ChocolateyInstall.ps1' = @{
            "(^[$]url\s*=\s*)('.*')"      = "`$1'$($Latest.URL32)'"
            "(^[$]checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
            "(^[$]checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
        }
     }
}
function global:au_BeforeUpdate {
  $Latest.Checksum32 = Get-RemoteChecksum -Url $Latest.URL32 -Algorithm $Latest.ChecksumType32
}


function global:au_GetLatest {
  $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing

  $re = "Evernote[_-](.+)(-setup?).exe"

  $url32 = $download_page.Links | Where-Object href -match $re | Select-Object -First 1 -expand href

  $version = Get-Version((([regex]::Match($url32,$re)).Captures.Groups[1].value) -Replace "-", ".")

  return @{
    URL32 = $url32
    Version = $version
    ChecksumType32 = 'sha256'
  }
}

update -ChecksumFor none
