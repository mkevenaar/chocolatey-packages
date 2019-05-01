Import-Module AU
Import-Module "$env:ChocolateyInstall\helpers\chocolateyInstaller.psm1"
Import-Module "$PSScriptRoot\..\..\scripts/au_extensions.psm1"

function global:au_SearchReplace {
    @{
        '.\tools\chocolateyInstall.ps1' = @{
            "(^[$]url32\s*=\s*)('.*')"      = "`$1'$($Latest.URL32)'"
            "(^[$]checksum32\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
            "(^[$]checksumType32\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
            "(^[$]url64\s*=\s*)('.*')"      = "`$1'$($Latest.URL64)'"
            "(^[$]checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
            "(^[$]checksumType64\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType64)'"
        }
     }
}

function Get-MsiDatabaseVersion {
  param (
      [string] $fn
  )
  Process {
    try {
      $FullPath = (Resolve-Path $fn).Path
      $windowsInstaller = New-Object -com WindowsInstaller.Installer

      $database = $windowsInstaller.GetType().InvokeMember(
              "OpenDatabase", "InvokeMethod", $Null, 
              $windowsInstaller, @($FullPath, 0)
          )

      $q = "SELECT Value FROM Property WHERE Property = 'ProductVersion'"
      $View = $database.GetType().InvokeMember(
              "OpenView", "InvokeMethod", $Null, $database, ($q)
          )

      $View.GetType().InvokeMember("Execute", "InvokeMethod", $Null, $View, $Null)

      $record = $View.GetType().InvokeMember(
              "Fetch", "InvokeMethod", $Null, $View, $Null
          )

      $productVersion = $record.GetType().InvokeMember(
              "StringData", "GetProperty", $Null, $record, 1
          )

      $View.GetType().InvokeMember("Close", "InvokeMethod", $Null, $View, $Null)
      $record = $Null
      $View = $Null

      return $productVersion.Trim()

    } catch {
      throw "Failed to get MSI file version the error was: {0}." -f $_
    }
  }
  End {
    # Run garbage collection and release ComObject
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($windowsInstaller) | Out-Null
    [System.GC]::Collect()
  }
}

function GetResultInformation([string]$url32, [string]$url64) {
  $dest = "$env:TEMP\serverbackup.msi"

  Get-WebFile $url32 $dest | Out-Null
  $checksumType = 'sha256'
  $version = (Get-MsiDatabaseVersion $dest).Trim()
  $checksum32 = Get-FileHash $dest -Algorithm $checksumType | % Hash
  Remove-Item -force $dest -ErrorAction SilentlyContinue

  return @{
    URL32          = $url32
    URL64          = $url64
    Version        = $version
    Checksum32     = $checksum32
    ChecksumType32 = $checksumType
    Checksum64     = Get-RemoteChecksum $url64 -Algorithm $checksumType
    ChecksumType64 = $checksumType
  }
}

function global:au_GetLatest {
  $url32 = 'http://repo.r1soft.com/trials/ServerBackup-Windows-Agent-x86.msi'
  $url64 = 'http://repo.r1soft.com/trials/ServerBackup-Windows-Agent-x64.msi'

  Update-OnETagChanged -execUrl $url32 `
    -OnETagChanged {
    GetResultInformation $url32 $url64
  } -OnUpdated { @{ URL32 = $url32 ; URL64 = $url64 }}
}

update -ChecksumFor none