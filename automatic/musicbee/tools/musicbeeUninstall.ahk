#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

WinWait, MusicBee 3.3 Uninstall ahk_class #32770, , 60
BlockInput On
ControlClick, Button1, MusicBee 3.3 Uninstall
BlockInput Off

WinWait, MusicBee 3.1 Uninstall ahk_class #32770, , 60
BlockInput On
ControlClick, OK, MusicBee 3.3 Uninstall
BlockInput Off
