Import-Module Chocolatey-AU

$releases = 'https://semiconductor.samsung.com/consumer-storage/support/tools/'

$headers = @{
  Referer = 'https://semiconductor.samsung.com/consumer-storage/support/tools/'
  "User-Agent" = "Chocolatey AU update check. https://chocolatey.org"
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

  } catch {
    throw $_
  } finally {
    $client.Dispose()
  }
}


function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(^[$]url\s*=\s*)('.*')"      = "`$1'$($Latest.URL32)'"
            "(^[$]checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
            "(^[$]checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
            "(^\[version\] [$]softwareVersion\s*=\s*)('.*')" = "`$1'$($Latest.RemoteVersion)'"
        }
     }
}

function global:au_GetLatest {
    $download_page = Invoke-WebRequest -Uri $releases

    $re  = "Samsung_Magician_[iI]nstaller_Official_(.+).exe"

    $url = $download_page.links | Where-Object href -match $re | Select-Object -First 1 -expand href

    $version = (([regex]::Match($url,$re)).Captures.Groups[1].value)
    $version = (Get-Version $version).ToString()

    return @{
        RemoteVersion = $version
        URL32 = $url
        Version = $version
        Options  = $options
    }
}

update -ChecksumFor none
