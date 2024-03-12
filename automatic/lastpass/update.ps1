Import-Module Chocolatey-AU

$releases = 'https://lastpass.com/download'

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(^[$]url32\s*=\s*)('.*')"      = "`$1'$($Latest.URL32)'"
            "(^[$]checksum32\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
            "(^[$]checksumType32\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
            "(^[$]url64\s*=\s*)('.*')"      = "`$1'$($Latest.URL64)'"
            "(^[$]checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
            "(^[$]checksumType64\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType64)'"
        }
     }
}

function global:au_GetLatest {
    $downloadPage = Invoke-WebRequest -Uri $releases

    $downloadCard = $downloadPage.AllElements | Where-Object class -match 'card-dl' | Where-Object innerHTML -match 'universal-windows-installer'

    $version = $downloadCard | Select-String -Pattern 'Version (\d+\.\d+\.\d+)' | ForEach-Object { $_.Matches[0].Groups[1].Value };

    $url32 = 'https://download.cloud.lastpass.com/windows_installer/lastpass.exe'
    $url64 = 'https://download.cloud.lastpass.com/windows_installer/lastpass_x64.exe'

    $Latest = @{ URL32 = $url32; URL64 = $url64; Version = $version }

    return $Latest
}

update
