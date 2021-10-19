$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$isoPackageName = 'veeam-one-iso'
$scriptPath = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
$commonPath = $(Split-Path -parent $(Split-Path -parent $scriptPath))
$filename = 'VeeamONE_11.0.1.1880_20210922.iso'
$installPath = Join-Path  (Join-Path $commonPath $isoPackageName) $filename

$fileLocation = 'Monitor\VeeamONE.Monitor.Server.x64.msi'

$service = get-service w3svc -ErrorAction SilentlyContinue
if(!$service) {
  Write-Warning "IIS is not installed on this machine! `nPlease install IIS on this machine as described on the package page"
  throw
}

$pp = Get-PackageParameters

$silentArgs = ""

$validOptionsTypes = '0','1','2'
$validOptionsBool = '0','1'

if ($pp.perfCache) {
  $silentArgs += " VM_MN_CACHE=`"$($pp.perfCache)`""
  if(!(Test-Path -Path $pp.perfCache )){
    New-Item -Path $pp.perfCache -ItemType Directory
  }
}

if ($pp.installationType) {
  if (-not $validOptionsTypes.Contains($pp.installationType)) {
    Write-Warning "$($pp.installationType) is an invalid value for the installationType parameter."
    throw
  }
  $silentArgs += " VO_INSTALLATION_TYPE=$($pp.installationType)"
}

if ($pp.vcSelectedType) {
  if (-not $validOptionsTypes.Contains($pp.vcSelectedType)) {
    Write-Warning "$($pp.vcSelectedType) is an invalid value for the vcSelectedType parameter."
    throw
  }
  $silentArgs += " VM_VC_SELECTED_TYPE=`"$($pp.vcSelectedType)`""

  if ($pp.vcSelectedType -eq '1') {
    if ($pp.hvType) {
      if (-not $validOptionsTypes.Contains($pp.hvType)) {
        Write-Warning "$($pp.hvType) is an invalid value for the hvType parameter."
        throw
      }
      $silentArgs += " VM_HV_TYPE=$($pp.hvType)"

    }
  }

  if($pp.vcSelectedType -eq '0' -or $pp.vcSelectedType -eq '1') {
    if(-not $pp.vcHost -or -not $pp.vcPort -or -not $pp.vcHostUser -or -not $pp.vcHostPass) {
      Write-Warning "vcHost, vcPort, vcHostUser and vcHostPass are required when vcSelectedType is 0 or 1"
      throw
    }
    $silentArgs += " VM_VC_HOST=`"$($pp.vcHost)`" VM_VC_PORT=$($pp.vcPort) VM_VC_HOST_USER=`"$($pp.vcHostUser)`" VM_VC_HOST_PWD=`"$($pp.vcHostPass)`""

    if ($pp.backupAddLater) {
      if (-not $validOptionsBool.Contains($pp.backupAddLater)) {
        Write-Warning "$($pp.backupAddLater) is an invalid value for the backupAddLater parameter."
        throw
      }
      $silentArgs += " VM_BACKUP_ADD_LATER=$($pp.backupAddLater)"
    }

    if(-not $pp.backupAddLater -and (-not $pp.backupAddType -or -not $pp.backupAddHost -or -not $pp.backupAddUser -or -not $pp.backupAddPass)) {
      Write-Warning "backupAddType, backupAddHost, backupAddUser and backupAddPass are required when vcSelectedType is 0 or 1 and backupAddLater is not 1"
      throw
    }

    if (-not $validOptionsBool.Contains($pp.backupAddType)) {
      Write-Warning "$($pp.backupAddType) is an invalid value for the backupAddType parameter."
      throw
    }
    $silentArgs += " VM_BACKUP_ADD_TYPE=$($pp.backupAddType) VM_BACKUP_ADD_NAME=`"$($pp.backupAddHost)`" VM_BACKUP_ADD_USER=`"$($pp.backupAddUser)`" VM_BACKUP_ADD_PWD=`"$($pp.backupAddPass)`""
  }
}

if ($pp.sqlServer) {
  $silentArgs += " VM_MN_SQL_SERVER=$($pp.sqlServer)"
}

if ($pp.sqlDatabase) {
  $silentArgs += " VM_MN_SQL_DATABASE=$($pp.sqlDatabase)"
}

if ($pp.sqlAuthentication) {
  if(-not $pp.sqlPassword -or -not $pp.sqlUsername) {
    throw 'sqlUsername and sqlPassword are required when using sqlAuthentication...'
  }
  $silentArgs += " VM_MN_SQL_AUTHENTICATION=$($pp.sqlAuthentication) VM_MN_SQL_USER=`"$($pp.sqlUsername)`" VM_MN_SQL_PASSWORD=`"$($pp.sqlPassword)`""
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
  $silentArgs += " VM_MN_SERVICEACCOUNT=`"$($fulluser)`" VM_MN_SERVICEPASSWORD=`"$($pp.password)`""
}

if ($pp.licenseFile) {
  if(!(Test-Path -Path $pp.licenseFile )){
    throw "Invalid license file provided"
  }
  $silentArgs += " EDITLICFILEPATH=$($pp.licenseFile)"
}

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  isoFile        = $installPath
  softwareName   = 'Veeam ONE Monitor Server*'
  file           = $fileLocation
  fileType       = 'msi'
  silentArgs     = "$($silentArgs) ACCEPT_EULA=1 ACCEPT_THIRDPARTY_LICENSES=1 /qn /norestart /l*v `"$env:TEMP\$env:ChocolateyPackageName.$env:ChocolateyPackageVersion.log`""
  validExitCodes = @(0,1638,1641,3010) #1638 was added to allow updating when an newer version is already installed.
  destination    = $toolsDir
}

Install-ChocolateyIsoInstallPackage @packageArgs
