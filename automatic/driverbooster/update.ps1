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
  $dest = "$env:TEMP\driver_booster_setup.exe"

  Get-WebFile $url32 $dest | Out-Null
  $checksumType = 'sha256'
  $version = Get-Item $dest | % { $_.VersionInfo.FileVersion }
  $version = $version.Trim()
  $checksum32 = Get-FileHash $dest -Algorithm $checksumType | % Hash
  rm -force $dest

  return @{
    URL32          = $url32
    Version        = $version
    Checksum32     = $checksum32
    ChecksumType32 = $checksumType
  }
}

function global:au_GetLatest {
    $url32   = 'https://cdn.iobit.com/dl/driver_booster_setup.exe'

  Update-OnETagChanged -execUrl $url32 `
    -OnETagChanged {
    GetResultInformation $url32
  } -OnUpdated { @{ URL32 = $url32; }}
}

update -ChecksumFor none
