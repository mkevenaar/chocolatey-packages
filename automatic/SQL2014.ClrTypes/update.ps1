Import-Module AU
Import-Module "$env:ChocolateyInstall\helpers\chocolateyInstaller.psm1"
Import-Module "$PSScriptRoot\..\..\scripts/au_extensions.psm1"

function global:au_SearchReplace {
    @{
        '.\tools\chocolateyInstall.ps1' = @{
            "(^[$]url32\s*=\s*)('.*')"      = "`$1'$($Latest.URL32)'"
            "(^[$]checksum32\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
            "(^[$]checksumType32\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
            "(^[$]url64\s*=\s*)('.*')"      = "`$1'$($Latest.URL64)'"
            "(^[$]checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
            "(^[$]checksumType64\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType64)'"
        }
     }
}

function GetResultInformation([string]$url32, [string]$url64) {
  $dest = "$env:TEMP\SQLSysClrTypes.msi"

  Get-WebFile $url32 $dest | Out-Null
  $checksumType = 'sha256'
  $version = (Get-MsiInformation -Path $dest).ProductVersion
  $checksum32 = Get-FileHash $dest -Algorithm $checksumType | % Hash
  Remove-Item -force $dest -ErrorAction SilentlyContinue

  return @{
    URL32          = $url32
    URL64          = $url64
    Version        = $version
    Checksum32     = $checksum32
    ChecksumType32 = $checksumType
    Checksum64     = Get-RemoteChecksum $url64 -Algorithm $checksumType
    ChecksumType64 = $checksumType
  }
}

function global:au_GetLatest {
  $url32 = 'https://download.microsoft.com/download/F/E/E/FEE62C90-E5A9-4746-8478-11980609E5C2/ENU/x86/SQLSysClrTypes.msi'
  $url64 = 'https://download.microsoft.com/download/F/E/E/FEE62C90-E5A9-4746-8478-11980609E5C2/ENU/x64/SQLSysClrTypes.msi'

  Update-OnETagChanged -execUrl $url64 `
    -OnETagChanged {
    GetResultInformation $url32 $url64
  } -OnUpdated { @{ URL32 = $url32 ; URL64 = $url64 }}
}

update -ChecksumFor none
