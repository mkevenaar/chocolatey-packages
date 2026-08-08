$ErrorActionPreference = 'Stop';

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$appxPackageName = 'com.tinyspeck.slackdesktop'

. (Join-Path $toolsDir 'helper.ps1')

Uninstall-SlackMsix -AppxPackageName $appxPackageName -WarnWhenMissing
