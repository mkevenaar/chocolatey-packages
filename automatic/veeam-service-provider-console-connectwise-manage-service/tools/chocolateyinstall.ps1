$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$isoPackageName = 'veeam-service-provider-console-iso'
$scriptPath = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
$commonPath = $(Split-Path -parent $(Split-Path -parent $scriptPath))
$filename = 'VeeamServiceProviderConsole_8.0.0.16877_20231130.iso'
$installPath = Join-Path  (Join-Path $commonPath $isoPackageName) $filename

$fileLocation = 'Plugins\ConnectWise\Manage\VAC.ConnectorService.x64.msi'

$pp = Get-PackageParameters

if (-not $pp.username -or -not $pp.password -or -not $pp.serverUsername -or -not $pp.serverPassword -or -not $pp.serverName) {
  throw "A Required package parameter is missing, please provide the 'username','password','serverUsername','serverPassword','serverName' parameters"
}

$silentArgs = ""

if ($pp.installDir) {
  $silentArgs += " INSTALLDIR=`"$($pp.installDir)`""
}

if ($pp.serverUsername) {
  $silentArgs += " SERVER_ACCOUNT_NAME=`"$($pp.serverUsername)`" SERVER_ACCOUNT_PASSWORD=`"$($pp.serverPassword)`""
  $silentArgs += " SERVER_ACCOUNT_PASSWORD=`"$($pp.serverPassword)`""
  $silentArgs += " SERVER_NAME=`"$($pp.serverName)`""
}

if ($pp.cwCommunicationPort) {
  $silentArgs += " VAC_CW_COMMUNICATION_PORT=`"$($pp.cwCommunicationPort)`""
}

if ($pp.vacServerManagementPort) {
  $silentArgs += " VAC_SERVER_MANAGEMENT_PORT=`"$($pp.vacServerManagementPort)`""
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
  $silentArgs += " USERNAME=`"$($fulluser)`" PASSWORD=`"$($pp.password)`""
}
$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  isoFile        = $installPath
  softwareName  = 'Application Server for Veeam ConnectWise Manage Plugin*'
  file           = $fileLocation
  fileType       = 'msi'
  silentArgs     = "$($silentArgs) ACCEPT_THIRDPARTY_LICENSES=1 ACCEPT_EULA=1 ACCEPT_REQUIRED_SOFTWARE=1 ACCEPT_LICENSING_POLICY=1 /qn /norestart /l*v `"$env:TEMP\$env:ChocolateyPackageName.$env:ChocolateyPackageVersion.log`""
  validExitCodes = @(0,1638,1641,3010) #1638 was added to allow updating when an newer version is already installed.
  destination    = $toolsDir
}

Install-ChocolateyIsoInstallPackage @packageArgs

