#NoEnv
SetTitleMatchMode, 1  ;begins

winTitle = SpeedFan ahk_class #32770

WinWait, %winTitle%, Do you want to remove any custom configuration, 30
ControlClick, Button1, %winTitle%, &Yes

ExitApp