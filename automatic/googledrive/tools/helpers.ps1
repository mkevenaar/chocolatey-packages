$softwareNamePattern = 'Google Drive*'

function Get-InstalledVersion {
  [array] $keys = Get-UninstallRegistryKey -SoftwareName $softwareNamePattern

  if ($keys.Length -ge 1) {
    return [version] ($keys[0].DisplayVersion)
  }

  return $null
}

function Uninstall-CurrentVersion {
  [array] $keys = Get-UninstallRegistryKey -SoftwareName $softwareNamePattern

  if ($keys.Count -eq 1) {
    $keys | ForEach-Object {
      #The uninstaller will always shell itself out to TEMP (regardless of where it starts from),
      #spawn a child process, then terminate. Using Start-Process to wait on the child process too.
      $process = Start-Process -FilePath "$($keys[0].UninstallString)" -ArgumentList @('--silent', '--force_stop') -PassThru -Wait

      if ($process.ExitCode -eq 0) {
        Write-Warning 'Windows must reboot in order to complete the uninstallation.'
      }
      else {
        throw "Uninstallation failed with exit code $($process.ExitCode)!"
      }
    }
  }
  elseif ($keys.Count -eq 0) {
    Write-Warning "$packageName has already been uninstalled by other means."
  }
  elseif ($keys.Count -gt 1) {
    Write-Warning "$($keys.Count) matches found!"
    Write-Warning 'To prevent accidental data loss, no programs will be uninstalled.'
    Write-Warning 'Please alert package maintainer the following keys were matched:'
    $keys | ForEach-Object { Write-Warning "- $($_.DisplayName)" }
  }
}
