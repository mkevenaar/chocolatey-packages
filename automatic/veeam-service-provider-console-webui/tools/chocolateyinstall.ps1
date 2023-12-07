$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$isoPackageName = 'veeam-service-provider-console-iso'
$scriptPath = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
$commonPath = $(Split-Path -parent $(Split-Path -parent $scriptPath))
$filename = 'VeeamServiceProviderConsole_8.0.0.16877_20231130.iso'
$installPath = Join-Path  (Join-Path $commonPath $isoPackageName) $filename

$fileLocation = 'WebUI\VAC.WebUI.x64.msi'

$service = get-service w3svc -ErrorAction SilentlyContinue
if(!$service) {
  Write-Warning "IIS is not installed on this machine! `nPlease install IIS on this machine as described on the package page"
  throw "IIS is not installed on this machine! `nPlease install IIS on this machine as described on the package page"
}

$pp = Get-PackageParameters

if (-not $pp.serverName -or -not $pp.username -or -not $pp.password) {
  throw "A Required package parameter is missing, please provide the 'serverName','username','password' parameters"
}

$silentArgs = ""

if ($pp.installDir) {
  $silentArgs += " INSTALLDIR=`"$($pp.installDir)`""
}

if ($pp.serverName) {
  $silentArgs += " VAC_SERVER_NAME=`"$($pp.serverName)`""
}

if ($pp.serverManagementPort) {
  $silentArgs += " VAC_SERVER_PORT=`"$($pp.serverManagementPort)`""
}

if ($pp.restApiPort) {
  $silentArgs += " VAC_RESTAPI_PORT=`"$($pp.restApiPort)`""
}

if ($pp.websitePort) {
  $silentArgs += " VAC_WEBSITE_PORT=`"$($pp.websitePort)`""
}

if ($pp.configureSchannel) {
  if ($pp.configureSchannel -eq "0") {
    Write-Warning "This is insecure and should not be used in production!"
  }
  $silentArgs += " VAC_CONFIGURE_SCHANNEL=`"$($pp.configureSchannel)`""
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
  $silentArgs += " VAC_SERVER_ACCOUNT_NAME=`"$($fulluser)`" VAC_SERVER_ACCOUNT_PASSWORD=`"$($pp.password)`""
}

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  isoFile        = $installPath
  softwareName   = 'Veeam Service Provider Console WebUI*'
  file           = $fileLocation
  fileType       = 'msi'
  silentArgs     = "$($silentArgs) ACCEPT_THIRDPARTY_LICENSES=1 ACCEPT_EULA=1 ACCEPT_REQUIRED_SOFTWARE=1 ACCEPT_LICENSING_POLICY=1 /qn /norestart /l*v `"$env:TEMP\$env:ChocolateyPackageName.$env:ChocolateyPackageVersion.log`""
  validExitCodes = @(0,1638,1641,3010) #1638 was added to allow updating when an newer version is already installed.
  destination    = $toolsDir
}

Install-ChocolateyIsoInstallPackage @packageArgs

