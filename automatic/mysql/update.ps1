Import-Module Chocolatey-AU

# The mysql-server repo contains a bunch of tags for "mysql-cluster-VERSION"
# If I use https://api.github.com/repos/mysql/mysql-server/tags then I'll need to paginate to find "mysql-VERSION"
# I'm using https://api.github.com/repos/mysql/mysql-server//git/matching-refs/tags so that I'll get a complete list without needing to paginate
# https://stackoverflow.com/a/74561918
$releases = 'https://api.github.com/repos/mysql/mysql-server/git/matching-refs/tags'

function global:au_SearchReplace {
  @{
    'tools\chocolateyInstall.ps1' = @{
      "(^[$]url\s*=\s*)('.*')"          = "`$1'$($Latest.URL64)'"
      "(^[$]checksum\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum64)'"
      "(^[$]checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType64)'"
    }
  }
}

function global:au_GetLatest {
  $header = @{
    "Authorization" = "token $env:github_api_key"
  }
  $download_page = Invoke-RestMethod -Uri $releases -Headers $header

  $valid_tags = $download_page | Where-Object { $_.ref -notmatch '^refs/tags/mysql-cluster-' }
  $latest_valid_tag = $valid_tags[-1].ref
  $latest_valid_version = ($latest_valid_tag -split "/")[-1]

  $versiondata = Get-Version($latest_valid_version)
  $version = $versiondata.toString()

  $url = 'https://cdn.mysql.com/Downloads/MySQL-' + $versiondata.toString(2) + '/mysql-' + $version + '-winx64.zip'
  $Latest = @{ URL64 = $url; Version = $version }
  return $Latest
}

if ($MyInvocation.InvocationName -ne '.') {
  update -ChecksumFor 64
}

function global:au_AfterUpdate ($Package) {
  if ($Package.RemoteVersion -ne $Package.NuspecVersion) {
    Get-RemoteFiles -NoSuffix

    $file = [IO.Path]::Combine("tools", $Latest.FileName32)

    Write-Output "Submitting file $file to VirusTotal"

    # Assumes vt-cli Chocolatey package is installed!
    vt.exe scan file $file --apikey $env:VT_APIKEY

    Remove-Item $file -ErrorAction Ignore

    $Latest.Remove("FileName32")
  }
}
