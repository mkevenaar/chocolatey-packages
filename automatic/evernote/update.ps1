Import-Module AU
Import-Module "$env:ChocolateyInstall\helpers\chocolateyInstaller.psm1"
Import-Module "$PSScriptRoot\..\..\scripts/au_extensions.psm1"

function global:au_SearchReplace {
    @{
        'tools\ChocolateyInstall.ps1' = @{
            "(^[$]url\s*=\s*)('.*')"      = "`$1'$($Latest.URL32)'"
            "(^[$]checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
            "(^[$]checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
        }
     }
}

function GetResultInformation([string]$url32) {
  $url32 = Get-RedirectedUrl $url32
  $dest = "$env:TEMP\evernote.exe"

  Get-WebFile $url32 $dest | Out-Null
  $checksumType = 'sha256'
  $version = (Get-Command $dest).version
  $checksum32 = Get-FileHash $dest -Algorithm $checksumType | ForEach-Object Hash
  Remove-Item -force $dest

  return @{
    URL32          = $url32
    Version        = $version
    Checksum32     = $checksum32
    ChecksumType32 = $checksumType
  }
}

function global:au_GetLatest {
  $url32 = 'https://evernote.com/download/get.php?file=Win'

  Update-OnETagChanged -execUrl $url32 `
    -OnETagChanged {
    GetResultInformation $url32
  } -OnUpdated { @{ URL32 = $url32; }}
}

update -ChecksumFor none
