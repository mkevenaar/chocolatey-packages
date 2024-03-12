Import-Module Chocolatey-AU
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
  $dest = "$env:TEMP\SharedManagementObjects.msi"

  Get-WebFile $url32 $dest | Out-Null
  $checksumType = 'sha256'
  $version = (Get-MsiInformation -Path $dest).ProductVersion
  $checksum32 = Get-FileHash $dest -Algorithm $checksumType | ForEach-Object Hash
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
  $url32 = 'https://download.microsoft.com/download/6/7/8/67858AF1-B1B3-48B1-87C4-4483503E71DC/ENU/x86/SharedManagementObjects.msi'
  $url64 = 'https://download.microsoft.com/download/6/7/8/67858AF1-B1B3-48B1-87C4-4483503E71DC/ENU/x64/SharedManagementObjects.msi'

  Update-OnETagChanged -execUrl $url64 `
    -OnETagChanged {
    GetResultInformation $url32 $url64
  } -OnUpdated { @{ URL32 = $url32 ; URL64 = $url64 }}
}

update -ChecksumFor none
