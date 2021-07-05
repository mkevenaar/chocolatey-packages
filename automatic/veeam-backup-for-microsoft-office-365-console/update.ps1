Import-Module au

$releases = 'https://forums.veeam.com/veeam-backup-for-microsoft-office-365-f47/current-version-t39185.html'

function global:au_SearchReplace {
  @{
    'tools\chocolateyInstall.ps1' = @{
      "(^[$]url\s*=\s*)('.*')"          = "`$1'$($Latest.URL32)'"
      "(^[$]checksum\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum32)'"
      "(^[$]checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
      "(^[$]version\s*=\s*)('.*')"      = "`$1'$($Latest.version)'"

    }
    "$($Latest.PackageName).nuspec" = @{
      "(?i)(^\s*\<releaseNotes\>).*(\<\/releaseNotes\>)" = "`${1}$($Latest.ReleaseNotes)`${2}"
    }
  }
}

function global:au_GetLatest {
    $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing -DisableKeepAlive

    $reLatestbuild = "Current build is ([0-9]+\.[0-9]+\.[0-9]+(?:\.[0-9]+)(?:\.[0-9]+)?)( \((Update.*)\))?"
    $download_page.RawContent -imatch $reLatestbuild
    $version = $Matches[1]

    $isoVersion = $version

    if($Matches.ContainsKey(3)) {
        $updateVersion = $Matches[3] -replace " "
        $isoVersion = "$($isoVersion).$updateVersion"
    }

    $version = Get-Version ($version)
    $majversion = $version.ToString(1)

    $filename = "VeeamBackupOffice365_$($isoVersion).zip"
    $url = "https://download2.veeam.com/VBO/v$($majversion)/$($filename)"
    # -Replace ".iso", "_.iso"

    if($isoVersion -eq "5.0.1.252") {
      $url = "https://download2.veeam.com/VeeamKB/4158/VeeamBackupOffice365_5.0.1.252_KB4158.zip"
    }

    $ReleaseNotes = $download_page.Links | Where-Object href -match "release_notes" | Select-Object -First 1 -ExpandProperty href

    return @{
        Filename = $filename
        URL32 = $url
        Version = $version
        ReleaseNotes = $ReleaseNotes
    }
}

if ($MyInvocation.InvocationName -ne '.') {
    update -ChecksumFor 32
}
