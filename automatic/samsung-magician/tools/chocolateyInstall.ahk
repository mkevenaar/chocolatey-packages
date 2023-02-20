#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#NoTrayIcon
#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetTitleMatchMode, 1
SetControlDelay -1

winTitleInstall = Setup - Samsung Magician

WinWait, Select Setup Language, , 300
WinActivate
; BlockInput, Off

; Language selection
ControlClick, OK, Select Setup Language,,,, NA

; Welcome screen
WinWait, %winTitleInstall%
ControlClick, &Next, %winTitleInstall%,,,, NA

; License terms
WinWait, %winTitleInstall%, License Agreement
ControlClick, I &accept the agreement, %winTitleInstall%,,,, NA
ControlClick, &Next, %winTitleInstall%,,,, NA

; Collection and Use of Personal Information
WinWait, %winTitleInstall%, Collection and Use
ControlClick, I &accept the agreement, %winTitleInstall%,,,, NA
ControlClick, &Next, %winTitleInstall%,,,, NA

; Icons
WinWait, %winTitleInstall%, Select Additional
ControlClick, &Next, %winTitleInstall%,,,, NA

WinWait, %winTitleInstall%, Ready to Install
ControlClick, &Install, %winTitleInstall%,,,, NA

; Wait until the install process is finished
WinWait, %winTitleInstall%, Completing
if !(ErrorLevel) {
  ControlClick, &Finish, %winTitleInstall%,,,, NA
}
