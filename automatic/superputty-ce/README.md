# <img src="https://cdn.jsdelivr.net/gh/mkevenaar/chocolatey-packages@16c9865113a11ca6482f97f0092c3482896afe02/icons/superputty.png" width="48" height="48"/> [superputty-ce](https://community.chocolatey.org/packages/superputty-ce)

SuperPuTTY Community Edition is an actively maintained, independently published fork of the original SuperPuTTY project. It provides a tabbed Windows workspace for PuTTY, PowerShell, Command Prompt, RDP, VNC and SCP sessions, with signed Windows x64 releases, security improvements and expanded session-management features.

SuperPuTTY was created by Jim Radford and the original contributors. The Community Edition is maintained by Chris Thornton and is not an official upstream SuperPuTTY or PuTTY release.

## Features

* Docking, tabbed user interface for managing many sessions in one window
* Hosts PuTTY (SSH, Telnet, RLogin, Raw), PowerShell and Command Prompt sessions
* RDP and VNC sessions alongside terminal tabs
* Secure file transfer using SCP
* Layouts, including automatic restore of the window arrangement
* Supports PuTTY session configurations including private keys
* Signed releases with published SHA-256 checksums and an SBOM

## Notes

* Requires Windows x64, Windows 10 build 19041 or later and .NET Framework 4.8.
* PuTTY is installed as a dependency. Other connection clients (for example a VNC viewer) must be installed separately.
* This package installs SuperPuTTY CE for all users.
* This is a virtual package that installs [superputty-ce.install](https://community.chocolatey.org/packages/superputty-ce.install).
* Existing SuperPuTTY MSI installations must be removed before installing. Back up `%USERPROFILE%\SuperPuTTY.settings` and your sessions/layouts folder first. See the [upgrade guide](https://github.com/greyhair-atx/superputty/blob/master/docs/manual/upgrading.md).

**Please Note**: This is an automatically updated package. If you find it is
out of date by more than a day or two, please contact the maintainer(s) and
let them know [here](https://github.com/mkevenaar/chocolatey-packages/issues) that the package is no longer updating correctly.
