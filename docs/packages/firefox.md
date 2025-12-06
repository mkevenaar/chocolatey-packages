# <img src="https://cdn.jsdelivr.net/gh/mkevenaar/chocolatey-packages@f7092bb1e7a5e0d6ca4ea79b41c5928aff418af7/icons/firefox-dev.png" width="32" height="32"/> [![Firefox Developer Edition](https://img.shields.io/chocolatey/v/firefox-dev.svg?label=Firefox+Developer+Edition)](https://community.chocolatey.org/packages/firefox-dev) [![Firefox Developer Edition](https://img.shields.io/chocolatey/dt/firefox-dev.svg)](https://community.chocolatey.org/packages/firefox-dev)

## Usage

To install Firefox Developer Edition, run the following command from the command line or from PowerShell:

```powershell
choco install firefox-dev
```

To upgrade Firefox Developer Edition, run the following command from the command line or from PowerShell:

```powershell
choco upgrade firefox-dev
```

To uninstall Firefox Developer Edition, run the following command from the command line or from PowerShell:

```powershell
choco uninstall firefox-dev
```

## Description

Firefox Browser Developer Edition

Welcome to your new favorite browser. Get the latest features, fast performance, and the development tools you need to build for the open web.

The browser made for developers. All the latest developer tools in beta, plus experimental features like the Multi-line Console Editor and WebSocket Inspector.

A separate profile and path so you can easily run it alongside Release or Beta Firefox.

Preferences tailored for web developers: Browser and remote debugging are enabled by default, as are the dark theme and developer toolbar button.

Additionally, the following experimental developer tools are persistent features of Firefox Developer Edition:

##### [Inactive CSS](https://hacks.mozilla.org/2019/10/firefox-70-a-bountiful-release-for-all/#developertools)

Firefox DevTools now grays out CSS declarations that don’t have an effect on the page. When you hover over the info icon, you’ll see a useful message about why the CSS is not being applied, including a hint about how to fix the problem.

##### [Firefox DevTools](https://mozilladevelopers.github.io/playground/debugger/)

The new Firefox DevTools are powerful, flexible, and best of all, hackable. This includes a best-in-class JavaScript debugger, which can target multiple browsers and is built in React and Redux.

#### [Master CSS Grid](https://mozilladevelopers.github.io/playground/css-grid/)

Firefox is the only browser with tools built specifically for building and designing with CSS Grid. These tools allow you to visualize the grid, display associated area names, preview transformations on the grid and much more.

#### [Fonts Panel](https://developer.mozilla.org/docs/Tools/Page_Inspector/How_to/Edit_fonts)

The new fonts panel in Firefox DevTools gives developers quick access to all of the information they need about the fonts being used in an element. It also includes valuable information such as the font source, weight, style and more.

Additional developer tools also available in the release build (via F12 key): [Responsive Design View](https://developer.mozilla.org/docs/Tools/Responsive_Design_View), [Page Inspector](https://developer.mozilla.org/docs/Tools/Page_Inspector), [Web Console](https://developer.mozilla.org/docs/Tools/Web_Console), [JavaScript Debugger](https://developer.mozilla.org/docs/Tools/Debugger), [Network Monitor](https://developer.mozilla.org/docs/Tools/Network_Monitor), and [Style Editor](https://developer.mozilla.org/docs/Tools/Style_Editor).

## Package Parameters

- `l=<locale>` - Install given Firefox locale. For example `choco install Firefox --params "l=en-GB"`. See the [official page](https://releases.mozilla.org/pub/firefox/releases/latest/README.txt) for a complete list of available locales.

#### Firefox channels (development cycle)

Every 6 weeks, Firefox developers take the current stable features of each build and introduce them into the next stable channel for further development. The Developer Edition is a special build containing features never moved forward since they would be rarely used by the average user and needlessly consume resources.

- [Firefox](https://community.chocolatey.org/packages/firefox)
- [Firefox Beta](https://community.chocolatey.org/packages/firefox-beta)
- Firefox Developer Edition (you are here)
- [Firefox Nightly](https://community.chocolatey.org/packages/firefox-nightly)

[Privacy policy](https://www.mozilla.org/en-US/privacy/firefox/)

**Please Note**: This is an automatically updated package. If you find it is out of date by more than a day or two, please contact the maintainer(s) and let them know [here](https://github.com/mkevenaar/chocolatey-packages/issues) that the package is no longer updating correctly.


## Links

[Chocolatey Package Page](https://community.chocolatey.org/packages/firefox-dev)

[Software Site](https://www.mozilla.org/firefox/developer)

[Package Source](https://github.com/mkevenaar/chocolatey-packages/tree/master/automatic/firefox)

