# <img src="https://cdn.jsdelivr.net/gh/mkevenaar/chocolatey-packages@8855d884e1b0fbe873de697d8f004dcea104c920/icons/bitvise-ssh-server.png" width="48" height="48"/> [bitvise-ssh-server](https://community.chocolatey.org/packages/bitvise-ssh-server)

Bitvise SSH Server (previously WinSSHD) provides secure remote login capabilities. Security is our SSH server's key feature: in contrast with Telnet and FTP servers, Bitvise SSH Server encrypts data during transmission. Thus, no one can sniff your password or see what files you are transferring when you access your computer over SSH.

Bitvise SSH Server is ideal for remote administration of Windows servers; for advanced users who wish to access their home machine from work, or their work machine from home; as well as for a wide spectrum of advanced tasks, such as establishing a VPN using the SSH TCP/IP tunneling feature, or providing a secure file depository using SFTP.

Personal Edition (installed by default) is free for non-commercial, personal use.  It has the following limitations:

* Can use only local Windows accounts (no domains).
* Can configure only one Windows group ('everyone').
* Can configure only one virtual group.
* Has a limit of 10 Windows account entries.
* Has a limit of 10 virtual account entries.
* GSSAPI authentication is disabled (Kerberos and NTLM).

For any organizational use (non-commercial or commercial) or to remove the limitations of the Personal Edition, it is required to purchase a Standard Edition license and will require re-installing this package with the parameter -standardedition.  See [ssh server license](http://www.bitvise.com/ssh-server-license) for more information.

#### Package Parameters

* `'"/installDir=C:\Path\to\installationdirectory"`' - overwrite the default installation directory
* `'"/site=site-name"`'
* `'"/renameExistingDir=existingDir"`'
* `'"/force"`'
* `'"/acceptEULA"`'
* `'"/interactive"`'
* `'"/noRollback"`'
* `'"/activationCode=activation-code-hex"`'
* `'"/keypairs=keypairs-file"`'
* `'"/settings=settings-file"`'
* `'"/instanceTypeSettings=fileName"`'
* `'"/certificates=fileName"`'
* `'"/startService"`'
* `'"/startBssCtrl"`'

Note: Use two single quotes when double quotes are desired."

#### Example

* `choco install bitvise-ssh-server -params '"/InstallLocation=C:\temp"'`

**Please Note**: This is an automatically updated package. If you find it is
out of date by more than a day or two, please contact the maintainer(s) and
let them know [here](https://github.com/mkevenaar/chocolatey-packages/issues) that the package is no longer updating correctly.
