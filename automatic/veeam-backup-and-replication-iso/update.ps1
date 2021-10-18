Import-Module au

$releases = 'https://forums.veeam.com/veeam-backup-replication-f2/current-version-t9456.html'

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

    $reLatestbuild = "Current build is ([0-9]+\.[0-9]+\.[0-9]+(?:\.[0-9]+)(?:\.[0-9]+)?)( \((Update.*)\))?"
    $download_page.RawContent -imatch $reLatestbuild
    $version = $Matches[1]

    $isoVersion = $version

    if($Matches.ContainsKey(3)) {
        $updateVersion = $Matches[3] -replace " "
        $isoVersion = "$($isoVersion).$updateVersion"
    }

    if($version -match "11.0.1.1261") {
      $isoVersion = "11.0.1.1261_20211005"
    }

    $version = Get-Version ($version)
    $majversion = $version.ToString(1)
    
    $filename = "VeeamBackup&Replication_$($isoVersion).iso"
    $url = "https://download2.veeam.com/VBR/v$($majversion)/$($filename)"
    # -Replace ".iso", "_.iso"

    $ReleaseNotes = $download_page.Links | Where-Object href -match "release_notes" | Select-Object -First 1 -ExpandProperty href

    return @{
        Filename = $filename
        URL32 = $url
        Version = $version
        ReleaseNotes = $ReleaseNotes
    }
}

function global:au_AfterUpdate ($Package) {

  if ($Package.RemoteVersion -ne $Package.NuspecVersion) {

      Get-RemoteFiles -NoSuffix

      $file = [IO.Path]::Combine("tools", $Latest.FileName32)

      Write-Output "Submitting file $file to VirusTotal"

      # Assumes vt-cli Chocolatey package is installed!
      vt.exe scan file $file --apikey $env:VT_APIKEY

      Remove-Item $file -ErrorAction Ignore

      $Latest.Remove("FileName32")
  }
}

if ($MyInvocation.InvocationName -ne '.') {
    update -ChecksumFor 32
}
