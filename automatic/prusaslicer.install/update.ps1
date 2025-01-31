Import-Module Chocolatey-AU

$releases = "https://cache.prusa3d.com/help/api/v1/prusa3d_downloads?orderby=created&order=desc&lng=en&tag=mk4&posts_per_page=10"
$downloadUrl = "https://www.prusa3d.com/slic3r-prusa-edition/"

function global:au_SearchReplace {
  @{
    ".\tools\chocolateyInstall.ps1" = @{
      "(?i)(^\s*file\s*=\s*`"[$]toolsDir\\).*"   = "`${1}$($Latest.FileName64)`""
    }
    "$($Latest.PackageName).nuspec" = @{
      "(?i)(^\s*\<releaseNotes\>).*(\<\/releaseNotes\>)" = "`${1}$($Latest.ReleaseNotes)`${2}"
    }

    ".\legal\VERIFICATION.txt" = @{
      "(?i)(listed on\s*)\<.*\>" = "`${1}<$downloadUrl>"
      "(?i)(64-Bit.+)\<.*\>"     = "`${1}<$($Latest.URL64)>"
      "(?i)(checksum type:).*"   = "`${1} $($Latest.ChecksumType64)"
      "(?i)(checksum64:).*"      = "`${1} $($Latest.Checksum64)"
    }
  }
}

function global:au_AfterUpdate($Package) {
  Invoke-VirusTotalScan $Package
}

function global:au_BeforeUpdate {
  Get-RemoteFiles -Purge
}

function global:au_GetLatest {

  $json = Invoke-RestMethod -Uri $releases
  $data = $json.data | Where-Object { $_.meta.type.value -eq 'driver' } | Select-Object -First 1
  $files = $data.meta.files | Where-Object { $_.platform -eq 'win' }
  $url = $files.file_url
  $version = Get-Version($data.title)

  @{
    URL64        = $url
    Version      = $version
    ReleaseNotes = "https://github.com/prusa3d/PrusaSlicer/releases/tag/version_${version}"
  }
}

update -ChecksumFor none
