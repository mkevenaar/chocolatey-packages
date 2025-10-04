$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$hadoop_home    = "C:\Hadoop"
$mirrors        = 'https://www.apache.org/dyn/closer.cgi/hadoop/common/hadoop-3.4.2/hadoop-3.4.2.tar.gz'
$checksum32     = 'fe5cb5b4fd4fd0f8dad3a96eb2fdac077a619d74c018bc358ff5608815a2d40a'

# d/l from closest mirror
$get_mirror_page = Invoke-WebRequest -Uri $mirrors -UseBasicParsing
$url32 = $get_mirror_page.links | Where-Object href -match '\.tar\.gz$' | Select-Object -First 1 -expand href

$pp = Get-PackageParameters
if ($pp.unzipLocation) {
    $hadoop_home = $pp.unzipLocation
    Write-Host "Param: Unzipping (installing) to $hadoop_home"
}

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  url           = $url32
  checksum      = $checksum32
  checksumType  = 'sha256'
  validExitCodes= @(0)
}

Install-ChocolateyZipPackage @packageArgs

# unzip tar
Get-ChocolateyUnzip -FileFullPath "$toolsDir\*.tar" -Destination $hadoop_home

Install-ChocolateyEnvironmentVariable `
    -VariableName "HADOOP_HOME" `
    -VariableValue "${hadoop_home}\${env:ChocolateyPackageName}-${env:chocolateyPackageVersion}" `
    -VariableType 'Machine'

Install-ChocolateyPath `
    -PathToInstall "%HADOOP_HOME%\bin" `
    -PathType 'Machine'

# Hadoop needs 8.3 path to find Java
$sp = New-Object -ComObject Scripting.FileSystemObject
$f = $sp.GetFolder($env:JAVA_HOME)

Install-ChocolateyEnvironmentVariable `
    -VariableName "JAVA_HOME" `
    -VariableValue $f.ShortPath `
    -VariableType 'User'

# don't need tar anymore
Remove-Item $toolsDir\*.tar -ErrorAction SilentlyContinue -Force
