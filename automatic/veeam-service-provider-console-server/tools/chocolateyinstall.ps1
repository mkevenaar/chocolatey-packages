$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$isoPackageName = 'veeam-service-provider-console-iso'
$scriptPath = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
$commonPath = $(Split-Path -parent $(Split-Path -parent $scriptPath))
$filename = 'VeeamServiceProviderConsole_8.0.0.19236_20240426.iso'
$installPath = Join-Path  (Join-Path $commonPath $isoPackageName) $filename

$fileLocation = 'ApplicationServer\VAC.ApplicationServer.x64.msi'

$pp = Get-PackageParameters

if (-not $pp.licenseFile -or -not $pp.username -or -not $pp.password) {
  throw "A Required package parameter is missing, please provide the 'licenseFile','username','password' parameters"
}

$silentArgs = ""

if ($pp.installDir) {
  $silentArgs += " INSTALLDIR=`"$($pp.installDir)`""
}

if ($pp.licenseAutoUpdate) {
  $silentArgs += " VSPC_LICENSE_AUTOUPDATE=$($pp.licenseAutoUpdate)"
}

if ($pp.sqlServer) {
  $silentArgs += " VAC_SQL_SERVER=$($pp.sqlServer)"
}

if ($pp.sqlDatabase) {
  $silentArgs += " VAC_DATABASE_NAME=$($pp.sqlDatabase)"
}

if ($pp.sqlAuthentication) {
  if(-not $pp.sqlPassword -or -not $pp.sqlUsername) {
    throw 'sqlUsername and sqlPassword are required when using sqlAuthentication...'
  }
  $silentArgs += " VAC_AUTHENTICATION_MODE=$($pp.sqlAuthentication) VAC_SQL_USER=`"$($pp.sqlUsername)`" VAC_SQL_USER_PASSWORD=`"$($pp.sqlPassword)`""
}

if ($pp.serverManagementPort) {
  $silentArgs += " VAC_SERVER_MANAGEMENT_PORT=$($pp.serverManagementPort)"
}

if ($pp.connectionHubPort) {
  $silentArgs += " VAC_CONNECTION_HUB_PORT=$($pp.connectionHubPort)"
}

if ($pp.serverCertificateThumbprint) {
  $silentArgs += " VAC_SERVER_CERTIFICATE_THUMBPRINT=$($pp.serverCertificateThumbprint)"
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
  $silentArgs += " VAC_SERVICE_ACCOUNT_NAME=`"$($fulluser)`" VAC_SERVICE_ACCOUNT_PASSWORD=`"$($pp.password)`""
}

if ($pp.licenseFile) {
  if(!(Test-Path -Path $pp.licenseFile )){
    throw "Invalid license file provided"
  }
  $silentArgs += " VAC_LICENSE_FILE=$($pp.licenseFile)"
}

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  isoFile        = $installPath
  softwareName   = 'Veeam Service Provider Console Application Server*'
  file           = $fileLocation
  fileType       = 'msi'
  silentArgs     = "$($silentArgs) ACCEPT_THIRDPARTY_LICENSES=1 ACCEPT_EULA=1 ACCEPT_REQUIRED_SOFTWARE=1 ACCEPT_LICENSING_POLICY=1 /qn /norestart /l*v `"$env:TEMP\$env:ChocolateyPackageName.$env:ChocolateyPackageVersion.log`""
  validExitCodes = @(0,1638,1641,3010) #1638 was added to allow updating when an newer version is already installed.
  destination    = $toolsDir
}

Install-ChocolateyIsoInstallPackage @packageArgs

