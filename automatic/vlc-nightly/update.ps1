Import-Module Chocolatey-AU
$releases = 'https://artifacts.videolan.org'

function global:au_SearchReplace {
   @{
        ".\legal\VERIFICATION.txt" = @{
          "(?i)(\s+x64:).*"            = "`${1} $($Latest.URL64)"
          "(?i)(checksum64:).*"        = "`${1} $($Latest.Checksum64)"
          "(?i)(Get-RemoteChecksum).*" = "`${1} $($Latest.URL64)"
        }
    }
}

function global:au_BeforeUpdate { Get-RemoteFiles -Purge }

function CreateStream {
  param([uri]$url64bit, [version]$version)

  $Result = @{
    Version      = $version
    URL64        = $url64bit
  }

  return $Result
}

function global:au_GetLatest {
  $date = Get-Date  -Format yyyyMM

  $streams = @{ }

  $re    = '\.exe$'

  $folders = @(
    "/vlc/nightly-win64/"
    "/vlc-3.0/nightly-win64/"
  )

  foreach ($folder in $folders) {
    $download_page64 = Invoke-WebRequest -Uri "$releases$folder" -UseBasicParsing

    $folder64Bits = $download_page64.links | Where-Object href -Match "$date" | Select-Object -first 1

    $folder64Bits | Sort-Object | Foreach-Object {
      # Get the version number from the current folder
      [regex]$dotre = '\.'

      # 64 bit
      $64bitFolder = $_.href
      $64bitFolderUrl = $releases + $folder + $64bitFolder
      $64bitFiles = Invoke-WebRequest -Uri $64bitFolderUrl -UseBasicParsing
      $filename64 = $64bitFiles.links | Where-Object href -Match $re | Select-Object -ExpandProperty href
      $url64bit = $releases + $folder + $64bitFolder + $filename64

      $version = $filename64 -split '-' | Select-Object -first 1 -Skip 1
      $chocoDate = $_.href -split '-' | Select-Object -first 1

      if ( $dotre.matches($version).count -eq 2 ) {
        $version = $version + "."
      }

      $chocoVersion = $version + $chocoDate

      $streams.Add((Get-Version $version).ToString(2), (CreateStream $url64Bit $chocoVersion))

    } | Out-Null

  }

  return @{ Streams = $streams }
}

update -ChecksumFor none
