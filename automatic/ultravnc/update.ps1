Import-Module AU

$releases = 'http://www.uvnc.com/downloads/ultravnc.html'

$headers = @{
  Referer = 'https://www.uvnc.com/';
}

$options =
@{
  Headers = $headers
}


function global:au_SearchReplace {
    @{
        '.\tools\chocolateyInstall.ps1' = @{
            "(^[$]url64\s*=\s*)('.*')"      = "`$1'$($Latest.URL64)'"
            "(^[$]url32\s*=\s*)('.*')"      = "`$1'$($Latest.URL32)'"
            "(^[$]checksum32\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
            "(^[$]checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
            "(^[$]checksumType32\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
            "(^[$]checksumType64\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType64)'"
        }
     }
}

function global:au_BeforeUpdate {
  $Latest.Checksum32 = Get-RemoteChecksum $Latest.URL32 -Headers $headers
  $Latest.ChecksumType32 = 'sha256'
  $Latest.Checksum64 = Get-RemoteChecksum $Latest.URL64 -Headers $headers
  $Latest.ChecksumType64 = 'sha256'
}

function global:au_GetLatest {
    $version_page = Invoke-WebRequest -Uri $releases

    $re = 'ultravnc\s+([\d.]+)'
    $version = ([regex]::Match(($version_page.Links | Where-Object innerhtml -match $re | Select-Object -First 1 -expand innerhtml),$re)).Groups[1].value
    $version_short = $version -replace '\.',''

    $url32 = "https://www.uvnc.eu/download/" + $version_short + "/UltraVNC_" + ($version -replace '(\d).(\d).(\d).(\d)','$1_$2_$3$4') + "_X86_Setup.exe"
    $url64 = $url32 -Replace "X86","X64"

    $version = ($version -replace '(\d).(\d).(\d).(\d)','$1.$2$3$4') + '0'

    return @{
      URL32 = $url32
      URL64 = $url64
      Version = $version
      Options = $options
  }
}

if ($MyInvocation.InvocationName -ne '.') {
  update -ChecksumFor none
}

