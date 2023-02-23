#Requires AutoHotkey v2.0
#Warn  ; Enable warnings to assist with detecting common errors.
#NoTrayIcon
SetTitleMatchMode 1
SetControlDelay -1

winTitleInstall := "Setup - Samsung Magician"

WinWait("Select Setup Language",, 300)

if WinExist("Select Setup Language")
  WinActivate

; Language selection
WinWait("ahk_class TSelectLanguageForm")
ControlClick "OK", "Select Setup Language",,,, "NA"

; Wait for the overwrite confirmation dialog (for upgrades/forced reinstalls)
SetTitleMatchMode("Regex")
WinWait("ahk_class i)#32770|TWizardForm ahk_exe Samsung_Magician_installer.tmp")
if WinExist("ahk_class #32770 ahk_exe Samsung_Magician_installer.tmp") {
  ; Overwrite confirmation dialog
  ControlClick "&Yes", "ahk_class #32770 ahk_exe Samsung_Magician_installer.tmp",,,, "NA"
}

; Welcome screen
WinWait("ahk_class TWizardForm ahk_exe Samsung_Magician_installer.tmp")
SetTitleMatchMode 1
ControlClick "&Next", winTitleInstall,,,, "NA"

; License terms
sleep 1000
ControlClick "I &accept the agreement", winTitleInstall,,,, "NA"
sleep 1000
ControlClick "&Next", winTitleInstall,,,, "NA"

; Collection and Use of Personal Information
sleep 1000
ControlClick "I &accept the agreement", winTitleInstall,,,, "NA"
sleep 1000
ControlClick "&Next", winTitleInstall,,,, "NA"

; Additional tasks
sleep 1000
ControlClick "&Next", winTitleInstall,,,, "NA"

; Ready to install
sleep 1000
ControlClick "&Install", winTitleInstall,,,, "NA"

; Wait until the install process is finished
WinWait(winTitleInstall, "Completing")

; Finish
sleep 1000
ControlClick "&Finish", winTitleInstall,,,, "NA"
