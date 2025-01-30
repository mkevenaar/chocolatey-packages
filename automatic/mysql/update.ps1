Import-Module Chocolatey-AU

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

function CreateStream {
  param($url64bit, $version)

  $Result = @{
    Version  = $version
    URL64    = $url64bit
    FileType = 'zip'
  }

  return $Result
}

function global:au_GetLatest {
  $header = @{
    "Authorization" = "token $env:github_api_key"
  }
  $download_page = Invoke-RestMethod -Uri $releases -Headers $header

  $streams = @{ }

  $tags = $download_page | Where-Object { $_.ref -match '^refs/tags/mysql-[0-9.]+$' } | Sort-Object -Property ref -Descending

  foreach ($tag in $tags) {
    $version = ($tag -split "/")[-1]

    $versiondata = Get-Version($version)
    $version = $versiondata.toString()
    $majmin = $versiondata.toString(2)

    $url = 'https://cdn.mysql.com/Downloads/MySQL-' + $majmin + '/mysql-' + $version + '-winx64.zip'

    if (!$streams.ContainsKey("$majmin")) {
      try {
        Get-RedirectedUrl $url
      }
      catch {
        # Ignore the missing versions.
        continue
      }
      $streams.Add($majmin, (CreateStream $url $version $releaseNotes))
    }
  }
  return  @{ Streams = $streams }
}

if ($MyInvocation.InvocationName -ne '.') {
  update -ChecksumFor 64
}

function global:au_AfterUpdate($Package) {
  Invoke-VirusTotalScan $Package
}
