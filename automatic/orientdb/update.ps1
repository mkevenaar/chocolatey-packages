Import-Module Chocolatey-AU

$releases = 'https://orientdb.dev/downloads/'
$mavenMetadata = 'https://repo1.maven.org/maven2/com/orientechnologies/orientdb-community/maven-metadata.xml'
$mavenArtifactBase = 'https://repo1.maven.org/maven2/com/orientechnologies/orientdb-community'

function global:au_BeforeUpdate { Get-RemoteFiles -NoSuffix -Purge }

function global:au_GetLatest {
    [xml]$metadata = (Invoke-WebRequest -Uri $mavenMetadata -UseBasicParsing).Content

    $version = $metadata.metadata.versioning.release
    if ([string]::IsNullOrWhiteSpace($version)) {
        $version = $metadata.metadata.versioning.latest
    }
    if ([string]::IsNullOrWhiteSpace($version)) {
        throw "Failed to locate the latest OrientDB Community version in $mavenMetadata."
    }

    $url = "$mavenArtifactBase/$version/orientdb-community-$version.zip"

    return @{
        URL32 = $url
        Version = $version
        FileType = 'zip'
    }
}

function global:au_SearchReplace {
  return @{
    ".\tools\chocolateyInstall.ps1" = @{
      "(?i)(^\s*fileFullPath\s*=\s*`"[$]toolsDir\\).*"   = "`${1}$($Latest.FileName32)`""
    }
    ".\legal\VERIFICATION.txt" = @{
      "(?i)(listed on\s*)\<.*\>" = "`${1}<$releases>"
      "(?i)(32-Bit.+)\<.*\>"     = "`${1}<$($Latest.URL32)>"
      "(?i)(checksum type:).*"   = "`${1} $($Latest.ChecksumType32)"
      "(?i)(checksum32:).*"      = "`${1} $($Latest.Checksum32)"
    }
  }
}

if ($MyInvocation.InvocationName -ne '.') {
  update -ChecksumFor None
}
