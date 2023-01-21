#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory.

#SingleInstance Force

#Persistent ; Ensures that the script will continue to run in the background after the initial hotkey is pressed.
previousExe := "" ; Stores the name of the previous executable that was launched.
SetTimer, isActive, 500 ; Checks if the previous executable is still running every 500 milliseconds.
return
isActive:
    {
        WinGET, currentExe, ProcessName, A ;
        if (currentExe = "cmd.exe"||currentExe="WindowsTerminal.exe")
        {
            if (currentExe != previousExe)
            {
                PostMessage, 0x0050, 0, 0x00000409, , A ; ENG keyborad
                previousExe := currentExe
                return
            } else
            {
                return
            }
        } else ; save the currentExe to previousExe
        {
            previousExe := currentExe
            return
        }
    }
#q::
    Send, ^+a
return

;F13
F13::
    Send {Esc}
return

F13 & a::
;open explorer.exe
Run, "explorer.exe"
return
F13 & t::
Send \texttt
return
;search google

F13 & s::
Send {ctrl down}c{ctrl up}
Sleep 40
InputBox, OutputVar,Search, google search,,220,130,,,,,%clipboard%
if ErrorLevel
    return
else if (Outputvar=="")
    return
else
    Run, https://www.google.com/search?q=%OutputVar%

return
;alt
!.::
    Send, 2013599_Ìï¼ÑÒµ
return

;snip
#+a::
    Send, ^+a
return
#a::
    Send, ^!b
return
#z::
    ; Send, ^!o
    Send !+o
return
#!z::
    Send, ^!o
return
#+s::
    Send, ^!a
return
; The following environment parameters must be set, Otherwise, the shortcut key setting is invalid
#UseHook On
Setkeydelay, -1

; It is used to record whether Chinese punctuation is used in the Chinese state of Sogou input method, used by default
ime_us_cn_point := 1

GetIME() ; {{{1
{ ; Gets the active ime language layout of the current window ID Interface, This interface is one of the few interfaces that can correctly query the input method language status
    return DllCall("GetKeyboardLayout", "UInt", DllCall("GetWindowThreadProcessId", "UInt", WinActive("A"), "UInt", 0), "UInt")
}

SwitchIME() ; {{{1
{
    global ime_us_cn_point
    if (GetIME() = 0x8040804) ; = 0x8040804 = chinese
        SendMessage, 0x50, 0, 0x00000409, , A
    else
    {
        SendMessage, 0x50, 0, 0x00000804, , A
        if (ime_us_cn_point)
        {
            sleep 10 ; Dormancy 10 ms To guarantee 100%Success rate
            Send ^.
        }
    }
}

SetIMEtoEn() ; {{{1
{ ; SendMessage It is faster and more stable than sending input method switching shortcut keys, 0x50=WM_INPUTLANGCHANGEREQUEST
    SendMessage, 0x50, 0, 0x00000409, , A
}

SetIMEtoCn() ; {{{1
{ ; SendMessage It is faster and more stable than sending input method switching shortcut keys, 0x50=WM_INPUTLANGCHANGEREQUEST
    global ime_us_cn_point
    SendMessage, 0x50, 0, 0x00000804, , A
    if (ime_us_cn_point)
    {
        sleep 10 ; Dormancy 10 ms To guarantee 100%Success rate
        Send ^.
    }
}

SwitchUseEnPoint() ; {{{1
{
    global ime_us_cn_point
    if (ime_us_cn_point)
        ime_us_cn_point = 0
    else
        ime_us_cn_point = 1
    ; msgbox % ime_us_cn_point
    Send ^.
}

Shift::SwitchIME() ; realization Shift Key switching Chinese and English input method
^.::SwitchUseEnPoint() ; realization Ctrl+. Toggle the "use English punctuation in Chinese" switch effect

F13 & c::
    cur_IME := GetIME()
    SetIMEtoEn()
    Send, {`` 3}C{+}{+}
    Send, {enter}
    sleep 10
    if (cur_IME=0x8040804)
        SetIMEtoCn()
return
::cccn::
    Send aaa
return

;typora
#IfWinActive ahk_exe Typora.exe
    {
        #1::addFontColor("apricot")
        #2::addFontColor("green")
        #3::addFontColor("cornflowerblue")
        #4::addFontColor("cyan")
        #5::addFontColor("purple")
        !1::sendctrl(1)
        !2::sendctrl(2)
        !3::sendctrl(3)
        !4::sendctrl(4)
        !5::sendctrl(5)
        !6::sendctrl(6)
        Esc & q up::addCodeshell()
        Esc & w::addTitle()
        Esc & e::addTitle6()

    }

#IfWinActive ahk_exe Termius.exe
    {

        Esc & q up::qqq()
        Esc & w::wwwqqq()

    }

    qqq()
    {
        Send, :q
        return
    }

    wwwqqq()
    {
        Send, :wq
        return
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
        Sleep 30
        Send,{Asc 096}
        Send,{Asc 096}
        Send,{Asc 096}
        Send,sql
        Send,{Enter}
        Return
    }

    addTitle(){
        Send, ^5
        Return
    }

    sendctrl(num){
        Send, ^%num%
        Return
    }

    addTitle6(){
        Send, ^6
        Return
    }
