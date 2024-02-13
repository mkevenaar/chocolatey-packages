$ErrorActionPreference = 'Stop'

# clean up old extension
Uninstall-VsCodeExtension -extensionId 'vscoss.vscode-ansible'

Install-VsCodeExtension -extensionId 'redhat.ansible@2.11.137'
