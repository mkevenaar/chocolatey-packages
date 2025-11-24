Import-Module Chocolatey-AU

$releases = 'https://filezilla-project.org/download.php?show_all=1&type=server'
$userAgent = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:128.0) Gecko/20100101 Firefox/128.0'

$headers = @{
  "Accept"    = "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8"
  "User-Agent" = $userAgent
  "Referer"   = 'https://filezilla-project.org/'
}

$options =
@{
  Headers   = $headers
  UserAgent = $userAgent
}

function Get-DecryptedContentWrapper {
  param(
    [Parameter(Mandatory = $true)][string] $Html
  )

  $pattern = '<div[^>]+id="contentwrapper"[^>]*v1="(?<iv>[^"]+)"[^>]*v2="(?<key>[^"]+)"[^>]*v3="(?<alg>[^"]+)"[^>]*>(?<payload>.*?)</div>'
  $regexOptions = [System.Text.RegularExpressions.RegexOptions]::Singleline -bor [System.Text.RegularExpressions.RegexOptions]::IgnoreCase
  $match = [regex]::Match($Html, $pattern, $regexOptions)

  if (-not $match.Success) {
    throw "Failed to locate the encrypted payload on $releases."
  }

  $cipherBytes = [Convert]::FromBase64String($match.Groups['payload'].Value.Trim())
  $ivBytes     = [Convert]::FromBase64String($match.Groups['iv'].Value)
  $keyBytes    = [Convert]::FromBase64String($match.Groups['key'].Value)
  $algorithm   = [System.Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($match.Groups['alg'].Value))

  if ($algorithm -ne 'AES-CBC') {
    throw "Unsupported cipher '$algorithm' returned by the FileZilla download page."
  }

  $aes = [System.Security.Cryptography.Aes]::Create()
  try {
    $aes.Mode    = [System.Security.Cryptography.CipherMode]::CBC
    $aes.Padding = [System.Security.Cryptography.PaddingMode]::PKCS7
    $aes.Key     = $keyBytes
    $aes.IV      = $ivBytes

    $plainBytes = $aes.CreateDecryptor().TransformFinalBlock($cipherBytes, 0, $cipherBytes.Length)
  }
  finally {
    $aes.Dispose()
  }

  return [System.Text.Encoding]::UTF8.GetString($plainBytes)
}

function global:au_BeforeUpdate { Get-RemoteFiles -NoSuffix -Purge }


function global:au_AfterUpdate($Package) {
  Invoke-VirusTotalScan $Package
}

function global:au_GetLatest {
    $response = Invoke-WebRequest -Uri $releases -UseBasicParsing -Headers $headers -UserAgent $userAgent
    $decodedHtml = Get-DecryptedContentWrapper $response.Content

    $downloadPattern = 'https://dl\d+\.cdn\.filezilla-project\.org/server/FileZilla_Server_(?<version>[\d\.]+)_win64-setup\.exe[^"]*'
    $downloadMatch = [regex]::Match($decodedHtml, $downloadPattern, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)

    if (-not $downloadMatch.Success) {
      throw 'Failed to locate the FileZilla Server Windows installer link on the download page.'
    }

    $url = $downloadMatch.Value
    $version = $downloadMatch.Groups['version'].Value

    return @{
        URL32 = $url
        Version = $version
        FileType = 'exe'
        Options = $options
    }
}

function global:au_SearchReplace {
  return @{
    ".\tools\chocolateyInstall.ps1" = @{
      "(?i)(^\s*file\s*=\s*`"[$]toolsDir\\).*"   = "`${1}$($Latest.FileName32)`""
    }
    ".\legal\VERIFICATION.txt" = @{
      "(?i)(listed on\s*)\<.*\>" = "`${1}<$releases>"
      "(?i)(32-Bit.+)\<.*\>"     = "`${1}<$($Latest.URL32)>"
      "(?i)(checksum type:).*"   = "`${1} $($Latest.ChecksumType32)"
      "(?i)(checksum32:).*"      = "`${1} $($Latest.Checksum32)"
    }
  }
}


update -ChecksumFor None
