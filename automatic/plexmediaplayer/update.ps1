Import-Module Chocolatey-AU

$timestamp = [DateTimeOffset]::UtcNow.ToUnixTimeMilliseconds()

$feed_url = 'https://plex.tv/pms/downloads/3.json?_=' + $timestamp

function global:au_SearchReplace {
  @{
    'tools\chocolateyInstall.ps1' = @{
      "(^[$]url64\s*=\s*)('.*')"          = "`$1'$($Latest.URL64)'"
      "(^[$]checksum64\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum64)'"
      "(^[$]checksumType64\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType64)'"
    }
  }
}

function global:au_GetLatest {
  $json = Invoke-RestMethod -Uri $feed_url

  $version = $json.computer.windows.version
  $version = Get-Version($version)
  $version.prerelease = $null

  $url64 = ($json.computer.windows.releases | Where-Object -Property build -eq windows-x86_64).url

    return @{
        URL64 = $url64
        Version = $version
    }
}

update -ChecksumFor 64
