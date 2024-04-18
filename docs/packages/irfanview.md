# <img src="https://cdn.jsdelivr.net/gh/mkevenaar/chocolatey-packages@8483cf19933cc937b78a8a4523c4b37da5b5b643/icons/irfanview.png" width="32" height="32"/> [![IrfanView (Install)](https://img.shields.io/chocolatey/v/irfanview.svg?label=IrfanView+(Install))](https://community.chocolatey.org/packages/irfanview) [![IrfanView (Install)](https://img.shields.io/chocolatey/dt/irfanview.svg)](https://community.chocolatey.org/packages/irfanview)

## Usage

To install IrfanView (Install), run the following command from the command line or from PowerShell:

```powershell
choco install irfanview
```

To upgrade IrfanView (Install), run the following command from the command line or from PowerShell:

```powershell
choco upgrade irfanview
```

To uninstall IrfanView (Install), run the following command from the command line or from PowerShell:

```powershell
choco uninstall irfanview
```

## Description

![Screenshot of IrfanView](https://www.irfanview.com/images/startbild_engl-small.gif)


IrfanView is a very fast, small, compact and innovative FREEWARE (for non-commercial use) graphic viewer for Windows 9x, ME, NT, 2000, XP, 2003 , 2008, Vista, Windows 7, Windows 8, Windows 10.

It is designed to be simple for beginners and powerful for professionals.

IrfanView seeks to create unique, new and interesting features, unlike some other graphic viewers, whose whole "creativity" is based on feature cloning, stealing of ideas and whole dialogs from ACDSee and/or IrfanView! (for example: XnView has been stealing/cloning features and whole dialogs from IrfanView, for 10+ years).

IrfanView was the first Windows graphic viewer WORLDWIDE with Multiple (animated) GIF support.
One of the first graphic viewers WORLDWIDE with Multipage TIF support.
The first graphic viewer WORLDWIDE with Multiple ICO support.

[Features](http://www.irfanview.com/main_what_is_engl.htm)
[Screenshots](http://www.irfanview.com/screenshot.htm)

#### Package Parameters
The following package parameters may be passed directly to the program's installer with the chocolatey option `-params`:

* `/desktop`      - create desktop shortcut for IrfanView
* `/thumbs`       - create desktop shortcut for IrfanView Thumbnails
* `/group`        - create IrfanView group in Start Menu
* `/currentuser`  - desktop/group links will only install for current user
* `/assocallusers`- set associations for all users (Windows XP only)
* `/assoc=VALUE`  - set file associations; 0 = none (default), 1 = images only, 2 = select all
* `/ini=PATH`     - set custom INI file folder (system environment variables are allowed)
* `/folder=PATH`  - destination folder; if not indicated: old IrfanView folder is used, if not found, the "Program Files" folder is used

#### Package Specifics
If no parameters are passed, the following is assumed: `--params '/assoc=1 /group=1 /ini=%APPDATA%\IrfanView'`.

**[IrfanView All Plugins](https://community.chocolatey.org/packages/irfanviewplugins)**
**[IrfanView All Languages](https://community.chocolatey.org/packages/irfanview-languages)**
**[IrfanView Shell Extension](https://community.chocolatey.org/packages/irfanview-shellextension)**

**Please Note**: This is an automatically updated package. If you find it is
out of date by more than a day or two, please contact the maintainer(s) and
let them know [here](https://github.com/mkevenaar/chocolatey-packages/issues) that the package is no longer updating correctly.


## Links

[Chocolatey Package Page](https://community.chocolatey.org/packages/irfanview)

[Software Site](https://www.irfanview.com/)

[Package Source](https://github.com/mkevenaar/chocolatey-packages/tree/master/automatic/irfanview)

