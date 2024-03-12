function Get-GithubRepositoryLicense {
  param (
    [string]$repoUser,
    [string]$repoName
  )
  $headers = @{}

  if (Test-Path Env:\github_api_key) {
    $headers.Authorization = "token " + $env:github_api_key
  }

  $licenseData = Invoke-RestMethod -Uri "https://api.github.com/repos/${repoUser}/${repoName}/license"

  return $licenseData
}
