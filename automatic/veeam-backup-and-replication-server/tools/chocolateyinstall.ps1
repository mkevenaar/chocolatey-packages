$ErrorActionPreference = 'Stop';
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$isoPackageName = 'veeam-backup-and-replication-iso'
$scriptPath = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
$commonPath = $(Split-Path -parent $(Split-Path -parent $scriptPath))
$filename = 'VeeamBackup&Replication_11.0.1.1261_20211005.iso'
$installPath = Join-Path  (Join-Path $commonPath $isoPackageName) $filename

$fileLocation = 'Backup\Server.x64.msi'
$updateFileVersion = ($filename -replace 'VeeamBackup&Replication_' -replace '.iso').ToLower()
$updateFileLocation = "Updates\veeam_backup_$($updateFileVersion)_setup.exe"

$pp = Get-PackageParameters

$silentArgs = ""

if ($pp.nfsDatastoreLocation) {
  $silentArgs += " VBR_NFSDATASTORE=`"$($pp.nfsDatastoreLocation)`""
  if(!(Test-Path -Path $pp.nfsDatastoreLocation )){
    New-Item -Path $pp.nfsDatastoreLocation -ItemType Directory
  }
}

if ($pp.backupPort) {
  $silentArgs += " VBR_SERVICE_PORT=$($pp.backupPort)"
}

if ($pp.mountserverPort) {
  $silentArgs += " VBR_SECURE_CONNECTIONS_PORT=$($pp.mountserverPort)"
}

if ($pp.mountserverPort) {
  $silentArgs += " VBR_SECURE_CONNECTIONS_PORT=$($pp.mountserverPort)"
}

if ($pp.sqlServer) {
  $silentArgs += " VBR_SQLSERVER_SERVER=$($pp.sqlServer)"
}

if ($pp.sqlDatabase) {
  $silentArgs += " VBR_SQLSERVER_DATABASE=$($pp.sqlDatabase)"
}

if ($pp.sqlAuthentication) {
  if(-not $pp.sqlPassword -or -not $pp.sqlUsername) {
    throw 'sqlUsername and sqlPassword are required when using sqlAuthentication...'
  }
  $silentArgs += " VBR_SQLSERVER_AUTHENTICATION=$($pp.sqlAuthentication) VBR_SQLSERVER_USERNAME=`"$($pp.sqlUsername)`" VBR_SQLSERVER_PASSWORD=`"$($pp.sqlPassword)`""
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
  $silentArgs += " VBR_SERVICE_USER=`"$($fulluser)`" VBR_SERVICE_PASSWORD=`"$($pp.password)`""
}

if ($pp.licenseFile) {
  if(!(Test-Path -Path $pp.licenseFile )){
    throw "Invalid license file provided"
  }
  $silentArgs += " VBR_LICENSE_FILE=$($pp.licenseFile)"
}



$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  isoFile        = $installPath
  softwareName  = 'Veeam Backup & Replication Server*'
  file           = $fileLocation
  fileType       = 'msi'
  silentArgs     = "$($silentArgs) VBR_AUTO_UPGRADE=1 ACCEPTEULA=YES ACCEPT_THIRDPARTY_LICENSES=1 /qn /norestart /l*v `"$env:TEMP\$env:ChocolateyPackageName.$env:ChocolateyPackageVersion.log`""
  validExitCodes = @(0,1638,1641,3010) #1638 was added to allow updating when an newer version is already installed.
  destination    = $toolsDir
}

Install-ChocolateyIsoInstallPackage @packageArgs

# An update file is provided in the ISO. This should be executed after
# the installation of the software.
# This update file contains an update to all available software on the
# ISO and should be executed After each installation.
#
# This should be in a seperate package, but you can't trigger / force a
# dependency after the installation Therefore I need to trigger it this way.
If ($filename -Match "Update") {
  $updatePackageArgs = @{
    packageName    = $env:ChocolateyPackageName
    isoFile        = $installPath
    softwareName   = $packageArgs['softwareName']
    file           = $updateFileLocation
    fileType       = 'exe'
    silentArgs     = "VBR_AUTO_UPGRADE=1 /silent /noreboot /log `"$env:TEMP\$env:ChocolateyPackageName.$env:ChocolateyPackageVersion.log`""
    validExitCodes = @(0,1641,3010)
    destination    = $toolsDir
  }

  Install-ChocolateyIsoInstallPackage @updatePackageArgs
}
