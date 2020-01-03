# <img src="https://cdn.jsdelivr.net/gh/mkevenaar/chocolatey-packages@b40e08792b4d113bcb96960eaa184c093471a01e/icons/firefox-dev.png" width="48" height="48"/> [firefox-dev](https://chocolatey.org/packages/firefox-dev)

Firefox Developer Edition replaces the Aurora channel in the Firefox Release Process. Like Aurora, features will land in the Developer Edition every six weeks, after they have stabilized in Nightly builds.

By using the Developer Edition, you gain access to tools and platform features at least 12 weeks before they reach the main Firefox release channel.

Additionally, the following experimental developer tools are persistent features of Firefox Developer Edition:

##### [WebIDE](https://developer.mozilla.org/docs/Tools/WebIDE)

Allows you to develop, deploy and debug Web apps directly in your browser, or on a Firefox OS device. It lets you create a new Firefox OS app (which is just a web app) from a template, or open up the code of an existing app. From there you can edit the app’s files. It’s one click to run the app in a simulator and one more to debug it with the developer tools. Web IDE - YouTube

##### [Valence](https://developer.mozilla.org/docs/Tools/Firefox_Tools_Adapter) (previously called Firefox Tools Adapter)

Lets you develop and debug your app across multiple browsers and devices by connecting the Firefox dev tools to other major browser engines. Valence also extends the awesome tools we've built to debug Firefox OS and Firefox for Android to the other major mobile browsers including Chrome on Android and Safari on iOS. So far these tools include our Inspector, Debugger and Console and Style Editor.

#### [Web Audio Editor](https://developer.mozilla.org/docs/Tools/Web_Audio_Editor)

Inspect and interact with Web Audio API in real time to ensure that all audio nodes are connected in the way you expect.

Additional developer tools also available in the release build (via F12 key): [Responsive Design View](https://developer.mozilla.org/docs/Tools/Responsive_Design_View), [Page Inspector](https://developer.mozilla.org/docs/Tools/Page_Inspector), [Web Console](https://developer.mozilla.org/docs/Tools/Web_Console), [JavaScript Debugger](https://developer.mozilla.org/docs/Tools/Debugger), [Network Monitor](https://developer.mozilla.org/docs/Tools/Network_Monitor), and [Style Editor](https://developer.mozilla.org/docs/Tools/Style_Editor).

## Package Parameters

- `l=<locale>` - Install given Firefox locale. For example `choco install Firefox --params "l=en-GB"`. See the [official page](https://releases.mozilla.org/pub/firefox/releases/latest/README.txt) for a complete list of available locales.

#### Firefox channels (development cycle)

Every 6 weeks, Firefox developers take the current stable features of each build and introduce them into the next stable channel for further development. The Developer Edition is a special build containing features never moved forward since they would be rarely used by the average user and needlessly consume resources.

- [Firefox](https://chocolatey.org/packages/firefox)
- [Firefox Beta](https://chocolatey.org/packages/firefox-beta)
- Firefox Developer Edition (you are here)
- [Firefox Nightly](https://chocolatey.org/packages/firefox-nightly)

[Mozilla Developer Network documentation](https://developer.mozilla.org/en-US/Firefox/Developer_Edition)
[Privacy policy](https://www.mozilla.org/en-US/privacy/firefox/)

**Please Note**: This is an automatically updated package. If you find it is
out of date by more than a day or two, please contact the maintainer(s) and
let them know the package is no longer updating correctly.
