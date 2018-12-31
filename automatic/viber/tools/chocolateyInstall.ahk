#NoEnv
SetTitleMatchMode, 1  ;begins
DetectHiddenText, off
DetectHiddenWindows, off
 
winTitle = Viber ahk_class Qt5QWindowIcon
 
WinWait, %winTitle%, , 120
WinClose, %winTitle%
 
ExitApp