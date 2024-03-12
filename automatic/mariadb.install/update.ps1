Import-Module Chocolatey-AU

$releases = 'https://mariadb.org/download'
$feed = 'https://downloads.mariadb.org/rest-api/mariadb/'
$mirror = 'archive'

function name4url($url) {
  if ($FileNameBase) { return $FileNameBase }
  $res = $url -split '/' | Select-Object -Last 1
  $res -replace '\.[^.]+$'
}

function global:au_BeforeUpdate {
  $ext = $Latest.FileType
  $toolsPath = Resolve-Path tools
  $NoSuffix = $true

  $CurrentProgressPreference = $ProgressPreference
  $ProgressPreference = 'SilentlyContinue'

  Write-Host 'Purging' $ext
  $purgePath = "$toolsPath{0}*.$ext" -f [IO.Path]::DirectorySeparatorChar
  Remove-Item -Force $purgePath -ea ignore
  try {

    if ($Latest.Url32) {
      $base_name = name4url $Latest.Url32
      $file_name = "{0}{2}.{1}" -f $base_name, $ext, $(if ($NoSuffix) { '' } else {'_x32'})
      $file_path = Join-Path $toolsPath $file_name

      Write-Host "Downloading to $file_name -" $Latest.Url32
      $url32 = $Latest.URL32  + "?mirror=${mirror}"
      Invoke-WebRequest -Uri $url32 -OutFile $file_path
      (Get-MsiInformation -Path $file_path).ProductVersion
      $Latest.FileName32 = $file_name
    }

    if ($Latest.Url64) {
        $base_name = name4url $Latest.Url64
        $file_name = "{0}{2}.{1}" -f $base_name, $ext, $(if ($NoSuffix) { '' } else {'_x64'})
        $file_path = Join-Path $toolsPath $file_name

        Write-Host "Downloading to $file_name -" $Latest.Url64
        $url64 = $Latest.URL64  + "?mirror=${mirror}"
        Invoke-WebRequest -Uri $url64 -OutFile $file_path
        (Get-MsiInformation -Path $file_path).ProductVersion
        $Latest.FileName64 = $file_name
    }
  } catch {
    throw $_
  } finally {
    $ProgressPreference = $CurrentProgressPreference
  }
}

function global:au_GetLatest {
  $CurrentProgressPreference = $ProgressPreference
  $ProgressPreference = 'SilentlyContinue'

  $json = Invoke-WebRequest -Uri $feed -UseBasicParsing  | ConvertFrom-Json

  $streams = @{ }

  $major_releases = $json.major_releases

  foreach ($major_release in $major_releases) {

    $streamVersion = $major_release.release_id

    $release_data_feed = "https://downloads.mariadb.org/rest-api/mariadb/${streamVersion}/"
    $release_json = Invoke-WebRequest -Uri $release_data_feed -UseBasicParsing  | ConvertFrom-Json

    $releaseversion = $release_json.releases.psobject.properties.name | Select-Object -First 1

    if (-not $major_release.release_status -eq 'Stable' -or -not $major_release.release_status -eq 'Old Stable' ) {
      $version = ($release_json.releases.psobject.properties.name | Select-Object -First 1) + "-" + $major_release.release_status
      $releaseversion = Get-Version($version)
    }

    $64bit = $release_json.releases.$releaseversion.files | Where-Object { ($_.os -eq "Windows") -and ($_.package_type -eq "MSI Package") -and ($_.cpu -eq "x86_64") }

    $releaseNotes = $release_json.releases.$releaseversion.release_notes_url

    if('' -eq $releaseNotes) {
      $releasenotesversion = $releaseversion -replace "\."
      $releaseNotes = "https://mariadb.com/kb/en/mariadb-${releasenotesversion}-release-notes/"
    }

    $Result = @{
      Version        = $releaseversion
      URL64          = $64bit.file_download_url
      Checksum64     = $64bit.checksum.sha256sum
      ChecksumType64 = 'sha256'
      ReleaseNotes   = $releaseNotes
      FileType       = 'msi'
    }
    if (-not $null -eq $64bit.file_name) {
      $streams.Add($streamVersion, $Result)
    }
  }

  $ProgressPreference = $CurrentProgressPreference
  return @{ Streams = $streams }
}

function global:au_SearchReplace {
  return @{
    ".\tools\chocolateyInstall.ps1" = @{
      "(?i)(^\s*file64\s*=\s*`"[$]toolsDir\\).*" = "`${1}$($Latest.FileName64)`""
    }
    ".\legal\VERIFICATION.txt" = @{
      "(?i)(listed on\s*)\<.*\>" = "`${1}<$releases>"
      "(?i)(64-Bit.+)\<.*\>"     = "`${1}<$($Latest.URL64)>"
      "(?i)(checksum type:).*"   = "`${1} $($Latest.ChecksumType64)"
      "(?i)(checksum64:).*"      = "`${1} $($Latest.Checksum64)"
    }
    "$($Latest.PackageName).nuspec" = @{
      "(?i)(^\s*\<releaseNotes\>).*(\<\/releaseNotes\>)" = "`${1}$($Latest.ReleaseNotes)`${2}"
    }

  }
}

if ($MyInvocation.InvocationName -ne '.') {
  update -ChecksumFor None -NoCheckUrl
}
