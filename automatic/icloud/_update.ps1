Import-Module Chocolatey-AU
Import-Module "$env:ChocolateyInstall\helpers\chocolateyInstaller.psm1"
Import-Module "$PSScriptRoot\..\..\scripts/au_extensions.psm1"

$releases = "https://support.apple.com/en-us/HT204283"

$softwareName = 'iCloud'

function global:au_SearchReplace {
  @{
    ".\tools\chocolateyInstall.ps1" = @{
      "(?i)(^\s*packageName\s*=\s*)'.*'"    = "`${1}'$($Latest.PackageName)'"
      "(?i)(^\s*softwareName\s*=\s*)'.*'"   = "`${1}'$softwareName'"
      "(?i)(^\s*url\s*=\s*)'.*'"            = "`${1}'$($Latest.URL32)'"
      "(?i)(^\s*checksum\s*=\s*)'.*'"       = "`${1}'$($Latest.Checksum32)'"
      "(?i)(^\s*checksumType\s*=\s*)'.*'"   = "`${1}'$($Latest.ChecksumType32)'"
      "(?i)(^[$]version\s*=\s*)'.*'"        = "`${1}'$($Latest.RemoteVersion)'"
    }
  }
}

function GetResultInformation([string]$url32) {
  $dest = "$env:TEMP\icloud.exe"

  Get-WebFile $url32 $dest | Out-Null
  $checksumType = 'sha256'
  $version = Get-Item $dest | ForEach-Object { $_.VersionInfo.ProductVersion }
  $checksum32 = Get-FileHash $dest -Algorithm $checksumType | ForEach-Object Hash
  Remove-Item -force $dest

  return @{
    URL32          = $url32
    Version        = $version
    RemoteVersion  = $version
    Checksum32     = $checksum32
    ChecksumType32 = $checksumType
    PackageName    = 'iCloud'
  }
}

function global:au_GetLatest {
  $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing

  $re = "iCloudSetup.exe"

  $url32 = $download_page.Links | Where-Object href -match $re | Select-Object -first 1 -expand href

  GetResultInformation $url32
}

update -ChecksumFor none
