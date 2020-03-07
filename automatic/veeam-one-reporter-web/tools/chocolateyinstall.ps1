$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$isoPackageName = 'veeam-one-iso'
$scriptPath = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
$commonPath = $(Split-Path -parent $(Split-Path -parent $scriptPath))
$filename = 'VeeamONE.10.0.0.750.iso'
$installPath = Join-Path  (Join-Path $commonPath $isoPackageName) $filename

$fileLocation = 'Reporter\VeeamONE.Reporter.WebUI.x64.msi'

$service = get-service w3svc -ErrorAction SilentlyContinue
if(!$service) {
  Write-Warning "IIS is not installed on this machine! `nPlease install IIS on this machine as described on the package page"
  throw
}

$pp = Get-PackageParameters

$silentArgs = ""

$validOptionsTypes = 0,1,2

if ($pp.installationType) {
  if (-not $validOptionsTypes.Contains($pp.installationType)) {
    Write-Warning "$($pp.installationType) is an invalid value for the installationType parameter."
    throw
  }
  $silentArgs += " VO_INSTALLATION_TYPE=$($pp.installationType)"
}

if ($pp.sqlServer) {
  $silentArgs += " VM_RP_SQL_SERVER=$($pp.sqlServer)"
}

if ($pp.sqlDatabase) {
  $silentArgs += " VM_RP_SQL_DATABASE=$($pp.sqlDatabase)"
}

if ($pp.sqlAuthentication) {
  if(-not $pp.sqlPassword -or -not $pp.sqlUsername) {
    throw 'sqlUsername and sqlPassword are required when using sqlAuthentication...'
  }
  $silentArgs += " VM_RP_SQL_AUTHENTICATION=$($pp.sqlAuthentication) VM_RP_SQL_USER=`"$($pp.sqlUsername)`" VM_RP_SQL_PASSWORD=`"$($pp.sqlPassword)`""
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
  $silentArgs += " VM_RP_SERVICEACCOUNT=`"$($fulluser)`" VM_RP_SERVICEPASSWORD=`"$($pp.password)`""
}

if ($pp.iisSitePort) {
  $silentArgs += " VM_RP_IIS_SITE_PORT=`"$($pp.iisSitePort)`""
}

if ($pp.sslThumbprint) {
  $silentArgs += " RP_THUMBPRINT=`"$($pp.sslThumbprint)`""
}

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  isoFile        = $installPath
  softwareName   = 'Veeam ONE Reporter Web*'
  file           = $fileLocation
  fileType       = 'msi'
  silentArgs     = "$($silentArgs) ACCEPTEULA=YES ACCEPT_THIRDPARTY_LICENSES=1 /qn /norestart /l*v `"$env:TEMP\$env:ChocolateyPackageName.$env:ChocolateyPackageVersion.log`""
  validExitCodes = @(0,1638,1641,3010) #1638 was added to allow updating when an newer version is already installed.
  destination    = $toolsDir
}

Install-ChocolateyIsoInstallPackage @packageArgs
