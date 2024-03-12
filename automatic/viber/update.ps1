Import-Module Chocolatey-AU
Import-Module "$env:ChocolateyInstall\helpers\chocolateyInstaller.psm1"
Import-Module "$PSScriptRoot\..\..\scripts/au_extensions.psm1"

function global:au_SearchReplace {
    @{
        '.\tools\chocolateyInstall.ps1' = @{
            "(^[$]url\s*=\s*)('.*')"      = "`$1'$($Latest.URL32)'"
            "(^[$]checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
            "(^[$]checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
        }
     }
}

function GetResultInformation([string]$url32) {
  $dest = "$env:TEMP\viber.exe"

  Get-WebFile $url32 $dest | Out-Null
  $checksumType = 'sha256'
  $version = Get-Item $dest | ForEach-Object { $_.VersionInfo.ProductVersion }
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
  $url32 = 'https://download.cdn.viber.com/desktop/windows/ViberSetup.exe'

  Update-OnETagChanged -execUrl "https://download.cdn.viber.com/desktop/windows/ViberSetup.exe" `
    -OnETagChanged {
    GetResultInformation $url32
  } -OnUpdated { @{ URL32 = $url32; }}
}

update -ChecksumFor none
