Import-Module Chocolatey-AU

function global:au_SearchReplace {
    @{
        'tools\ChocolateyInstall.ps1' = @{
            "(^[$]url\s*=\s*)('.*')"      = "`$1'$($Latest.URL32)'"
            "(^[$]checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
            "(^[$]checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
        }
     }
}

function global:au_GetLatest {
  $url32 = Get-RedirectedUrl 'https://dl.google.com/chat/latest/InstallHangoutsChat.msi'

  $re = "chat/(.+)/Install"
  $version = ([regex]::Match($url32,$re)).Captures.Groups[1].value

  return @{
    URL32 = $url32
    Version = $version
    ChecksumType32 = 'sha256'
  }
}

update -ChecksumFor 32
