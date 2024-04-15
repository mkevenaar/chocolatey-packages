Import-Module Chocolatey-AU

$releases = 'https://www.irfanview.com/plugins.htm'

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
    }
    ".\legal\VERIFICATION.txt"   = @{
      "(?i)(listed on\s*)\<.*\>" = "`${1}<$($Latest.ReleaseUri)>"
      "(?i)(32-Bit.+)\<.*\>"     = "`${1}<$($Latest.URL32)>"
      "(?i)(checksum type:).*"   = "`${1} $($Latest.ChecksumType32)"
      "(?i)(checksum32:).*"      = "`${1} $($Latest.Checksum32)"
    }
    "$($Latest.PackageName).nuspec" = @{
      "(\<dependency .+?`"irfanview`" version=)`"([^`"]+)`"" = "`$1`"$($Latest.PluginVersion)`""
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

  $re = '\(current version: (.+\d)\)'
  $version = ([regex]::Match($download_page.content, $re)).Captures.Groups[1].value

  $pluginRe = '<p><strong>The current PlugIns version is: (.+\d)</strong>'
  $pluginVersion = ([regex]::Match($download_page.content, $pluginRe)).Captures.Groups[1].value

  $url32 = "https://www.irfanview.info/files/irfanview_shell_extension.zip"

  return @{
    URL32    = $url32
    Version  = $version
    Options  = $options
    FileType = 'zip'
    PluginVersion = $pluginVersion
    ReleaseUri = $releases    
  }
}

update -ChecksumFor None
