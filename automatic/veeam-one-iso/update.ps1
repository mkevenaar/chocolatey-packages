Import-Module au

$releases = 'https://forums.veeam.com/veeam-one-f28/current-version-t11604.html'

function global:au_SearchReplace {
  @{
    'tools\chocolateyInstall.ps1' = @{
      "(^[$]filename\s*=\s*)('.*')"     = "`$1'$($Latest.Filename)'"
      "(^[$]url\s*=\s*)('.*')"          = "`$1'$($Latest.URL32)'"
      "(^[$]checksum\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum32)'"
      "(^[$]checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
    }
    "$($Latest.PackageName).nuspec" = @{
      "(?i)(^\s*\<releaseNotes\>).*(\<\/releaseNotes\>)" = "`${1}$($Latest.ReleaseNotes)`${2}"
    }
  }
}

function global:au_GetLatest {
    $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing -DisableKeepAlive

    $reLatestbuild = "Current version is ([0-9]+\.[0-9]+\.[0-9]+(?:\.[0-9]+)(?:\.[0-9]+)?)( \((Update.*)\))?"
    $download_page.RawContent -imatch $reLatestbuild
    $version = $Matches[1]

    $isoVersion = $version

    if($Matches.ContainsKey(3)) {
        $updateVersion = $Matches[3] -replace " "
        $isoVersion = "$($isoVersion).$updateVersion"
    }

    $filename = "VeeamONE.$($isoVersion).iso"
    $url = "https://download2.veeam.com/$($filename)"
    # -Replace ".iso", "_.iso"

    if($version -match "10.0.2.1094") {
      $url = 'https://download2.veeam.com/VeeamONE_10.0.2.1094_20200716.iso'
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
