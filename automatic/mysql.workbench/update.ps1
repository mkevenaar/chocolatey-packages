Import-Module Chocolatey-AU

$releases = 'https://api.github.com/repos/mysql/mysql-workbench/tags'

function global:au_SearchReplace {
  @{
    'tools\chocolateyInstall.ps1' = @{
      "(^[$]url\s*=\s*)('.*')"          = "`$1'$($Latest.URL32)'"
      "(^[$]checksum\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum32)'"
      "(^[$]checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
    }
  }
}

function global:au_GetLatest {
  $header = @{
    "Authorization" = "token $env:github_api_key"
  }
  $download_page = Invoke-RestMethod -Uri $releases -Headers $header

  $version = Get-Version($download_page[0].name)

  $url = 'https://cdn.mysql.com/Downloads/MySQLGUITools/mysql-workbench-community-' + $version + '-winx64.msi'
  $Latest = @{ URL32 = $url; Version = $version }
  return $Latest
}

update -ChecksumFor 32
