Import-Module au

$releases = 'https://api.github.com/repos/microsoft/terminal/releases' # should variable name change?: releases_page instead of releases

function global:au_BeforeUpdate { Get-RemoteFiles -NoSuffix -Purge }

function global:au_GetLatest {
    $download_page = Invoke-RestMethod -Uri $releases # should variable name change?: releases instead of download_page
    forEach ($release in $download_page){
        if (!$release.prerelease) {
            $version = $release.tag_name.Remove(0,1) # Removes the character v from the tag_name
            $url = $release.assets.browser_download_url
            break
        }
    }
    return @{
        URL32 = $url
        Version = $version
        RemoteVersion  = $version
        FileType = 'msixbundle'
    }
}

function global:au_SearchReplace {
  return @{
    ".\tools\chocolateyInstall.ps1" = @{
      "(^[$]fileName\s*=\s*`"[$]toolsDir\\).*" = "`${1}$($Latest.FileName32)`""
      "(^[$]version\s*=\s*)`".*`""             = "`${1}`"$($Latest.RemoteVersion)`""
    }
    ".\legal\VERIFICATION.txt" = @{
      "(?i)(listed on\s*)\<.*\>" = "`${1}<$releases>"
      "(?i)(32-Bit.+)\<.*\>"     = "`${1}<$($Latest.URL32)>"
      "(?i)(checksum type:).*"   = "`${1} $($Latest.ChecksumType32)"
      "(?i)(checksum32:).*"      = "`${1} $($Latest.Checksum32)"
    }
  }
}

if ($MyInvocation.InvocationName -ne '.') {
  update -ChecksumFor None
}
