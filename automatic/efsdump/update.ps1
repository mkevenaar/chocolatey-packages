import-module au

$releases = 'https://learn.microsoft.com/en-us/sysinternals/downloads/efsdump'
$download = 'https://download.sysinternals.com/files/EFSDump.zip'

$reVersion = '(v)(?<Version>(\d+\.\d+))'

function global:au_SearchReplace {
  @{
    'tools\chocolateyInstall.ps1' = @{
      "(^[$]url\s*=\s*)('.*')"          = "`$1'$($Latest.URL32)'"
      "(^[$]checksum\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum32)'"
      "(^[$]checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
    }
  }
}

function global:au_GetLatest {
  $downloadPage = Invoke-WebRequest -Uri $releases -UseBasicParsing

  $version = $downloadPage.Content -match $reversion | foreach-object { $Matches.Version }

  return @{
    Version = $version
    URL32 = $download
  }
}

if ($MyInvocation.InvocationName -ne '.') {
    update -ChecksumFor 32
}
