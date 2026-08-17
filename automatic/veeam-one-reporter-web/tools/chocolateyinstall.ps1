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

$fileLocation = 'Reporter\VeeamONE.Reporter.WebUI.x64.msi'

$service = Get-Service w3svc -ErrorAction SilentlyContinue
if (-not $service) {
  Write-Warning "IIS is not installed on this machine! `nPlease install IIS on this machine as described on the package page"
  throw "IIS is not installed on this machine! `nPlease install IIS on this machine as described on the package page"
}

$pp = Get-PackageParameters

$parameterValidationRules = @{
  installDir                   = 'String'
  oneServer                   = 'String'
  username                    = 'String'
  password                    = 'String'
  create                      = 'Boolean'
  iisSitePort                 = 'Integer'
  sslThumbprint               = 'String'
  reporterWebServerWebAPIPort = 'Integer'
}

Invoke-PackageParameterValidation -Parameters $pp -Rules $parameterValidationRules -RequiredParameters @('oneServer', 'username', 'password')

$silentArgs = New-Object System.Collections.Generic.List[string]

if ($pp.installDir) {
  Add-SilentArgument -Buffer $silentArgs -Value ("INSTALLDIR=`"{0}`"" -f $pp.installDir)
}

if ($pp.oneServer) {
  Add-SilentArgument -Buffer $silentArgs -Value ("VO_REPORTER_WEB_SERVER_NAME=`"{0}`"" -f $pp.oneServer)
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
  Add-SilentArgument -Buffer $silentArgs -Value ("VO_REPORTER_WEB_CONNECTION_ACCOUNT_NAME=`"{0}`"" -f $fullUser)
  Add-SilentArgument -Buffer $silentArgs -Value ("VO_REPORTER_WEB_CONNECTION_ACCOUNT_PASSWORD=`"{0}`"" -f $pp.password)
}

if ($pp.ContainsKey('iisSitePort')) {
  Add-SilentArgument -Buffer $silentArgs -Value ("VO_REPORTER_WEB_SITE_PORT=`"{0}`"" -f $pp.iisSitePort)
}

if ($pp.sslThumbprint) {
  Add-SilentArgument -Buffer $silentArgs -Value ("VO_REPORTER_WEB_SITE_CERTIFICATE_THUMBPRINT=`"{0}`"" -f $pp.sslThumbprint)
}

if ($pp.ContainsKey('reporterWebServerWebAPIPort')) {
  Add-SilentArgument -Buffer $silentArgs -Value ("VO_REPORTER_WEB_SERVER_WEB_API_PORT=`"{0}`"" -f $pp.reporterWebServerWebAPIPort)
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
  softwareName   = 'Veeam ONE Reporter Web*'
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
  ProductName    = 'ReporterWeb'
}

Install-VeeamIsoPatchIfNeeded @patchArgs
