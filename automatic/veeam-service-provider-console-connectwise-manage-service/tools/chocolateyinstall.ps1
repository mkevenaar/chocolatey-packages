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

$fileLocation = 'Plugins\ConnectWise\Manage\VAC.ConnectorService.x64.msi'

$pp = Get-PackageParameters

if (-not $pp.username -or -not $pp.password -or -not $pp.serverUsername -or -not $pp.serverPassword -or -not $pp.serverName) {
  throw "A Required package parameter is missing, please provide the 'username','password','serverUsername','serverPassword','serverName' parameters"
}

$parameterValidationRules = @{
  installDir              = 'String'
  username                = 'String'
  password                = 'String'
  create                  = 'Boolean'
  serverUsername          = 'String'
  serverPassword          = 'String'
  serverName              = 'String'
  cwCommunicationPort     = 'Integer'
  vacServerManagementPort = 'Integer'
}

Invoke-PackageParameterValidation -Parameters $pp -Rules $parameterValidationRules

$silentArgs = New-Object System.Collections.Generic.List[string]

if ($pp.installDir) {
  Add-SilentArgument -Buffer $silentArgs -Value ("INSTALLDIR=`"{0}`"" -f $pp.installDir)
}

Add-SilentArgument -Buffer $silentArgs -Value ("SERVER_ACCOUNT_NAME=`"{0}`"" -f $pp.serverUsername)
Add-SilentArgument -Buffer $silentArgs -Value ("SERVER_ACCOUNT_PASSWORD=`"{0}`"" -f $pp.serverPassword)
Add-SilentArgument -Buffer $silentArgs -Value ("SERVER_NAME=`"{0}`"" -f $pp.serverName)

if ($pp.ContainsKey('cwCommunicationPort')) {
  Add-SilentArgument -Buffer $silentArgs -Value ("VAC_CW_COMMUNICATION_PORT={0}" -f $pp.cwCommunicationPort)
}

if ($pp.ContainsKey('vacServerManagementPort')) {
  Add-SilentArgument -Buffer $silentArgs -Value ("VAC_SERVER_MANAGEMENT_PORT={0}" -f $pp.vacServerManagementPort)
}

if ($pp.username) {
  $computername = $env:computername
  $fulluser = $pp.username
  if ($pp.username -notmatch "\\") {
    $fulluser = "$($computername)\$($pp.username)"
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
    }
    else {
      net user $pp.username $pp.password /add /PASSWORDCHG:NO
      wmic UserAccount where ("Name='{0}'" -f $pp.username) set PasswordExpires=False
      net localgroup "Administrators" $pp.username /add
    }
  }

  Add-SilentArgument -Buffer $silentArgs -Value ("USERNAME=`"{0}`"" -f $fulluser)
  Add-SilentArgument -Buffer $silentArgs -Value ("PASSWORD=`"{0}`"" -f $pp.password)
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
  softwareName   = 'Application Server for Veeam ConnectWise Manage Plugin*'
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
  ProductName    = 'ConnectWiseManagePluginServer'
}

Install-VeeamIsoPatchIfNeeded @patchArgs
