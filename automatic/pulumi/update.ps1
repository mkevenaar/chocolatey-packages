Import-Module au

function global:au_BeforeUpdate { Get-RemoteFiles -NoSuffix -Purge }

function global:au_GetLatest {
  $version = (Invoke-WebRequest -UseBasicParsing https://www.pulumi.com/latest-version).Content.Trim() -Replace "beta\.", "beta"

  $url = "https://get.pulumi.com/releases/sdk/pulumi-v${version}-windows-x64.zip"

  return @{
      URL64 = $url
      Version = $version
      FileType = 'zip'
  }
}

function global:au_SearchReplace {
  return @{
    ".\tools\chocolateyInstall.ps1" = @{
      "(?i)(^\s*file64\s*=\s*`"[$]toolsDir\\).*"   = "`${1}$($Latest.FileName64)`""
    }
    ".\legal\VERIFICATION.txt" = @{
      "(?i)(listed on\s*)\<.*\>" = "`${1}<$releases>"
      "(?i)(64-Bit.+)\<.*\>"     = "`${1}<$($Latest.URL64)>"
      "(?i)(checksum type:).*"   = "`${1} $($Latest.ChecksumType64)"
      "(?i)(checksum64:).*"      = "`${1} $($Latest.Checksum64)"
    }
  }
}

if ($MyInvocation.InvocationName -ne '.') {
  update -ChecksumFor None
}
