#Requires AutoHotkey v2.0
#Warn
#SingleInstance Force
SetTitleMatchMode(1)
SetControlDelay(-1)

winTitleDialog := "Setup" ; Common title for dialog windows
dialogClass := "ahk_class #32770"

; The GDPR/Brazil residency prompt can come before or after the language selection (9.0.2 shows
; it first), so answer it from a timer whenever it appears. Argument 1 picks the answer: Yes or No (default).
gdprButton := (A_Args.Length >= 1 && A_Args[1] = "Yes") ? "&Yes" : "&No"
SetTimer(AnswerGdprPrompt, 250)

AnswerGdprPrompt()
{
  prompt := winTitleDialog " " dialogClass
  try
  {
    if WinExist(prompt) && InStr(WinGetText(prompt), "GDPR country")
      ControlClick(gdprButton, prompt, , , , "NA")
  }
}

; Step 1: Language selection
WinWait("Select Setup Language", , 30000)
if WinExist("Select Setup Language")
{
  WinActivate
  ControlClick("OK", "Select Setup Language")
}

; Step 2: an upgrade may ask whether to continue over the existing installation. Wait for that
; dialog or the welcome screen, whichever comes first (the GDPR prompt is handled by the timer).
Loop
{
  if WinExist("Setup - Samsung Magician", "Welcome to the Samsung Magician Setup Wizard")
    break
  try
  {
    if WinExist(winTitleDialog " " dialogClass) && InStr(WinGetText(winTitleDialog " " dialogClass), "Samsung Magician is already installed")
    {
      WinActivate
      ControlClick("&Yes", winTitleDialog " " dialogClass) ; Click "Yes"
    }
  }
  Sleep(250)
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
