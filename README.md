# Chocolatey Packages
[![Appveyor Build](https://ci.appveyor.com/api/projects/status/github/mkevenaar/chocolatey-packages?svg=true)](https://ci.appveyor.com/project/mkevenaar/chocolatey-packages)
[![](http://transparent-favicon.info/favicon.ico)](#)
[![Update status](https://img.shields.io/badge/Update-Status-blue.svg)](https://gist.github.com/mkevenaar/675e3f672bda54270f8d7f5415f9374d)
[![](http://transparent-favicon.info/favicon.ico)](#)
[![chocolatey/mkevenaar](https://img.shields.io/badge/Chocolatey-mkevenaar-yellowgreen.svg)](https://chocolatey.org/profiles/mkevenaar)

If you have any issues with one of the packages hosted in this repository, please feel free to open an issue (preferred instead of using `Contact Maintainers` on chocolatey.org).

This repository contains [chocolatey automatic packages](https://chocolatey.org/docs/automatic-packages).
The repository is setup so that you can manage your packages entirely from the GitHub web interface (using AppVeyor to update and push packages) and/or using the local repository copy.

## Chocolatey Packages Template

This contains Chocolatey packages, both manually and automatically maintained.

You can choose to use one or both of the different methods currently supported in the Chocolatey community for automatic packaging. They are AU (Automatic Updater) and Ketarin/ChocolateyPackageUpdater.

### Folder Structure

* automatic - where automatic packaging and packages are kept. These are packages that are automatically maintained using either [AU](https://community.chocolatey.org/packages/au) or [Ketarin](https://community.chocolatey.org/packages/ketarin)/[ChocolateyPackageUpdater](https://community.chocolatey.org/packages/chocolateypackageupdater) combo.
* icons - Where you keep icon files for the packages. This is done to reduce issues when packages themselves move around.
* ketarin - where ketarin jobs (aka applications or searches) exported as XML are kept. This is done to allow ease of contribution.
* manual - where packages that are not automatic are kept.
* ops - scripts, jobs, and other items for ensuring automatic packaging.
* setup - items for prepping the system to ensure for auto packaging.

For setting up your own automatic package repository, please see [Automatic Packaging](https://chocolatey.org/docs/automatic-packages)

### Requirements

* Chocolatey (choco.exe)

#### Ketarin / ChocolateyPackageUpdater

* PowerShell v2+
* [Ketarin](https://community.chocolatey.org/packages/ketarin)
* [Chocolatey Package Updater](https://community.chocolatey.org/packages/chocolateypackageupdater)
* A Windows box somewhere - to run the updater on - appveyor can't work until the import of the settings can be automated

#### AU

* PowerShell v5+.
* The [AU module](https://community.chocolatey.org/packages/au).

For daily operations check out the AU packages [template README](https://github.com/majkinetor/au-packages-template/blob/master/README.md).

### Getting started

1. Fork this repository and rename it to `chocolatey-packages` (on GitHub - go into Settings, Repository name and rename).
1. Clone the repository locally.
1. Head into the `setup` folder and perform the proper steps for your choice of setup (or both if you plan to use both methods).
1. Edit this README. Update the badges at the top.


### Recommendation on Auto Packaging

AU provides more in the process of being completely automated, sending emails when things go wrong, and providing a nice report at the end. It doesn't have a bolt-on feeling to it that you see with Ketarin / ChocolateyPackageUdater, however the one thing it does lack in comparison is no visual feedback to seeing how searches for installers may be found. Other than that, it provides errors when things go wrong, where Ketarin doesn't consider anything that happens during "before run"/"post run updates" (where chocopkgup and checksumming occur) to be an error, even if those scripts error.

So for best visibility, enjoying the ease of using AppVeyor, and for a nice report of results, we recommend AU over Ketarin. You also don't need to deal with templates as AU works directly with the xml/ps1 files to do replacement.

### Adapting your current source repository to this source repository template

You want to bring in all of your packages into the proper folders. We suggest using some sort of diffing tool to look at the differences between your current solution and this solution and then making adjustments to it. Pay special attention to the setup folder.

1. Bring over the following files to your package source repository:
 * `automatic\README.md`
 * `icons\README.md`
 * `ketarin\README.md`
 * `ketarin\_KetarinChocolateyTemplate.xml`
 * `manual\README.md`
 * `ops\*.*`
 * `setup\*.*`
 * `.appveyor.yml`
1. Inspect the following file and add the differences:
 * `.gitignore`

### Use Both Methodologies

The way this source repository is designed, you can use both AU and Ketarin/ChocolateyPackageUpdater together. This is especially helpful when migrating existing packages from one methodology to the other.

### Migrating existing Ketarin packages to AU

1. Add an update.ps1 to the package folder and determine how to update the package using [AU's instructions](https://github.com/majkinetor/au#creating-the-package-updater-script).
1. Remove the ketarin.xml file from the ketarin folder.
1. Ensure you also remove the package job from Ketarin itself as it doesn't automatically remove.

### Special Notes

#### Ketarin

* In `Settings -> Global variables` the variable `autoPackagesFolder` is used to determine where your automatic packages are. It doesn't matter what `chocopkgup` is using, this folder is passed through. Ensure this is set appropriately.
* In `Settings -> Global variables` the variable `saveDir` is used to determine where to save the downloaded files from Ketarin. Please ensure the folder exists.
* In `Settings -> Global variables` the variable `nopush` is set to `--nopush`, which allows checksum calculations to occur and then a custom script will push the files.
* In `Settings -> Global variables` the variable `cscript` is set to `2`, which means calculate checksums, rebuild, and push the packages. If you set this to `1` it will do everything except push the packages. Setting this to `1` is how you disable package pushing.
* In `Settings -> Global variables` the variable `checksum` is set to `{checksum}`. Do not change this, this is how the post update script replaces the literal value `{checksum}`. The same goes for `checksumx64`, `packageGuid`, and `url64`.
