Import-Module Chocolatey-AU

$releases = 'https://www.veeam.com/download-version.html'
$releaseNotesFeed = 'https://www.veeam.com/services/veeam/technical-documents?resourceType=resourcetype:techdoc/releasenotes&productId=8'
$productName = 'Veeam Backup &amp; Replication'

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

function Get-VeeamKBPages {
[cmdletbinding()]
param(
    [object]$Uri,
    [regex]$regKB,
    [version]$num,
    [string]$productName
)
    "variable check`r`nUri -$Uri-`r`nnum -$num-`r`nproductName -$productName-" | Write-Verbose
    $header = @{
        "User-Agent" = "Chocolatey AU update check. https://chocolatey.org"
    }
    $version = ($num -join ".")
    $Data = (Invoke-WebRequest -UseBasicParsing -Uri $Uri -Headers $header)
    if ($Data.Content -match 'div') {
        "Content uses div" | Write-Verbose
        $DataHTML = ($Data.Content) -split('div')
    }
    if (!([string]::IsNullOrEmpty( ($DataHTML -match "This update has been superseded by") )) ) {
        "Page has been Superseded returning page url" | Write-Warning
        ($DataHTML -match "This update has been superseded by") | % { if ($_ -match $regKB) { $Matches } } | Select-Object -First 1 | Out-Null
        if (!([string]::IsNullOrEmpty( $Matches )) ) {
            "H Match is Good" | Write-Verbose
            $SupSubhref = ($Matches[0])
            Clear-Variable Matches
        }
    } else {
        "No Superseded trying Links -$($Data.Links)-" | Write-Verbose
        $SupSubhref = (($Data.Links -match $regKB | Select-Object -First 1).href)
    }
    "SupSubhref -$SupSubhref-" | Write-Verbose
    if (!([string]::IsNullOrEmpty($SupSubhref)) ) { 
        "found a kb of -$SupSubhref-"  | Write-Verbose
        $neqo = $SupSubhref
        "changing to new variable -$neqo-" | Write-Verbose
         }
    try {
        "Normal Page found looking for Download Information" | Write-Verbose
        $subVersion = (($DataHTML) | % { if ($_ -match '(_\d{8}(?:.zip))') { $Matches[0] } })
        Clear-Variable Matches
        "Found -$subVersion-" | Write-Verbose
        $SupSubhref = ($subVersion -replace('.zip',''))
        "cleanup of -$subVersion- to -$SupSubhref-" | Write-Verbose
    }
    catch { }
    
    if ((!([string]::IsNullOrEmpty($neqo)) ) -and (!([string]::IsNullOrEmpty($SupSubhref)) )) {
        "Both variables are Not Null Or Empty `r`n This Should NOT happen exiting now" | Write-Warning
        if ( ($neqo -match $regKB) -and ($SupSubhref -match ((Get-Date).year)) ) {
            "SupSubhref -$SupSubhref- matches current year while previous -$neqo-. returning yearmonthdate"  | Write-Verbose
            return $SupSubhref
        } else {
            "SupSubhref -$SupSubhref- does NOT match current year while previous -$neqo-. returning kb"  | Write-Verbose
            return $neqo
        }
    }
    if ((([string]::IsNullOrEmpty($neqo)) ) -and (([string]::IsNullOrEmpty($SupSubhref)) )) {
        "Both variables are Null Or Empty `r`n This Should NOT happen exiting now" | Write-Warning
        break
    }
    if ((!([string]::IsNullOrEmpty($neqo)) ) -and (([string]::IsNullOrEmpty($SupSubhref)) )) {
        "Try/Catch failed to get data returning -$neqo-" | Write-Verbose
        return $neqo
    }
    if ((([string]::IsNullOrEmpty($neqo)) ) -and (!([string]::IsNullOrEmpty($SupSubhref)) )) {
        "Try/Catch Found data returning -$SupSubhref-" | Write-Verbose
        return $SupSubhref
    }
}

function global:au_GetLatest {
      $header = @{
		"User-Agent" = "Chocolatey AU update check. https://chocolatey.org"
	}
    $CurrentProgressPreference = $ProgressPreference
    $ProgressPreference = 'SilentlyContinue'

    $download_page = Invoke-WebRequest -Uri $releases -DisableKeepAlive -Headers $header
    $data = $download_page.ParsedHtml.getElementsByTagName('tbody') | Where-Object innerhtml -Match $productName

    $re = "Version\s+:\s+([0-9]+\.[0-9]+\.[0-9]+(?:\.[0-9]+)(?:\.[0-9]+)?)"

    ($data.innerHTML | Select-Object -First 1) -imatch $re
    if (!([string]::IsNullOrEmpty( $Matches )) ) {
        $version =  [version]$Matches[1]
        Clear-Variable Matches
    }

    "version -$version-" | Write-Host

    $regex = "(https\:\/\/www\.\w{5}\.\w{3}\/kb\d{4,8})"
    $data.innerHTML | % { if ($_ -match $regex) { $Matches } } | Select-Object -First 1 | Out-Null
    if (!([string]::IsNullOrEmpty( $Matches )) ) {
        $isohref = $Matches[1]
        Clear-Variable Matches
    }

    "isohref -$isohref-" | Write-Host

    ( Get-VeeamKBPages -uri $isohref -productName $productName -regKB $regex -num $version -OutVariable "isoSubVersion")

    do {
        "found a kb page and not the isoSubVersion -$isoSubVersion-" | Write-Warning
        ( Get-VeeamKBPages -uri $isoSubVersion[0] -productName $productName -regKB $regex -num $version -OutVariable "isoSubVersion")
    }
    while  (!([string]::IsNullOrEmpty( ($isoSubVersion -match $regex) )) )

    if (!([string]::IsNullOrEmpty($isoSubVersion)) ) {
        $isoVersion = "${Version}${isoSubVersion}"
    } else {
        $isoVersion = $version
    }

    $version = Get-Version ($version)
    $majversion = $version.ToString(1)

    $filename = "VeeamBackup&Replication_$($isoVersion).iso"
    $url = "https://download2.veeam.com/VBR/v$($majversion)/$($filename)"

    $releaseNotesPage = Invoke-WebRequest $releaseNotesFeed | ConvertFrom-Json

    $ReleaseNotes = $releaseNotesPage.payload.products[0].documentGroups[0].documents[0].links.pdf

    $ProgressPreference = $CurrentProgressPreference

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
