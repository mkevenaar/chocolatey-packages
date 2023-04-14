import-module au

$releases = 'http://www.dymo.com/en-US/online-support'

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
    $ScraperAPIKey = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    $ScraperURL = 'https://api.scrapingrobot.com/?token=' + $ScraperAPIKey
    $body = @{
      "url"= "https://www.dymo.com/support?cfid=user-guide"
      "module"= "HtmlChromeScraper"
    }
    $response = Invoke-RestMethod -Uri $ScraperURL -Method "post" -Body ($body | convertto-json) -ContentType "application/json" -UseBasicParsing
    ($response.result -match '<a class="btn btn-secondary btn-secondary-arrow" data-ext="exe" href="https://s3.amazonaws.com/download.dymo.com/dymo/Software/Win/DCDSetup(?<softwareversion>.*).exe">Download <span></span></a></div></div>')    
         [string]$Version = $matches.softwareversion
         $Filename = "DCDSetup" + $Version + ".exe"
         $url = "https://s3.amazonaws.com/download.dymo.com/dymo/Software/Win/" + $filename

    return @{
      URL32 = $url
      Version = $version
    }
}

if ($MyInvocation.InvocationName -ne '.') {
    update -ChecksumFor 32
}