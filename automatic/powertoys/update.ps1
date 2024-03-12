Import-Module Chocolatey-AU

$releases = 'https://api.github.com/repos/microsoft/PowerToys/releases/latest'

function global:au_SearchReplace {
  return @{
    'tools\chocolateyInstall.ps1' = @{
      "(^[$]version\s*=\s*)`".*`""             = "`${1}`"$($Latest.RemoteVersion)`""
      "(^\s*[$]url64\s*=\s*)('.*')"                      = "`$1'$($Latest.URL64)'"
      "(^\s*[$]checksum64\s*=\s*)('.*')"                 = "`$1'$($Latest.Checksum64)'"
    }
  }
}

function global:au_BeforeUpdate { $Latest.Checksum64 = Get-RemoteChecksum $Latest.URL64 }

function global:au_GetLatest {
  $header = @{
    "Authorization" = "token $env:github_api_key"
  }
  $download_page = Invoke-RestMethod -Uri $releases -Headers $header

  $asset = $download_page.assets | Where-Object -Property name -Like "PowerToysSetup*-x64.exe"

  $version = $download_page.tag_name.Replace('v', '')
  $version = Get-Version($version)
  if ($asset) {
    $url = $asset.browser_download_url
    return @{
      URL64         = $url
      Version       = $version
      RemoteVersion = $version
      FileType      = 'exe'
    }
  }
}

if ($MyInvocation.InvocationName -ne '.') {
  update -ChecksumFor none
}
