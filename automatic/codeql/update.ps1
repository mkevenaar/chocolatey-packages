Import-Module Chocolatey-AU
Import-Module "$PSScriptRoot\..\..\scripts\au_extensions.psm1"

$repoUser = "github"
$repoName = "codeql-cli-binaries"

function global:au_SearchReplace {
  @{
    'tools\chocolateyInstall.ps1'      = @{
      "(^[$]url\s*=\s*)('.*')"          = "`$1'$($Latest.URL64)'"
      "(^[$]checksum\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum64)'"
      "(^[$]checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType64)'"
    }
  }
}

function global:au_AfterUpdate($Package) {
  Invoke-VirusTotalScan $Package
}

function global:au_GetLatest {
  $release = Get-LatestGithubReleases $repoUser $repoName $true

  $url64 = $release.latest.Assets | Where-Object { $_ -match 'win64\.zip$' } | Select-Object -First 1

  $Latest = @{
    URL64      = $url64;
    Version    = $release.latest.Version;
    ReleaseUri = $release.latest.ReleaseUrl
  }
  return $Latest
}

if ($MyInvocation.InvocationName -ne '.') {
  update -ChecksumFor 64
}
