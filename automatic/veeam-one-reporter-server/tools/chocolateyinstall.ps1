$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$fileLocation = 'D:\Veeam\VeeamONE.10.0.0.750\Reporter\VeeamONE.Reporter.Server.x64.msi'

#Based on Msi
$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'Veeam ONE Reporter Server*'
  file          = $fileLocation
  fileType      = 'msi'
  silentArgs    = "/qn /norestart /l*v `"$env:TEMP\$env:ChocolateyPackageName.$env:ChocolateyPackageVersion.log`""
  validExitCodes= @(0,1641,3010)
  url           = ""
  checksum      = '1DDD69B563A67D07BCE69D241A3FA36FDAEB0794555A947E573A9F01717CC7FD'
  checksumType  = 'sha256'
  url64bit      = ""
  checksum64    = ''
  checksumType64= 'sha256'
  destination   = $toolsDir
  #installDir   = "" # passed when you want to override install directory - requires licensed editions 1.9.0+
}

Install-ChocolateyInstallPackage @packageArgs

<#
== MSI Properties ==
These are the PROPERTIES of the MSI, some of which you can add or change to the silent args or add as package parameters
Note: This only captures what ends up in the MSI Property/AppSearch tables and is not guaranteed to cover all properties.


RESTARTSQL=**Property found in SecureCustomProperties**
VM_BACKUP_ADD_TYPE_STR=Veeam Backup &amp;amp; Replication
VM_HV_TYPE_STR=SCVMM Server
VM_VC_SELECTED_TYPE=**Property found in SecureCustomProperties**
VM_RP_IIS_SITE_PORT=**Property found in SecureCustomProperties**
RP_CERTNAME=**Property found in SecureCustomProperties**
VM_RP_SQL_AUTHENTICATION_TXT=**Property found in SecureCustomProperties**
VM_RP_SQL_DATABASE=**Property found in SecureCustomProperties**
VM_RP_VC_PORT=443
COMBOBOX_USER_ACCOUNTS_PROPERTY=VM_RP_SERVICEACCOUNT
ALLUSERS=1
CERTIFICATES_COMBOBOX_ADD_GENERATE_NEW=1
CERTIFICATES_COMBOBOX_PROPERTY=RP_CERTNAME
DWUSINTERVAL=30
DWUSLINK=CEABF74FFEAC7758DEAC90A8EE1C978FB9FC908F599B90D8CEABA088D9ABD00FB99CE09F6EAC
INSTALLLEVEL=100
ISCHECKFORPRODUCTUPDATES=1
ISVROOT_PORT_NO=0
IS_COMPLUS_PROGRESSTEXT_COST=Costing COM+ application: [1]
IS_COMPLUS_PROGRESSTEXT_INSTALL=Installing COM+ application: [1]
IS_COMPLUS_PROGRESSTEXT_UNINSTALL=Uninstalling COM+ application: [1]
IS_PREVENT_DOWNGRADE_EXIT=A newer version of this application is already installed on this computer. If you wish to install this version, please uninstall the newer version first. Click OK to exit the wizard.
IS_PROGMSG_TEXTFILECHANGS_REPLACE=Replacing %s with %s in %s...
IS_PROGMSG_XML_COSTING=Costing XML files...
IS_PROGMSG_XML_CREATE_FILE=Creating XML file %s...
IS_PROGMSG_XML_FILES=Performing XML file changes...
IS_PROGMSG_XML_REMOVE_FILE=Removing XML file %s...
IS_PROGMSG_XML_ROLLBACK_FILES=Rolling back XML file changes...
IS_PROGMSG_XML_UPDATE_FILE=Updating XML file %s...
MSIRESTARTMANAGERCONTROL=Disable
VM_RP_SERVICEPASSWORD=**Property found in SecureCustomProperties**
VM_RP_SQL_PASSWORD=**Property found in SecureCustomProperties**
VM_RP_VC_PWD=**Property found in MsiHiddenProperties**
VM_RP_VC_PROXY_PWD=**Property found in SecureCustomProperties**
VM_RP_SQL_CONNECTION_STRING=**Property found in SecureCustomProperties**
VM_BSCW_PASSWORD=**Property found in MsiHiddenProperties**
VM_VC_HOST_PWD=**Property found in MsiHiddenProperties**
IS_SQLSERVER_CONNECTION_STR_NOCATALOG=**Property found in MsiHiddenProperties**
VMONE_SQL_PASSWORD=**Property found in MsiHiddenProperties**
VM_VC_HOST_PWD_TESTED=**Property found in MsiHiddenProperties**
VM_BACKUP_ADD_PWD=**Property found in MsiHiddenProperties**
VM_BSCW_SERVICEPASSWORD=**Property found in MsiHiddenProperties**
VMONE_SERVICE_PASSWORD=**Property found in MsiHiddenProperties**
PARTITIONS=Business Unit; Department; Purpose
PROGMSG_IIS_CREATEAPPPOOL=Creating application pool %s
PROGMSG_IIS_CREATEAPPPOOLS=Creating application Pools...
PROGMSG_IIS_CREATEVROOT=Creating IIS virtual directory %s
PROGMSG_IIS_CREATEVROOTS=Creating IIS virtual directories...
PROGMSG_IIS_CREATEWEBSERVICEEXTENSION=Creating web service extension
PROGMSG_IIS_CREATEWEBSERVICEEXTENSIONS=Creating web service extensions...
PROGMSG_IIS_CREATEWEBSITE=Creating IIS website %s
PROGMSG_IIS_CREATEWEBSITES=Creating IIS websites...
PROGMSG_IIS_EXTRACT=Extracting information for IIS virtual directories...
PROGMSG_IIS_EXTRACTDONE=Extracted information for IIS virtual directories...
PROGMSG_IIS_REMOVEAPPPOOL=Removing application pool
PROGMSG_IIS_REMOVEAPPPOOLS=Removing application pools...
PROGMSG_IIS_REMOVESITE=Removing web site at port %d
PROGMSG_IIS_REMOVEVROOT=Removing IIS virtual directory %s
PROGMSG_IIS_REMOVEVROOTS=Removing IIS virtual directories...
PROGMSG_IIS_REMOVEWEBSERVICEEXTENSION=Removing web service extension
PROGMSG_IIS_REMOVEWEBSERVICEEXTENSIONS=Removing web service extensions...
PROGMSG_IIS_REMOVEWEBSITES=Removing IIS websites...
PROGMSG_IIS_ROLLBACKAPPPOOLS=Rolling back application pools...
PROGMSG_IIS_ROLLBACKVROOTS=Rolling back virtual directory and web site changes...
PROGMSG_IIS_ROLLBACKWEBSERVICEEXTENSIONS=Rolling back web service extensions...
PSASNAPINNAME=ReporterDBSnapIn
SHOWLAUNCHPROGRAM=0
SITE_SHORTCUT_PROTOCOL=https://
EDITLICFILEPATH=**Property found in SecureCustomProperties**
IISROOTFOLDER=**Property found in SecureCustomProperties**
IIS_VERSION=**Property found in SecureCustomProperties**
INSTALLDIR=**Property found in SecureCustomProperties**
ISFOUNDNEWERPRODUCTVERSION=**Property found in SecureCustomProperties**
ISMAJORUP=**Property found in SecureCustomProperties**
IS_SQLSERVER_LIST=**Property found in SecureCustomProperties**
PF_VEEAMONE=**Property found in SecureCustomProperties**
POWERSHELLSTATUS=**Property found in SecureCustomProperties**
RAWERRORTXT=**Property found in SecureCustomProperties**
SHOWSQLSETTINGS=**Property found in SecureCustomProperties**
SUPPORTDIR=**Property found in SecureCustomProperties**
VM_RP_IIS_SITE_ID=0
VM_RP_IIS_SITE_VDIR=/
VM_RP_LIC_FILE_PATH=**Property found in SecureCustomProperties**
VM_RP_SERVICEACCOUNT=**Property found in SecureCustomProperties**
VM_RP_SQLSERVER_ENC_STR=**Property found in SecureCustomProperties**
VM_RP_SQL_AUTHENTICATION=0
VM_RP_SQL_SERVER=**Property found in SecureCustomProperties**
VM_RP_SQL_SERVER_INSTANCE=**Property found in SecureCustomProperties**
VM_RP_SQL_SERVER_INSTANCE_PART=**Property found in SecureCustomProperties**
VM_RP_SQL_SERVER_NAME_PART=**Property found in SecureCustomProperties**
VM_RP_SQL_USER=**Property found in SecureCustomProperties**
VM_RP_VC_IS_VC=**Property found in SecureCustomProperties**
VM_RP_VC_PROXY_HOST=**Property found in SecureCustomProperties**
VM_RP_VC_PROXY_USER=**Property found in SecureCustomProperties**
VM_RP_VC_USE_PROXY=**Property found in SecureCustomProperties**
WEBSITEDIR_OLD=**Property found in SecureCustomProperties**
VO_INSTALLATION_TYPE=**Property found in SecureCustomProperties**
UNSUPPORTED_VERSION=**Property found in SecureCustomProperties**
ACCEPT_THIRDPARTY_LICENSES=**Property found in SecureCustomProperties**
UPDATE_HOST=setup.butler.veeam.com
UPDATE_TPL=/api/v1/license/update?license=%s
VEEAM_COLLECT_OS_VERSION=1
VM_BACKUP_ADD_PORT=9443
VM_BACKUP_ADD_TYPE=0
VM_BACKUP_ADD_TYPE_STR_1=Veeam Backup &amp;amp; Replication
VM_BACKUP_ADD_TYPE_STR_2=Veeam Backup Enterprise Manager
VM_HV_TYPE=0
VM_ISSITEUPGRADE=0
VM_ONE_WIZARD=0
VM_RP_DEFAULT_REGKEY=SOFTWARE\\VeeaM\\Reporter Enterprise
VM_RP_IIS_SITE_NAME=VeeamReporter
VM_RP_SITE_APPPOOL=VeeamReporter
VM_WEBCONFIG_EXTERNALDATASOURCE=false
IISROOTFOLDER_OLD=**Value is determined by MSI function**
IIS_VERSION_OLD=**Value is determined by MSI function**
INSTALLDIR_OLD=**Value is determined by MSI function**
VM_RP_OLD_PORT_OLD=**Value is determined by MSI function**
VM_RP_SQL_AUTHENTICATION_OLD=**Value is determined by MSI function**
VM_RP_SQL_CONNECTION_STRING_OLD=**Value is determined by MSI function**
VM_RP_SQL_DATABASE_OLD=**Value is determined by MSI function**
VM_RP_SQL_SERVER_INSTANCE_OLD=**Value is determined by MSI function**
VM_RP_SQL_SERVER_OLD=**Value is determined by MSI function**
VM_RP_SQL_USER_OLD=**Value is determined by MSI function**
#>

