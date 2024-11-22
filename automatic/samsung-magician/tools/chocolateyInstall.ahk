#Requires AutoHotkey v2.0
#Warn
#SingleInstance Force
SetTitleMatchMode(1)
SetControlDelay(-1)

winTitleDialog := "Setup" ; Common title for dialog windows
dialogClass := "ahk_class #32770"

; Step 1: Language selection
WinWait("Select Setup Language", , 30000)
if WinExist("Select Setup Language")
{
  WinActivate
  ControlClick("OK", "Select Setup Language")
}

; Step 2 and Step 3: Handle dialogs dynamically
WinWait(winTitleDialog " " dialogClass, , 30000) ; Wait for the "Setup" dialog with the specified class

; Retrieve the full visible text of the dialog
dialogContent := WinGetText(winTitleDialog " " dialogClass)

; Debugging: Uncomment this to view the retrieved text
; MsgBox("Dialog Content: " dialogContent)

; Determine if it's the "Already Installed" or GDPR dialog
if InStr(dialogContent, "Samsung Magician is already installed")
{
  ; Handle "Already Installed" dialog
  WinActivate
  ControlClick("&Yes", winTitleDialog " " dialogClass) ; Click "Yes"

  ; Handle GDPR prompt
  WinWait(winTitleDialog " " dialogClass, "Are you a resident of a European country (GDPR country) or Brazil?", , 30000)
  WinActivate
  ControlClick("&No", winTitleDialog " " dialogClass) ; Click "No"

}
else if InStr(dialogContent, "Are you a resident of a European country (GDPR country) or Brazil?")
{
  ; Handle GDPR prompt
  WinActivate
  ControlClick("&No", winTitleDialog " " dialogClass) ; Click "No"
}

; Step 4: Welcome screen
WinWait("Setup - Samsung Magician", "Welcome to the Samsung Magician Setup Wizard", , 30000)
WinActivate
ControlClick("&Next", "Setup - Samsung Magician")

; Step 5: License agreement
WinWait("Setup - Samsung Magician", "License Agreement", , 30000)
ControlClick("I &accept the agreement", "Setup - Samsung Magician")
ControlClick("&Next", "Setup - Samsung Magician")

; Step 6: Collection and Use of Personal Information
WinWait("Setup - Samsung Magician", "Collection and Use of Personal Information", , 15000)
ControlClick("I &accept the agreement", "Setup - Samsung Magician")
ControlClick("&Next", "Setup - Samsung Magician")

; Step 7: Additional tasks
WinWait("Setup - Samsung Magician", "Select Additional Tasks", , 15000)
ControlClick("&Next", "Setup - Samsung Magician")

; Step 8: Ready to install
WinWait("Setup - Samsung Magician", "Ready to Install", , 15000)
ControlClick("&Install", "Setup - Samsung Magician")

; Step 9: Completing installation
WinWait("Setup - Samsung Magician", "Completing the Samsung Magician Setup Wizard", , 15000)
ControlClick("&Finish", "Setup - Samsung Magician")

; Step 10: Close main window)
; Wait for the loading window to appear & disappear
WinWait("Samsung Magician ahk_exe SamsungMagician.exe ahk_class Chrome_WidgetWin_1", , 180000)
Sleep(10000)
; Wait for the actual window to appear
WinWait("Samsung Magician ahk_exe SamsungMagician.exe ahk_class Chrome_WidgetWin_1", , 30000)
WinClose
