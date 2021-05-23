Import-Module AU

$releases = 'https://api.github.com/repos/elastic/kibana/releases/latest'

function global:au_SearchReplace {
  @{
    'tools\chocolateyInstall.ps1' = @{
      "(^[$]url\s*=\s*)('.*')"          = "`$1'$($Latest.URL32)'"
      "(^[$]checksum\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum32)'"
      "(^[$]checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
      "(^[$]version\s*=\s*)`".*`""      = "`${1}`"$($Latest.Version)`""
    }
    'tools\chocolateyBeforeModify.ps1' = @{
      "(^[$]version\s*=\s*)`".*`""      = "`${1}`"$($Latest.Version)`""
    }
    "$($Latest.PackageName).nuspec" = @{
      "(?i)(^\s*\<releaseNotes\>).*(\<\/releaseNotes\>)" = "`${1}$($Latest.ReleaseNotes)`${2}"
    }
  }
}

function global:au_GetLatest {
  $header = @{
    "Authorization" = "token $env:github_api_key"
  }
  $download_page = Invoke-RestMethod -Uri $releases -Headers $header
    
  $version = $download_page.tag_name.Replace('v', '')
  $version = Get-Version($version)

  $url = "https://artifacts.elastic.co/downloads/kibana/kibana-$($version)-windows-x86_64.zip"

  $majmin = $version.toString(2)

  $releasenotes = "https://www.elastic.co/guide/en/kibana/reference/$($majmin)/release-notes-$($version).html"

  return @{
    URL32    = $url
    Version  = $version
    ReleaseNotes = $releasenotes
  }
}


if ($MyInvocation.InvocationName -ne '.') {
    update -ChecksumFor 32
}
