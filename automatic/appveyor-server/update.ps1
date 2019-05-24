Import-Module AU
Import-Module "$env:ChocolateyInstall\helpers\chocolateyInstaller.psm1"
Import-Module "$PSScriptRoot\..\..\scripts/au_extensions.psm1"

function global:au_SearchReplace {
    @{
        '.\tools\chocolateyInstall.ps1' = @{
            "(^[$]url32\s*=\s*)('.*')"      = "`$1'$($Latest.URL32)'"
            "(^[$]checksum32\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
            "(^[$]checksumType32\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
        }
     }
}

function global:au_GetLatest {
  $url32 = 'https://www.appveyor.com/downloads/appveyor-server/latest/windows/appveyor-server.msi'
  $dest = "$env:TEMP\appveyor-server.msi"

  Get-WebFile $url32 $dest | Out-Null
  $checksumType = 'sha256'
  $version = (Get-MsiInformation -Path $dest).ProductVersion
  $checksum32 = Get-FileHash $dest -Algorithm $checksumType | % Hash
  Remove-Item -force $dest -ErrorAction SilentlyContinue

  return @{
    URL32          = $url32
    Version        = $version
    Checksum32     = $checksum32
    ChecksumType32 = $checksumType
  }
}

update -ChecksumFor none
