Import-Module Chocolatey-AU

$releases = 'https://www.irfanview.com/64bit.htm'

$headers = @{
  Referer = 'https://www.irfanview.info/files/'
  "User-Agent" = "Chocolatey AU update check. https://chocolatey.org"
}

$options =
@{
  Headers = $headers
}

function global:au_SearchReplace {
  return @{
    'tools\chocolateyInstall.ps1' = @{
      "(?i)(^\s*file\s*=\s*`"[$]toolsDir\\).*"   = "`${1}$($Latest.FileName32)`""
      "(?i)(^\s*file64\s*=\s*`"[$]toolsDir\\).*" = "`${1}$($Latest.FileName64)`""
    }
    ".\legal\VERIFICATION.txt"   = @{
      "(?i)(listed on\s*)\<.*\>" = "`${1}<$($Latest.ReleaseUri)>"
      "(?i)(32-Bit.+)\<.*\>"     = "`${1}<$($Latest.URL32)>"
      "(?i)(64-Bit.+)\<.*\>"     = "`${1}<$($Latest.URL64)>"
      "(?i)(checksum type:).*"   = "`${1} $($Latest.ChecksumType32)"
      "(?i)(checksum32:).*"      = "`${1} $($Latest.Checksum32)"
      "(?i)(checksum64:).*"      = "`${1} $($Latest.Checksum64)"
    }
  }
}

function name4url($url) {
  if ($FileNameBase) { return $FileNameBase }
  $res = $url -split '/' | Select-Object -Last 1
  $res -replace '\.[^.]+$'
}

function global:au_BeforeUpdate {
  $ext = $Latest.FileType
  $toolsPath = Resolve-Path tools
  $NoSuffix = $true

  Write-Host 'Purging' $ext
  Remove-Item -Force "$toolsPath\*.$ext" -ea ignore

  $Algorithm = 'sha256'

  $CurrentProgressPreference = $ProgressPreference
  $ProgressPreference = 'SilentlyContinue'

  try {
    $client = New-Object System.Net.WebClient

    if ($Latest.Url32) {
      $base_name = name4url $Latest.URL32
      $file_name = "{0}{2}.{1}" -f $base_name, $ext, $(if ($NoSuffix) { '' } else {'_x32'})
      $file_path = Join-Path $toolsPath $file_name

      $headers32 = $headers.Clone()
      $headers32.Referer = "$($headers.Referer)$($file_name)"

      $headers32.GetEnumerator() | ForEach-Object { $client.Headers.Add($_.Key, $_.Value) | Out-Null }

      Write-Host "Downloading to $file_name -" $Latest.URL32
      $client.DownloadFile($Latest.URL32, $file_path)
      $Latest.Checksum32 = Get-FileHash $file_path -Algorithm $Algorithm | ForEach-Object Hash
      $Latest.ChecksumType32 = $Algorithm
      $Latest.FileName32 = $file_name
    }
    if ($Latest.Url64) {
      $base_name = name4url $Latest.URL64
      $file_name = "{0}{2}.{1}" -f $base_name, $ext, $(if ($NoSuffix) { '' } else {'_x64'})
      $file_path = Join-Path $toolsPath $file_name

      $headers64 = $headers.Clone()
      $headers64.Referer = "$($headers.Referer)$($file_name)"

      $headers64.GetEnumerator() | ForEach-Object { $client.Headers.Add($_.Key, $_.Value) | Out-Null }

      Write-Host "Downloading to $file_name -" $Latest.URL64
      $client.DownloadFile($Latest.URL64, $file_path)
      $Latest.Checksum64 = Get-FileHash $file_path -Algorithm $Algorithm | ForEach-Object Hash
      $Latest.ChecksumType64 = $Algorithm
      $Latest.FileName64 = $file_name
    }
  } catch {
    throw $_
  } finally {
    $client.Dispose()
    $ProgressPreference = $CurrentProgressPreference
  }
}

function global:au_AfterUpdate($Package) {
  Invoke-VirusTotalScan $Package
}

function global:au_GetLatest {
  $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing

  $re = '\(Version (.+\d),'
  $version = ([regex]::Match($download_page.content, $re)).Captures.Groups[1].value
  $fileversion = $version -replace "\."


  $url32 = "https://www.irfanview.info/files/iview${fileversion}_setup.exe"
  $url64 = "https://www.irfanview.info/files/iview${fileversion}_x64_setup.exe"

  return @{
    URL32    = $url32
    URL64    = $url64
    Version  = $version
    Options  = $options
    FileType = 'exe'
    ReleaseUri = $releases
  }
}

update -ChecksumFor None
