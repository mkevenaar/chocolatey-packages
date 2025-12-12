$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://dl.bitvise.com/BvSshServer-Inst.exe'
$checksum     = 'f437349511ea3620dafe1907bb5d9f17728de7d583d5a1b2b7fa31c424a2b45e'
$checksumType = 'sha256'

$silentArgs = ''

$packageParameters = Get-PackageParameters

# Default values
#$installDir = "directory"
$defaultSite = $true
#$site = "name"
$force = $false
$acceptEULA = $true
$interactive = $false
$noRollback = $false
#$renameExistingDir = "existingDir"
#$activationCode = "hex-code"
#$keypairs = "file"
#$settings = "file"
#$siteTypeSettings = "file"
$startService = $false
$startBssCtrl = $false

# parse packageParameters with regular expressions
if ( $packageParameters.installDir ) {
  Write-Host "installDir Argument Found"
  $installDir = $packageParameters.installDir
  $silentArgs += " -installDir=" + $installDir
  $defaultSite = $false
} elseif ( $packageParameters.site ) {
  Write-Host "site Argument Found"
  $siteName = $packageParameters.site
  $silentArgs += " -instance=" + $siteName
  $defaultSite = $false
}

# rename install location
if ( $packageParameters.renameExistingDir ) {
  Write-Host "renameExistingDir Argument Found"
  $renameExistingDir = $packageParameters.renameExistingDir
  $silentArgs += " -renameExistingDir=" + $renameExistingDir
}

if ( $packageParameters.force ) {
  Write-Host "force Argument Found"
  $force = $true
}
    
if ( $packageParameters.interactive ) {
  Write-Host "interactive Argument Found"
  $interactive = $true
}
    
if ( $packageParameters.noRollback ) {
  Write-Host "noRollback Argument Found"
  $noRollback = $true
}
    
if ( $packageParameters.activationCode ) {
  Write-Host "activationCode Argument Found"
  $activationCode = $packageParameters.activationCode
  $silentArgs += " -activationCode=" + $activationCode
}
    
if ( $packageParameters.keypairs ) {
  Write-Host "keypairs Argument Found"
  $keypairFile = $packageParameters.keypairs
  $silentArgs += " -keypairs=" + $keypairFile
}
    
if ( $packageParameters.settings ) {
  Write-Host "settings Argument Found"
  $settingsFile = $packageParameters.settings
  $silentArgs += " -settings=" + $settingsFile
}
    
if ( $packageParameters.instanceTypeSettings ) {
  Write-Host "instanceTypeSettings Argument Found"
  $instanceTypeSettings = $packageParameters.instanceTypeSettings
  $silentArgs += " -instanceTypeSettings=" + $instanceTypeSettings
}

if ( $packageParameters.certificates ) {
  Write-Host "certificates Argument Found"
  $certificates = $packageParameters.certificates
  $silentArgs += " -certificates=" + $certificates
}
    
if ( $packageParameters.startService ) {
  Write-Host "startService Argument Found"
  $startService = $true
}
    
if ( $packageParameters.startBssCtrl ) {
  Write-Host "startBssCtrl Argument Found"
  $startBssCtrl = $true
}

if ($force) { $silentArgs += " -force" }
if ($interactive) { $silentArgs += " -interactive" }
if ($noRollback) { $silentArgs += " -noRollback" }
if ($acceptEULA) { $silentArgs += " -acceptEULA" }
if ($defaultSite) { $silentArgs += " -defaultInstance" }
if ($startService) { $silentArgs += " -startService" }
if ($startBssCtrl) { $silentArgs += " -startBssCtrl" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  fileType      = 'exe'
  url           = $url
  checksum      = $checksum
  checksumType  = $checksumType
  softwareName  = "Bitvise SSH Server*"
  silentArgs    = $silentArgs
  validExitCodes= @(0..63)
}

Install-ChocolateyPackage @packageArgs
