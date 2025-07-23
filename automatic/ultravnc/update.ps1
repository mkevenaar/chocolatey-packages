Import-Module Chocolatey-AU

$releases = 'http://www.uvnc.com/downloads/ultravnc.html'

$headers = @{
  Referer = 'https://www.uvnc.com/';
}

$options =
@{
  Headers = $headers
}

function name4url($url) {
  if ($FileNameBase) { return $FileNameBase }
  $res = $url -split '/' | Select-Object -Last 1
  $res -replace '\.[^.]+$'
}

# function global:au_BeforeUpdate { Get-RemoteFiles -NoSuffix -Purge }
function global:au_BeforeUpdate {
  $ext = $Latest.FileType
  $toolsPath = Resolve-Path tools
  $NoSuffix = $true

  Write-Host 'Purging' $ext
  Remove-Item -Force "$toolsPath\*.$ext" -ea ignore

  $Algorithm = 'sha256'

  try {
    $client = New-Object System.Net.WebClient

    $Latest.Options.Headers.GetEnumerator() | ForEach-Object { $client.Headers.Add($_.Key, $_.Value) | Out-Null }

    $base_name = name4url $Latest.Url32
    $file_name = "{0}{2}.{1}" -f $base_name, $ext, $(if ($NoSuffix) { '' } else {'_x32'})
    $file_path = "$toolsPath\$file_name"

    Write-Host "Downloading to $file_name -" $Latest.Url32
    $client.DownloadFile($Latest.URL32, $file_path)
    $Latest.Checksum32 = Get-FileHash $file_path -Algorithm $Algorithm | ForEach-Object Hash
    $Latest.ChecksumType32 = $Algorithm
    $Latest.FileName32 = $file_name

    $Latest.Options.Headers.GetEnumerator() | ForEach-Object { $client.Headers.Add($_.Key, $_.Value) | Out-Null }

    $base_name = name4url $Latest.Url64
    $file_name = "{0}{2}.{1}" -f $base_name, $ext, $(if ($NoSuffix) { '' } else {'_x64'})
    $file_path = "$toolsPath\$file_name"

    Write-Host "Downloading to $file_name -" $Latest.Url64
    $client.DownloadFile($Latest.URL64, $file_path)
    $Latest.Checksum64 = Get-FileHash $file_path -Algorithm $Algorithm | ForEach-Object Hash
    $Latest.ChecksumType64 = $Algorithm
    $Latest.FileName64 = $file_name

  } catch {
    throw $_
  } finally {
    $client.Dispose()
  }
}

function global:au_GetLatest {
    $version_page = Invoke-WebRequest -Uri $releases -UseBasicParsing

    $re = 'version: UltraVNC (.+\d)'
    $version = ([regex]::Match($version_page.content,$re)).Captures.Groups[1].value.Trim()
    $version_short = $version -replace '\.',''

    # $url32 = "https://www.uvnc.eu/download/" + $version_short + "/UltraVNC_" + ($version -replace '(\d).(\d).(\d).?(\d)?','$1_$2_$3$4') + "_X86_Setup.exe"
    # $url64 = $url32 -Replace "X86","X64"
    ## https://uvnc.eu/download/1640/UltraVNC_1640_x64_Setup.exe
    $url32 = "https://uvnc.eu/download/" + ($version -replace '(\d).(\d).(\d).?(\d)?','$1$2$3') + "0/UltraVNC_" + $version_short + "_x86_Setup.exe"
    $url64 = $url32 -Replace "x86","x64"

    $version = ($version -replace '(\d).(\d).(\d).?(\d)?','$1.$2$3$4')

    while ($version.length -lt 6) {
      $version += '0'
    }

    return @{
      URL32 = $url32
      URL64 = $url64
      Version = $version
      FileType = 'exe'
      Options = $options
  }
}

function global:au_SearchReplace {
  return @{
    ".\tools\chocolateyInstall.ps1" = @{
      "(?i)(^\s*file\s*=\s*`"[$]toolsDir\\).*"   = "`${1}$($Latest.FileName32)`""
      "(?i)(^\s*file64\s*=\s*`"[$]toolsDir\\).*" = "`${1}$($Latest.FileName64)`""
    }
    ".\legal\VERIFICATION.txt" = @{
      "(?i)(listed on\s*)\<.*\>" = "`${1}<$releases>"
      "(?i)(32-Bit.+)\<.*\>"     = "`${1}<$($Latest.URL32)>"
      "(?i)(64-Bit.+)\<.*\>"     = "`${1}<$($Latest.URL64)>"
      "(?i)(checksum type:).*"   = "`${1} $($Latest.ChecksumType32)"
      "(?i)(checksum32:).*"      = "`${1} $($Latest.Checksum32)"
      "(?i)(checksum64:).*"      = "`${1} $($Latest.Checksum64)"
    }
  }
}

if ($MyInvocation.InvocationName -ne '.') {
  update -ChecksumFor None
}
