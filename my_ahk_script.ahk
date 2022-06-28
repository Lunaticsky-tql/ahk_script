#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#SingleInstance Force


Esc & a::
;open explorer.exe
Run "explorer.exe"
return

;search google

Esc & s::
InputBox, OutputVar,Search, google search,,220,130,
if(Outputvar!="")
Run, https://www.google.com/search?q=%OutputVar%
return

;ocr
#z::
Send ^!o
return

;snip
#a::
Send ^!b
return
#+a::
Send ^!a
return