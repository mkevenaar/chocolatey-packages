$ErrorActionPreference = 'Stop';
$version = '6.0.44'
$title = 'Zabbix Agent'

$configDir = Join-Path $env:PROGRAMDATA 'zabbix'
$zabbixConf = Join-Path $configDir 'zabbix_agentd.conf'

$installDir = Join-Path $env:PROGRAMFILES $title
$zabbixAgentd = Join-Path $installDir 'zabbix_agentd.exe'

$tempDir = Join-Path $env:TEMP 'chocolatey\zabbix'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$binDir = Join-Path $tempDir 'bin'
$binFiles = @('zabbix_agentd.exe', 'zabbix_get.exe', 'zabbix_sender.exe')
$sampleConfig = Join-Path $tempDir 'conf\zabbix_agentd.conf'

$service = Get-WmiObject -Class Win32_Service -Filter "Name=`'$title`'"

$PackageArgs = @{
  PackageName    = $env:ChocolateyPackageName
  unzipLocation = $tempDir
  file          = "$toolsDir\zabbix_agent-6.0.44-windows-i386-openssl.zip"
  file64        = "$toolsDir\zabbix_agent-6.0.44-windows-amd64-openssl.zip"
}

try {

  if ($service) {
    $service.StopService()
  }
  
  Get-ChocolateyUnzip @PackageArgs

  if (!(Test-Path $configDir)) {
    New-Item $configDir -type directory
  }

  if (!(Test-Path $installDir)) {
    New-Item $installDir -type directory
  }

  foreach ($executable in $binFiles ) {
    $file = Join-Path $binDir $executable
    Move-Item $file $installDir -Force
  }

  if (Test-Path "$installDir\zabbix_agentd.conf") {
    if ($service) {
      $service.Delete()
      Clear-Variable -Name $service
    }

    Move-Item "$installDir\zabbix_agentd.conf" "$configDir\zabbix_agentd.conf" -Force

  }
  elseif (Test-Path "$configDir\zabbix_agentd.conf") {
    $configFile = "$configDir\zabbix_agentd-$version.conf"
    Move-Item $sampleConfig $configFile -Force

  }
  else {
    $configFile = "$configDir\zabbix_agentd.conf"
    Move-Item $sampleConfig $configFile

  }

  if (!($service)) {
    Start-ChocolateyProcessAsAdmin "--config `"$zabbixConf`" --install" "$zabbixAgentd"
  }

  Start-Service -Name $title

  Install-ChocolateyPath $installDir 'Machine'

}
catch {
  Write-Host 'Error installing Zabbix Agent'
  throw $_.Exception
}
