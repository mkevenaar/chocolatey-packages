Import-Module Chocolatey-AU

$releases = 'https://www.samsung.com/uk/support/model/MZ-V9P4T0BW/'

$headers = @{
  Referer = 'https://semiconductor.samsung.com/consumer-storage/support/tools/'
  "User-Agent" = "Chocolatey AU update check. https://chocolatey.org"
}

$options =
@{
  Headers = $headers
}

function global:au_BeforeUpdate {
  $ext = $Latest.FileType
  $toolsPath = Resolve-Path tools

  Write-Host 'Purging' $ext
  Remove-Item -Force "$toolsPath\*.$ext" -ea ignore

  $Algorithm = 'sha256'

  try {
    $client = New-Object System.Net.WebClient

    $Latest.Options.Headers.GetEnumerator() | ForEach-Object { $client.Headers.Add($_.Key, $_.Value) | Out-Null }

    $file_name = $Latest.InstallerFileName
    $file_path = "$toolsPath\$file_name"

    Write-Host "Downloading to $file_name -" $Latest.Url32
    $client.DownloadFile($Latest.URL32, $file_path)
    $Latest.Checksum32 = Get-FileHash $file_path -Algorithm $Algorithm | ForEach-Object Hash
    $Latest.ChecksumType32 = $Algorithm
    $Latest.FileName32 = $file_name
    Remove-Item -Force $file_path

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
        }
     }
}

function global:au_GetLatest {
    # The semiconductor tools page can lag behind Samsung's product support data.
    $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing
    $contents = [regex]::Match($download_page.Content, '(?s)<li\s+data-sdf-prop="contents"[^>]*>(.*?)</li>')
    if (-not $contents.Success) {
        throw 'Failed to find Samsung software download metadata.'
    }

    $downloads = [System.Net.WebUtility]::HtmlDecode($contents.Groups[1].Value) | ConvertFrom-Json
    $re = '^Samsung_Magician_Installer_Official_(\d+(?:\.\d+){1,3})\.exe$'
    $installer = $downloads.softwares | Where-Object { $_.fileName -match $re } |
        Sort-Object { [version]([regex]::Match($_.fileName, $re).Groups[1].Value) } -Descending |
        Select-Object -First 1
    if (-not $installer -or -not $installer.downloadUrl) {
        throw 'Failed to find a Samsung Magician Windows installer in the support metadata.'
    }

    $url = $installer.downloadUrl
    $version = (Get-Version ([regex]::Match($installer.fileName, $re).Groups[1].Value)).ToString()

    # Return the necessary details
    return @{
        RemoteVersion = $version
        URL32 = $url
        Version = $version
        InstallerFileName = $installer.fileName
        Options  = $options
    }
}

update -ChecksumFor none
