Import-Module Chocolatey-AU

$releases = 'https://www.plex.tv/plexamp/'

function name4url($url) {
  if ($FileNameBase) { return $FileNameBase }
  $res = $url -split '/' | Select-Object -Last 1
  $res -replace '\.[^.]+$'
}

function global:au_BeforeUpdate {
  $ext = $Latest.FileType
  $toolsPath = Resolve-Path tools
  $NoSuffix = $true
  $Algorithm = 'sha256'

  $CurrentProgressPreference = $ProgressPreference
  $ProgressPreference = 'SilentlyContinue'

  Write-Host 'Purging' $ext
  $purgePath = "$toolsPath{0}*.$ext" -f [IO.Path]::DirectorySeparatorChar
  Remove-Item -Force $purgePath -ea ignore
  try {
    if ($Latest.Url64) {
      $base_name = name4url $Latest.Url64
      $file_name = "{0}{2}.{1}" -f $base_name, $ext, $(if ($NoSuffix) { '' } else { '_x64' })
      $file_name = [uri]::UnescapeDataString($file_name)
      $file_path = Join-Path $toolsPath $file_name

      Write-Host "Downloading to $file_name -" $Latest.Url64
      Invoke-WebRequest -Uri $Latest.URL64 -OutFile $file_path
      $global:Latest.Checksum64 = Get-FileHash $file_path -Algorithm $Algorithm | ForEach-Object Hash
      $global:Latest.ChecksumType64 = $Algorithm
      $global:Latest.FileName64 = $file_name
    }
  }
  catch {
    throw $_
  }
  finally {
    $ProgressPreference = $CurrentProgressPreference
  }
}
function global:au_GetLatest {
  $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing

  # https://plexamp.plex.tv/plexamp.plex.tv/desktop/Plexamp%20Setup%204.9.5.exe
  $re = '/Plexamp%20Setup%20(.*\d)\.exe'
  $url = $download_page.Links | Where-Object href -match $re | Select-Object -First 1 -expand href

  # $url = [uri]::UnescapeDataString($url)

  $version = ([regex]::Match($url, $re)).Captures.Groups[1].value

  return @{
    URL64    = $url
    Version  = $version
    FileType = 'exe'
  }
}

function global:au_SearchReplace {
  return @{
    'tools\chocolateyInstall.ps1' = @{
      "(?i)(^\s*file64\s*=\s*`"[$]toolsDir\\).*" = "`${1}$($Latest.FileName64)`""
    }
    ".\legal\VERIFICATION.txt"    = @{
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
