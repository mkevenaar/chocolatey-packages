Import-Module Chocolatey-AU
. $PSScriptRoot\update_helpers.ps1

$releases = 'https://www.enterprisedb.com/download-postgresql-binaries'

function global:au_SearchReplace {

  if ($Latest.PackageName -eq 'psql') {
    return @{
      ".\psql.nuspec" = @{
        "\<file .+?/>"                           = '<file src="tools\*.dummy" target="tools" />'
        "\<dependency .+?/>"                     = '<dependency id="{0}" version="[{1}]" />' -f $Latest.Dependency, $Latest.Version
        "(\<releaseNotes\>).*?(\</releaseNotes\>)" = "`${1}$($Latest.ReleaseNotes)`$2"
        "(\<docsUrl\>).*?(\</docsUrl\>)"           = "`${1}$($Latest.DocsUrl)`$2"
      }
    }
  }
  @{
    ".\tools\chocolateyinstall.ps1" = @{
      "(?i)(^\s*url64\s*=\s*)('.*')"          = "`$1'$($Latest.URL64)'"
      "(?i)(^\s*checksum64\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum64)'"
      "(?i)(^\s*checksumType64\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType64)'"
    }
    ".\psql.nuspec"                = @{
      "(\<releaseNotes\>).*?(\</releaseNotes\>)" = "`${1}$($Latest.ReleaseNotes)`$2"
      "(\<docsUrl\>).*?(\</docsUrl\>)"           = "`${1}$($Latest.DocsUrl)`$2"
      "\<file .+?/>"                           = '<file src="tools\**" target="tools" />'
      "\<dependency .+?/>"                     = '<dependency id="vcredist140" />'
    }
  }
}

function global:au_BeforeUpdate() {
  if ($Latest.PackageName -eq 'psql') { return }

  # Generate checksum this way
  Get-RemoteFiles -Purge -NoSuffix
  Remove-Item -LiteralPath (Join-Path $PSScriptRoot "tools\$($Latest.FileName64)") -Force
}

function global:au_GetLatest {
  $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing -ErrorAction Stop
  # Ignore duplicate Next.js hydration data and comments between text nodes.
  $html = $download_page.Content -replace '(?is)<script\b[^>]*>.*?</script>', '' -replace '(?s)<!--.*?-->', ''
  $sections = [regex]::Split($html, '(?i)Binaries\s+from\s+installer') | Select-Object -Skip 1
  $downloads = foreach ($section in $sections) {
    $headingHtml = ($section -split '(?i)<a\b', 2)[0]
    $heading = [System.Net.WebUtility]::HtmlDecode(($headingHtml -replace '<[^>]+>', '')).Trim()
    if ($heading -match '(?i)not\s+supported|unsupported|beta|alpha|\brc\b|\drc\d') { continue }
    if ($heading -notmatch '^Version\s+(?<Version>\d+\.\d+)\s*$') {
      throw "Unable to determine the PostgreSQL binary version from '$heading'"
    }
    $version = $Matches.Version

    $links = @([regex]::Matches($section, '(?is)<a\b[^>]*\bhref=["''](?<Url>[^"'']+)["''][^>]*>(?<Body>.*?)</a>') | Where-Object {
      $_.Groups['Body'].Value -match '(?i)\balt=["'']Windows x86-64["'']'
    })
    if ($links.Count -ne 1) { throw "Expected one Windows x64 binary download for PostgreSQL $version; found $($links.Count)" }
    $href = [System.Net.WebUtility]::HtmlDecode($links[0].Groups['Url'].Value)

    [PSCustomObject]@{ version = $version; href = $href }
  }
  if (!$downloads) { throw 'No supported stable PostgreSQL Windows x64 binaries found' }

  $streams = [ordered]@{}
  $majors = @{}
  foreach ($item in ($downloads | Sort-Object { [version] $_.version } -Descending)) {
    $major, $minor = $item.version -split '\.' | Select-Object -First 2
    if ($majors.ContainsKey($major)) { throw "Multiple supported PostgreSQL releases found for major $major" }
    $majors[$major] = $true

    $url64 = Resolve-PsqlUrl $item.href
    $packageVersion = Get-PsqlVersion -url $url64 -expectedVersion $item.version

    $s1 = @{
      Version      = $packageVersion
      Url64        = $url64
      FileType     = 'zip'
      PackageName  = "psql$major"
      ReleaseNotes = "https://www.postgresql.org/docs/$major/static/release.html"
      DocsUrl      = "https://www.postgresql.org/docs/$major/app-psql.html"
    }
    $s2 = @{
      Version      = $packageVersion
      Dependency   = $s1.PackageName
      PackageName  = 'psql'
      ReleaseNotes = $s1.ReleaseNotes
      DocsUrl      = $s1.DocsUrl
    }

    $s = "$major.$minor"
    $streams.$s = $s1
    $s = "psql-$s"; $streams.$s = $s2
  }

  $streams.psql = @{
    Version      = $streams[0].Version
    Dependency   = $streams[0].PackageName
    PackageName  = 'psql'
    ReleaseNotes = $streams[0].ReleaseNotes
    DocsUrl      = $streams[0].DocsUrl
  }
  @{ streams = $streams }
}

update -ChecksumFor none
