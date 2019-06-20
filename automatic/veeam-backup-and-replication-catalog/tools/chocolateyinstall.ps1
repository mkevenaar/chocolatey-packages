$ErrorActionPreference = 'Stop';
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$isoPackageName = 'veeam-backup-and-replication-iso'
$scriptPath = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
$commonPath = $(Split-Path -parent $(Split-Path -parent $scriptPath))
$filename = 'VeeamBackup&Replication_9.5.4.2753.Update4a.iso'
$installPath = Join-Path  (Join-Path $commonPath $isoPackageName) $filename

$fileLocation = 'Catalog\VeeamBackupCatalog64.msi'
$updateFileVersion = ($filename -replace 'VeeamBackup&Replication_' -replace '.iso').ToLower()
$updateFileLocation = "Updates\veeam_backup_$($updateFileVersion)_setup.exe"

$pp = Get-PackageParameters

$silentArgs = ""

if ($pp.catalogLocation) {
  $silentArgs += " VM_CATALOGPATH=`"$($pp.catalogLocation)`""
  if(!(Test-Path -Path $pp.catalogLocation )){
    New-Item -Path $pp.catalogLocation -ItemType Directory
  }
}

if ($pp.port) {
  $silentArgs += " VBRC_SERVICE_PORT=$($pp.port)"
}

if ($pp.username) {
  $computername = net user | Where-Object { $_ -match "\\\\(.+)" } | ForEach-Object { $Matches[1] }
  $fulluser = $pp.username
  if (-not $pp.username -contains "\") {
    $fulluser = "$computername\$pp.username"
  }
  if(-not $pp.password) {
    throw 'Password is required when setting a username...'
  }
  if ($pp.create) {
    if ($pp.username -contains "\") {
      throw "Only local users can be created"
    }

    # This is POSH3 or higher only.
    if (Get-LocalUser -Name $pp.username -ErrorAction SilentlyContinue) {
      Write-Warning "The local user already exists, not creating again"
    } else {
      New-LocalUser -Name $pp.username -Password $pp.password -AccountNeverExpires -UserMayNotChangePassword -Confirm:$false
      Add-LocalGroupMember -Group "Administrators" -Member $pp.username -Confirm:$false
    }
  }
  $silentArgs += " VBRC_SERVICE_USER=`"$($fulluser)`" VBRC_SERVICE_PASSWORD=`"$($pp.password)`""
}

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  isoFile        = $installPath
  softwareName  = 'Veeam Backup Catalog*'
  file           = $fileLocation
  fileType       = 'msi'
  silentArgs     = "$($silentArgs) ACCEPTEULA=YES ACCEPT_THIRDPARTY_LICENSES=1 /qn /norestart /l*v `"$env:TEMP\$env:ChocolateyPackageName.$env:ChocolateyPackageVersion.log`""
  validExitCodes = @(0,1641,3010)
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
