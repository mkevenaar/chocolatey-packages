import-module au
$releases = 'https://nightlies.videolan.org'

function global:au_SearchReplace {
   @{
        ".\legal\VERIFICATION.txt" = @{
          "(?i)(\s+x32:).*"            = "`${1} $($Latest.URL32)"
          "(?i)(\s+x64:).*"            = "`${1} $($Latest.URL64)"
          "(?i)(checksum32:).*"        = "`${1} $($Latest.Checksum32)"
          "(?i)(checksum64:).*"        = "`${1} $($Latest.Checksum64)"
          "(?i)(Get-RemoteChecksum).*" = "`${1} $($Latest.URL64)"
        }
    }
}

function global:au_BeforeUpdate { Get-RemoteFiles -Purge }

function CreateStream {
  param([uri]$url32Bit, [uri]$url64bit, [version]$version)

  $Result = @{
    Version      = $version
    URL32        = $url32bit
    URL64        = $url64bit
  }

  return $Result
}

function global:au_GetLatest {
  $date = Get-Date  -Format yyyyMMdd
  #win32
  $download_page32 = Invoke-WebRequest -Uri "$releases/build/win32/" -UseBasicParsing
  #win64
  $download_page64 = Invoke-WebRequest -Uri "$releases/build/win64/" -UseBasicParsing
  
  $folder32Bits = $download_page32.links | Where-Object href -Match "vlc-.+$date"
  $folder64Bits = $download_page64.links | Where-Object href -Match "vlc-.+$date"

  $re    = '\.exe$'

  $streams = @{ }

  $folder64Bits | Sort-Object | Foreach-Object {
    # Get the version number from the current folder
    $version = $_ -split '-' | Select-Object -first 1 -Skip 1
    $chocoVersion = $version + "." + $date

    # 32 bit
    $32bitFolder = $folder32Bits | Where-Object href -match $version | Select-Object -First 1 -ExpandProperty href
    $32bitFolderUrl = $releases + "/build/win32/" + $32bitFolder
    $32bitFiles = Invoke-WebRequest -Uri $32bitFolderUrl -UseBasicParsing
    $filename32 = $32bitFiles.links | Where-Object href -Match $re | Select-Object -ExpandProperty href
    $url32bit = $releases + "/build/win32/" + $32bitFolder + $filename32

    # 64 bit
    $64bitFolder = $_.href
    $64bitFolderUrl = $releases + "/build/win64/" + $64bitFolder
    $64bitFiles = Invoke-WebRequest -Uri $64bitFolderUrl -UseBasicParsing
    $filename64 = $64bitFiles.links | Where-Object href -Match $re | Select-Object -ExpandProperty href
    $url64bit = $releases + "/build/win64/" + $64bitFolder + $filename64

    if($filename32 -and $filename64) {
      $streams.Add((Get-Version $version).ToString(2), (CreateStream $url32bit $url64Bit $chocoVersion))
    }

  } | Out-Null

  return @{ Streams = $streams }
}

update -ChecksumFor none
