function GetVersion() {
  param($versionToParse)
  try {
    return Get-Version $versionToParse
  } catch {
    return $versionToParse
  }
}

function resolveRelease {
  param($release)

  [array]$assetUrls = $release.assets | Where-Object name -Match "\.(msi|exe|zip|7z)$" | Select-Object -expand browser_download_url
  $assetUrls += @($release.tarball_url; $release.zipball_url)

  try {
    return @{
      Name         = $release.name
      Version      = GetVersion $release.tag_name
      Assets       = $assetUrls
      IsPreRelease = $release.prerelease -eq "true"
      ReleaseUrl   = $release.html_url
      Body         = $release.body
    }
  } catch {
    Write-Warning "Unable to return release, may be an invalid tag name..."
  }
}

function Get-AllGithubReleases() {
  param(
    [string]$repoUser,
    [string]$repoName
  )

  $apiUrl = "https://api.github.com/repos/$($repoUser)/$($repoName)/releases"

  $headers = @{}
  if (Test-Path Env:\github_api_key) {
    $headers.Authorization = "token " + $env:github_api_key
  }

  $response = Invoke-RestMethod -Uri $apiUrl -Headers $headers

  return $response | ForEach-Object { resolveRelease $_ }
}
