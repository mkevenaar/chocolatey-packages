$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$isoPackageName = 'veeam-one-iso'
$scriptPath = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
$commonPath = $(Split-Path -parent $(Split-Path -parent $scriptPath))
$filename = 'VeeamONE_12.2.0.4093.iso'
$installPath = Join-Path  (Join-Path $commonPath $isoPackageName) $filename

$fileLocation = 'Reporter\VeeamONE.Reporter.WebUI.x64.msi'

$service = get-service w3svc -ErrorAction SilentlyContinue
if(!$service) {
  Write-Warning "IIS is not installed on this machine! `nPlease install IIS on this machine as described on the package page"
  throw
}

$pp = Get-PackageParameters

if (-not $pp.username -or -not $pp.password -or -not $pp.oneServer) {
  throw "A Required package parameter is missing, please provide the 'username','password','oneServer' parameters"
}

$silentArgs = ""

if ($pp.installDir) {
  $silentArgs += " INSTALLDIR=$($pp.installDir)"
}

if ($pp.oneServer) {
  $silentArgs += " VO_REPORTER_WEB_SERVER_NAME=$($pp.oneServer)"
}

if ($pp.username) {
  $computername = $env:computername
  $fulluser = $pp.username
  if ($pp.username -notmatch "\\") {
    $fulluser = "$($computername)\$($pp.username)"
  }
  if(-not $pp.password) {
    throw 'Password is required when setting a username...'
  }
  if ($pp.create) {
    if ($pp.username -match "\\") {
      throw "Only local users can be created"
    }

    if (Get-WmiObject -Class Win32_UserAccount | Where-Object {$_.Name -eq $pp.username}) {
      Write-Warning "The local user already exists, not creating again"
    } else {
      net user $pp.username $pp.password /add /PASSWORDCHG:NO
      wmic UserAccount where ("Name='{0}'" -f $pp.username) set PasswordExpires=False
      net localgroup "Administrators" $pp.username /add    }
  }
  $silentArgs += " VO_REPORTER_WEB_CONNECTION_ACCOUNT_NAME=`"$($fulluser)`" VO_REPORTER_WEB_CONNECTION_ACCOUNT_PASSWORD=`"$($pp.password)`""
}

if ($pp.iisSitePort) {
  $silentArgs += " VO_REPORTER_WEB_SITE_PORT=`"$($pp.iisSitePort)`""
}

if ($pp.sslThumbprint) {
  $silentArgs += " VO_REPORTER_WEB_SITE_CERTIFICATE_THUMBPRINT=`"$($pp.sslThumbprint)`""
}

if ($pp.reporterWebServerWebAPIPort) {
  $silentArgs += " VO_REPORTER_WEB_SERVER_WEB_API_PORT=`"$($pp.reporterWebServerWebAPIPort)`""
}

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  isoFile        = $installPath
  softwareName   = 'Veeam ONE Reporter Web*'
  file           = $fileLocation
  fileType       = 'msi'
  silentArgs     = "$($silentArgs) ACCEPT_THIRDPARTY_LICENSES=1 ACCEPT_EULA=1 ACCEPT_REQUIRED_SOFTWARE=1 ACCEPT_LICENSING_POLICY=1 /qn /norestart /l*v `"$env:TEMP\$env:ChocolateyPackageName.$env:ChocolateyPackageVersion.log`""
  validExitCodes = @(0,1638,1641,3010) #1638 was added to allow updating when an newer version is already installed.
  destination    = $toolsDir
}

Install-ChocolateyIsoInstallPackage @packageArgs
