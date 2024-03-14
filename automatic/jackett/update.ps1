Import-Module Chocolatey-AU
Import-Module "$PSScriptRoot\..\..\scripts\au_extensions.psm1"

$repoUser = "Jackett"
$repoName = "Jackett"

function global:au_SearchReplace {
  return @{
    'tools\chocolateyInstall.ps1' = @{
      "(?i)(^\s*file\s*=\s*`"[$]toolsDir\\).*" = "`${1}$($Latest.FileName32)`""
    }
    ".\legal\VERIFICATION.txt"   = @{
      "(?i)(listed on\s*)\<.*\>" = "`${1}<$($Latest.ReleaseUri)>"
      "(?i)(32-Bit.+)\<.*\>"     = "`${1}<$($Latest.URL32)>"
      "(?i)(checksum type:).*"   = "`${1} $($Latest.ChecksumType32)"
      "(?i)(checksum32:).*"      = "`${1} $($Latest.Checksum32)"
    }
  }
}

function global:au_BeforeUpdate($Package) {
  $licenseData = Get-GithubRepositoryLicense $repoUser $repoName
  $licenseFile = "$PSScriptRoot\legal\LICENSE.txt"
  if (Test-Path $licenseFile) { Remove-Item -Force $licenseFile }

  Invoke-WebRequest -Uri $licenseData.download_url -UseBasicParsing -OutFile "$licenseFile"
  $Latest.LicenseUrl = $licenseData.html_url

  Get-RemoteFiles -Purge -NoSuffix
}

function global:au_AfterUpdate($Package) {
  Update-Metadata -key "licenseUrl" -value $Latest.LicenseUrl
  Invoke-VirusTotalScan $Package
}

function global:au_GetLatest {
  $release = Get-LatestGithubReleases $repoUser $repoName $true

  $url32 = $release.latest.Assets | Where-Object { $_ -match 'Windows\.exe$' } | Select-Object -First 1

  $Latest = @{
    URL32      = $url32;
    Version    = $release.latest.Version;
    ReleaseUri = $release.latest.ReleaseUrl
  }
  return $Latest
}

update -ChecksumFor None
