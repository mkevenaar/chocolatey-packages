$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$isoPackageName = 'veeam-one-iso'
$scriptPath = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
$commonPath = $(Split-Path -parent $(Split-Path -parent $scriptPath))
$filename = 'VeeamONE_13.1.0.7034_20260723.iso'
$installPath = Join-Path  (Join-Path $commonPath $isoPackageName) $filename
$isoToolsPath = Join-Path (Join-Path $commonPath $isoPackageName) 'tools'
$settingsFile = Join-Path $isoToolsPath 'VOSettings.xml'

if (-not (Test-Path -LiteralPath $installPath)) {
  throw "Unable to locate ISO source '$installPath'. Ensure dependency '$isoPackageName' is installed."
}

$fileLocation = 'Monitor\VeeamONE.Monitor.Server.x64.msi'

$service = Get-Service w3svc -ErrorAction SilentlyContinue
if (-not $service) {
  Write-Warning "IIS is not installed on this machine! `nPlease install IIS on this machine as described on the package page"
  throw "IIS is not installed on this machine! `nPlease install IIS on this machine as described on the package page"
}

$pp = Get-PackageParameters

$parameterValidationRules = @{
  perfCache         = 'Path'
  autoUpdate        = 'ZeroOrOne'
  installDir        = 'String'
  grpcServerPort    = 'Integer'
  installationType  = 'ZeroOneOrTwo'
  sqlServer         = 'String'
  sqlDatabase       = 'String'
  sqlAuthentication = 'ZeroOrOne'
  sqlUsername       = 'String'
  sqlPassword       = 'String'
  username          = 'String'
  password          = 'String'
  create            = 'Boolean'
  licenseFile       = 'Path'
  licenseAutoUpdate = 'ZeroOrOne'
}

$parameterDependencies = @(
  @{
    Parameter = 'sqlAuthentication'
    Value     = '1'
    Requires  = @('sqlUsername', 'sqlPassword')
  }
)

Invoke-PackageParameterValidation -Parameters $pp -Rules $parameterValidationRules -RequiredParameters @('username', 'password') -Dependencies $parameterDependencies

$silentArgs = New-Object System.Collections.Generic.List[string]

