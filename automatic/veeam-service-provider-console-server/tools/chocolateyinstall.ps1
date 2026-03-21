$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$isoPackageName = 'veeam-service-provider-console-iso'
$scriptPath = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
$commonPath = $(Split-Path -parent $(Split-Path -parent $scriptPath))
$filename = 'VeeamServiceProviderConsole_9.0.0.29555.iso'
$installPath = Join-Path  (Join-Path $commonPath $isoPackageName) $filename
$isoToolsPath = Join-Path (Join-Path $commonPath $isoPackageName) 'tools'
$settingsFile = Join-Path $isoToolsPath 'VeeamPortalSetupSettings.xml'

if (-not (Test-Path -LiteralPath $installPath)) {
  throw "Unable to locate ISO source '$installPath'. Ensure dependency '$isoPackageName' is installed."
}

$fileLocation = 'ApplicationServer\VAC.ApplicationServer.x64.msi'

$pp = Get-PackageParameters

if (-not $pp.licenseFile -or -not $pp.username -or -not $pp.password) {
  throw "A Required package parameter is missing, please provide the 'licenseFile','username','password' parameters"
}

$parameterValidationRules = @{
  licenseFile                 = 'Path'
  installDir                  = 'String'
  username                    = 'String'
  password                    = 'String'
  productUpdates              = 'ZeroOrOne'
  licenseAutoUpdate           = 'ZeroOrOne'
  create                      = 'Boolean'
  sqlServer                   = 'String'
  sqlDatabase                 = 'String'
  sqlAuthentication           = 'ZeroOrOne'
  sqlUsername                 = 'String'
  sqlPassword                 = 'String'
  serverManagementPort        = 'Integer'
  connectionHubPort           = 'Integer'
  serverCertificateThumbprint = 'String'
}

Invoke-PackageParameterValidation -Parameters $pp -Rules $parameterValidationRules

$silentArgs = New-Object System.Collections.Generic.List[string]

if ($pp.installDir) {
  Add-SilentArgument -Buffer $silentArgs -Value ("INSTALLDIR=`"{0}`"" -f $pp.installDir)
}

if ($pp.ContainsKey('productUpdates')) {
  Add-SilentArgument -Buffer $silentArgs -Value ("VSPC_PRODUCT_UPDATES={0}" -f $pp.productUpdates)
}

if ($pp.ContainsKey('licenseAutoUpdate')) {
  Add-SilentArgument -Buffer $silentArgs -Value ("VSPC_LICENSE_AUTOUPDATE={0}" -f $pp.licenseAutoUpdate)
}

if ($pp.sqlServer) {
  Add-SilentArgument -Buffer $silentArgs -Value ("VAC_SQL_SERVER={0}" -f $pp.sqlServer)
}

if ($pp.sqlDatabase) {
  Add-SilentArgument -Buffer $silentArgs -Value ("VAC_DATABASE_NAME={0}" -f $pp.sqlDatabase)
}

$useSqlAuthentication = $pp.ContainsKey('sqlAuthentication') -and $pp.sqlAuthentication -eq '1'

if ($useSqlAuthentication) {
  if (-not $pp.sqlPassword -or -not $pp.sqlUsername) {
    throw 'sqlUsername and sqlPassword are required when using sqlAuthentication...'
  }
  Add-SilentArgument -Buffer $silentArgs -Value ("VAC_AUTHENTICATION_MODE={0}" -f $pp.sqlAuthentication)
  Add-SilentArgument -Buffer $silentArgs -Value ("VAC_SQL_USER=`"{0}`"" -f $pp.sqlUsername)
  Add-SilentArgument -Buffer $silentArgs -Value ("VAC_SQL_USER_PASSWORD=`"{0}`"" -f $pp.sqlPassword)
}

if ($pp.ContainsKey('serverManagementPort')) {
  Add-SilentArgument -Buffer $silentArgs -Value ("VAC_SERVER_MANAGEMENT_PORT={0}" -f $pp.serverManagementPort)
}

if ($pp.ContainsKey('connectionHubPort')) {
  Add-SilentArgument -Buffer $silentArgs -Value ("VAC_CONNECTION_HUB_PORT={0}" -f $pp.connectionHubPort)
}

if ($pp.serverCertificateThumbprint) {
  Add-SilentArgument -Buffer $silentArgs -Value ("VAC_SERVER_CERTIFICATE_THUMBPRINT={0}" -f $pp.serverCertificateThumbprint)
}

if ($pp.username) {
  $computername = $env:computername
  $fullUser = $pp.username
  if ($pp.username -notmatch "\\") {
    $fullUser = "$($computername)\$($pp.username)"
  }
  if (-not $pp.password) {
    throw 'Password is required when setting a username...'
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
  Add-SilentArgument -Buffer $silentArgs -Value ("VAC_SERVICE_ACCOUNT_NAME=`"{0}`"" -f $fullUser)
  Add-SilentArgument -Buffer $silentArgs -Value ("VAC_SERVICE_ACCOUNT_PASSWORD=`"{0}`"" -f $pp.password)
}

if ($pp.licenseFile) {
  try {
    $licenseFileItem = Get-Item -LiteralPath $pp.licenseFile -ErrorAction Stop
  }
  catch {
    throw "Invalid license file provided: $($_.Exception.Message)"
  }
  $pp.licenseFile = $licenseFileItem.FullName
  Add-SilentArgument -Buffer $silentArgs -Value ("VAC_LICENSE_FILE=`"{0}`"" -f $pp.licenseFile)
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
  softwareName   = 'Veeam Service Provider Console Application Server*'
  file           = $fileLocation
  fileType       = 'msi'
  silentArgs     = $msiSilentArgs
  validExitCodes = @(0,1638,1641,3010) #1638 was added to allow updating when an newer version is already installed.
  destination    = $toolsDir
}

Install-ChocolateyIsoInstallPackage @packageArgs

$patchArgs = @{
  PackageName  = $env:ChocolateyPackageName
  IsoFile      = $installPath
  SettingsFile = $settingsFile
  SilentArgs   = $msiSilentArgs
  ValidExitCodes = @(0,1638,1641,3010)
  Destination  = $toolsDir
  ProductName  = 'Server'
}

Install-VeeamIsoPatchIfNeeded @patchArgs
