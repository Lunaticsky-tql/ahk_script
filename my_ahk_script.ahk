#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#SingleInstance Force


Esc & a::
;open explorer.exe
Run, "explorer.exe"
return

;search google

Esc & s::
InputBox, OutputVar,Search, google search,,220,130,
if(Outputvar!="")
Run, https://www.google.com/search?q=%OutputVar%
return

;pin window on top
#w:: 
Send, !z
return
#q:: 
Send, !a
return

;ocr
#z::
Send, ^!o
return

;snip
#a::
Send, ^!b
return
#+a::
Send, ^!a
return

;englesh symbol style
`::
Send {Asc 096} ;output `~
return
/::
Send {Asc 047} ;output /
return
!/::
Send 、
return
]::
Send {Asc 093} ;output ]
return
[::
Send {Asc 091} ;output [
return
\::
Send {Asc 092} ;output \
return
$::
Send {Asc 036} ;output $
return

;typora
#IfWinActive ahk_exe Typora.exe
{
    #1::addFontColor("apricot")
    #2::addFontColor("green")
    #3::addFontColor("cornflowerblue")
    #4::addFontColor("cyan") 
    #5::addFontColor("purple")
    Esc & q::addCodeshell()
}
addFontColor(color){
    clipboard := "" 
    Send {ctrl down}c{ctrl up} 
    ; SendInput {Text} 
    SendInput {TEXT}<font color='%color%'>
    SendInput {ctrl down}v{ctrl up}
    If(clipboard = ""){
        SendInput {TEXT}</font>
    }else{
        SendInput {TEXT}</ 
    }
}
addCodeshell(){
Send,{Asc 096}
Send,{Asc 096}
Send,{Asc 096}
Send,shell
Send,{Enter}
Return
} 