if ($pp.perfCache) {
  if (-not (Test-Path -LiteralPath $pp.perfCache)) {
    $null = New-Item -Path $pp.perfCache -ItemType Directory
  }
  $perfCacheItem = Get-Item -LiteralPath $pp.perfCache -ErrorAction Stop
  Add-SilentArgument -Buffer $silentArgs -Value ("VM_MN_CACHE=`"{0}`"" -f $perfCacheItem.FullName)
}

if ($pp.ContainsKey('autoUpdate')) {
  Add-SilentArgument -Buffer $silentArgs -Value ("VM_MN_SERVER_AUTOUPDATE_ENABLED=`"{0}`"" -f $pp.autoUpdate)
}

if ($pp.installDir) {
  Add-SilentArgument -Buffer $silentArgs -Value ("PF_VEEAMONE=`"{0}`"" -f $pp.installDir)
}

if ($pp.ContainsKey('grpcServerPort')) {
  Add-SilentArgument -Buffer $silentArgs -Value ("VM_GRPC_SERVER_PORT=`"{0}`"" -f $pp.grpcServerPort)
}

if ($pp.ContainsKey('installationType')) {
  Add-SilentArgument -Buffer $silentArgs -Value ("VO_INSTALLATION_TYPE={0}" -f $pp.installationType)
}

if ($pp.sqlServer) {
  Add-SilentArgument -Buffer $silentArgs -Value ("VM_MN_SQL_SERVER=`"{0}`"" -f $pp.sqlServer)
}

if ($pp.sqlDatabase) {
  Add-SilentArgument -Buffer $silentArgs -Value ("VM_MN_SQL_DATABASE=`"{0}`"" -f $pp.sqlDatabase)
}

$useSqlAuthentication = $pp.ContainsKey('sqlAuthentication') -and $pp.sqlAuthentication -eq '1'

if ($useSqlAuthentication) {
  Add-SilentArgument -Buffer $silentArgs -Value ("VM_MN_SQL_AUTHENTICATION={0}" -f $pp.sqlAuthentication)
  Add-SilentArgument -Buffer $silentArgs -Value ("VM_MN_SQL_USER=`"{0}`"" -f $pp.sqlUsername)
  Add-SilentArgument -Buffer $silentArgs -Value ("VM_MN_SQL_PASSWORD=`"{0}`"" -f $pp.sqlPassword)
}

if ($pp.username) {
  $computername = $env:computername
  $fullUser = $pp.username
  if ($pp.username -notmatch "\\") {
    $fullUser = "$($computername)\$($pp.username)"
  }

  $createLocalUser = $pp.ContainsKey('create') -and $pp.create -eq '1'
  if ($createLocalUser) {
    if ($pp.username -match "\\") {
      throw "Only local users can be created"
    }

    $escapedUserName = $pp.username.Replace("'", "''")
    $existingUser = Get-CimInstance -ClassName Win32_UserAccount -Filter "LocalAccount=True AND Name='$escapedUserName'" -ErrorAction SilentlyContinue
    if ($existingUser) {
      Write-Warning "The local user already exists, not creating again"
    } else {
      net user $pp.username $pp.password /add /PASSWORDCHG:NO
      wmic UserAccount where ("Name='{0}'" -f $pp.username) set PasswordExpires=False
      net localgroup "Administrators" $pp.username /add
    }
  }
  Add-SilentArgument -Buffer $silentArgs -Value ("VM_MN_SERVICEACCOUNT=`"{0}`"" -f $fullUser)
  Add-SilentArgument -Buffer $silentArgs -Value ("VM_MN_SERVICEPASSWORD=`"{0}`"" -f $pp.password)
}

if ($pp.licenseFile) {
  try {
    $licenseFileItem = Get-Item -LiteralPath $pp.licenseFile -ErrorAction Stop
  }
  catch {
    throw "Invalid license file provided: $($_.Exception.Message)"
  }
  Add-SilentArgument -Buffer $silentArgs -Value ("EDITLICFILEPATH=`"{0}`"" -f $licenseFileItem.FullName)
}

if ($pp.ContainsKey('licenseAutoUpdate')) {
  Add-SilentArgument -Buffer $silentArgs -Value ("VO_LICENSE_AUTOUPDATE=`"{0}`"" -f $pp.licenseAutoUpdate)
}

Add-SilentArgument -Buffer $silentArgs -Value 'ACCEPT_THIRDPARTY_LICENSES=1'
Add-SilentArgument -Buffer $silentArgs -Value 'ACCEPT_EULA=1'
Add-SilentArgument -Buffer $silentArgs -Value 'ACCEPT_REQUIRED_SOFTWARE=1'
Add-SilentArgument -Buffer $silentArgs -Value 'ACCEPT_LICENSING_POLICY=1'
Add-SilentArgument -Buffer $silentArgs -Value '/qn'
Add-SilentArgument -Buffer $silentArgs -Value '/norestart'
Add-SilentArgument -Buffer $silentArgs -Value "/l*v `"$env:TEMP\$env:ChocolateyPackageName.$env:ChocolateyPackageVersion.log`""

$msiSilentArgs = $silentArgs -join ' '

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  isoFile        = $installPath
  softwareName   = 'Veeam ONE Monitor Server*'
  file           = $fileLocation
  fileType       = 'msi'
  silentArgs     = $msiSilentArgs
  validExitCodes = @(0,1638,1641,3010) #1638 was added to allow updating when an newer version is already installed.
  destination    = $toolsDir
}

Install-ChocolateyIsoInstallPackage @packageArgs

$patchArgs = @{
  PackageName    = $env:ChocolateyPackageName
  IsoFile        = $installPath
  SettingsFile   = $settingsFile
  SilentArgs     = $msiSilentArgs
  ValidExitCodes = @(0,1638,1641,3010)
  Destination    = $toolsDir
  ProductName    = 'MonitorServer'
}

Install-VeeamIsoPatchIfNeeded @patchArgs
