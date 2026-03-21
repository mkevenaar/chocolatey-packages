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

$fileLocation = 'ApplicationServer\VAC.CommunicationAgent.x64.msi'

$pp = Get-PackageParameters
$parameterValidationRules = @{
  installDir                   = 'String'
  vacAgentAccountType          = 'OneOrTwo'
  vacConnectionAccount         = 'String'
  vacConnectionAccountPassword = 'String'
  vacManagementAgentTagName    = 'String'
}

Invoke-PackageParameterValidation -Parameters $pp -Rules $parameterValidationRules

$silentArgs = New-Object System.Collections.Generic.List[string]

if ($pp.installDir) {
  Add-SilentArgument -Buffer $silentArgs -Value ("INSTALLDIR=`"{0}`"" -f $pp.installDir)
}

$agentAccountType = if ($pp.ContainsKey('vacAgentAccountType')) { $pp.vacAgentAccountType } else { '1' }
Add-SilentArgument -Buffer $silentArgs -Value ("VAC_AGENT_ACCOUNT_TYPE={0}" -f $agentAccountType)

if ($agentAccountType -eq '2') {
  if (-not $pp.vacConnectionAccountPassword -or -not $pp.vacConnectionAccount) {
    throw 'vacConnectionAccount and vacConnectionAccountPassword are required when using vacAgentAccountType equals 2...'
  }
  Add-SilentArgument -Buffer $silentArgs -Value ("VAC_CONNECTION_ACCOUNT=`"{0}`"" -f $pp.vacConnectionAccount)
  Add-SilentArgument -Buffer $silentArgs -Value ("VAC_CONNECTION_ACCOUNT_PASSWORD=`"{0}`"" -f $pp.vacConnectionAccountPassword)
}

if ($pp.ContainsKey('vacManagementAgentTagName')) {
  Add-SilentArgument -Buffer $silentArgs -Value ("VAC_MANAGEMENT_AGENT_TAG_NAME=`"{0}`"" -f $pp.vacManagementAgentTagName)
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
  softwareName   = 'Veeam Service Provider Console Management Agent*'
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
  ProductName    = 'ManagementAgent'
}

Install-VeeamIsoPatchIfNeeded @patchArgs
