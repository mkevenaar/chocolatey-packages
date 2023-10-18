Import-Module au

$releases = 'https://cdn.zabbix.com/zabbix/binaries/stable/'

function global:au_SearchReplace {
  @{
    ".\tools\chocolateyInstall.ps1" = @{
      "(?i)(^\s*file\s*=\s*`"[$]toolsDir\\).*" = "`${1}$($Latest.FileName32)`""
      "(?i)(^\s*file64\s*=\s*`"[$]toolsDir\\).*" = "`${1}$($Latest.FileName64)`""
    }

    ".\legal\VERIFICATION.txt" = @{
      "(?i)(x32\surl:).*"                = "`${1} $($Latest.URL32)"
      "(?i)(x64\surl:).*"                = "`${1} $($Latest.URL64)"
      "(?i)(checksum32:).*"              = "`${1} $($Latest.Checksum32)"
      "(?i)(checksum64:).*"              = "`${1} $($Latest.Checksum64)"
      "(?i)(x32:\sGet-RemoteChecksum).*" = "`${1} $($Latest.URL32)"
      "(?i)(x64:\sGet-RemoteChecksum).*" = "`${1} $($Latest.URL64)"
    }
  }
}

function global:au_BeforeUpdate { Get-RemoteFiles -NoSuffix -Purge }

function CreateStream {
  param($url32bit, $url64bit, $version)

  $Result = @{
    Version = $version
    URL32   = $url32bit
    URL64   = $url64bit
  }

  return $Result
}

function global:au_GetLatest {

  $download_page = Invoke-WebRequest -UseBasicParsing -Uri $releases
  $majVersions = $download_page.links | Where-Object href -match "\d\.\d"

  $streams = @{ }

  $majVersions | Sort-Object -Descending | ForEach-Object {
    try {
      $majVersionFolder = $_.href
      $version_download_page = Invoke-WebRequest -UseBasicParsing -Uri "$releases$majVersionFolder"
      $majVersion = Get-Version $majVersionFolder
      $version = $version_download_page.Links | Where-Object -Property href -Match $majVersion|  Select-Object -ExpandProperty href | ForEach-Object{ Get-Version ($_) } | Sort-Object | Select-Object -Last 1

      $url32Bit = "${releases}${majVersionFolder}${version}/zabbix_agent2-${version}-windows-i386-openssl.msi"
      $url64Bit = "${releases}${majVersionFolder}${version}/zabbix_agent2-${version}-windows-amd64-openssl.msi"

      $response32 = Invoke-WebRequest -Uri $url32Bit -UseBasicParsing -Method Head
      $response64 = Invoke-WebRequest -Uri $url64Bit -UseBasicParsing -Method Head

      if ($response32.StatusCode -eq 200 -and $response64.StatusCode -eq 200) {
        $streams.Add((Get-Version $version).ToString(2), (CreateStream $url32Bit $url64Bit $version))
      }
    } catch {
      Write-Host "Failed to update ${_.href}"
    }
  }

  return @{ Streams = $streams }
}

if ($MyInvocation.InvocationName -ne '.') {
  update -ChecksumFor None
}
