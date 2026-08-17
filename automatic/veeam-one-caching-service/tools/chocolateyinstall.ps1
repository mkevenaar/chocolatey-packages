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

$fileLocation = 'CachingService\VeeamONE.Caching.Service.x64.msi'

$pp = Get-PackageParameters

$parameterValidationRules = @{
  username                 = 'String'
  password                 = 'String'
  create                   = 'Boolean'
  postgresqlAuthentication = 'ZeroOrOne'
  postgresqlServer         = 'String'
  postgresqlPort           = 'Integer'
  postgresqlDatabase       = 'String'
  postgresqlUsername       = 'String'
  postgresqlPassword       = 'String'
  postgresqlInstallation   = 'ZeroOrOne'
  reporterServerWebApiPort = 'Integer'
  cachingServicePort       = 'Integer'
}

$parameterDependencies = @(
  @{
    Parameter = 'postgresqlAuthentication'
    Value     = '1'
    Requires  = @('postgresqlUsername', 'postgresqlPassword')
  }
)

Invoke-PackageParameterValidation -Parameters $pp -Rules $parameterValidationRules -RequiredParameters @('username', 'password', 'postgresqlInstallation') -Dependencies $parameterDependencies

$silentArgs = New-Object System.Collections.Generic.List[string]

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

  Add-SilentArgument -Buffer $silentArgs -Value ("VO_CACHING_SERVICE_ACCOUNT_NAME=`"{0}`"" -f $fullUser)
  Add-SilentArgument -Buffer $silentArgs -Value ("VO_CACHING_SERVICE_ACCOUNT_PASSWORD=`"{0}`"" -f $pp.password)
}

if ($pp.ContainsKey('postgresqlAuthentication')) {
  Add-SilentArgument -Buffer $silentArgs -Value ("VO_POSTGRESQL_AUTHENTICATION={0}" -f $pp.postgresqlAuthentication)
}

if ($pp.postgresqlServer) {
  Add-SilentArgument -Buffer $silentArgs -Value ("VO_POSTGRESQL_SERVER=`"{0}`"" -f $pp.postgresqlServer)
}

if ($pp.ContainsKey('postgresqlPort')) {
  Add-SilentArgument -Buffer $silentArgs -Value ("VO_POSTGRESQL_PORT={0}" -f $pp.postgresqlPort)
}

if ($pp.postgresqlDatabase) {
  Add-SilentArgument -Buffer $silentArgs -Value ("VO_POSTGRESQL_DATABASE=`"{0}`"" -f $pp.postgresqlDatabase)
}

if ($pp.postgresqlUsername) {
  Add-SilentArgument -Buffer $silentArgs -Value ("VO_POSTGRESQL_USERNAME=`"{0}`"" -f $pp.postgresqlUsername)
}

if ($pp.postgresqlPassword) {
  Add-SilentArgument -Buffer $silentArgs -Value ("VO_POSTGRESQL_PASSWORD=`"{0}`"" -f $pp.postgresqlPassword)
}

if ($pp.ContainsKey('postgresqlInstallation')) {
  Add-SilentArgument -Buffer $silentArgs -Value ("VO_POSTGRESQL_INSTALLATION={0}" -f $pp.postgresqlInstallation)
}

if ($pp.ContainsKey('reporterServerWebApiPort')) {
  Add-SilentArgument -Buffer $silentArgs -Value ("VO_CACHING_SERVICE_REPORTERCONNECTIONPARAMETERS_PORT={0}" -f $pp.reporterServerWebApiPort)
}

if ($pp.ContainsKey('cachingServicePort')) {
  Add-SilentArgument -Buffer $silentArgs -Value ("VO_CACHING_SERVICE_PORT={0}" -f $pp.cachingServicePort)
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
  softwareName   = 'Veeam ONE Caching Service*'
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
  ProductName    = 'CachingService'
}

Install-VeeamIsoPatchIfNeeded @patchArgs
