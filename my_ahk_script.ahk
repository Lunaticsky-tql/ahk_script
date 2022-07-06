#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory.

#SingleInstance Force

#Persistent                                           ; 使脚本永久运行
previousExe := ""                                     ; 自定义一个变量，用于存储上一个活动窗口的 ProcessName
SetTimer, isActive, 500                               ; 每 0.5 秒执行一次 isActive 标签下的内容
return
isActive:
{
    WinGET, currentExe, ProcessName, A                ; 使用 WinGet 函数，获取当前活动窗口的 ProcessName，存储在 currentExe 变量中
    if (currentExe = "cmd.exe")           ; 如果当前活动窗口是 WindowsTerminal，则执行的代码
    {
        if (currentExe != previousExe)                
        {
            PostMessage, 0x0050, 0, 0x00000409, , A   ; 切换为美式键盘
            previousExe := currentExe
            return
        } else 
        {
            return
        }
    } else                                            ; 如果当前活动窗口不是 WindowsTerminal，则执行的代码
    {
        previousExe := currentExe
        return
    }
}



~Esc & a::
    ;open explorer.exe
    Run, "explorer.exe"
return

;search google

~Esc & s::
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

;pin window on top
#w:: 
    Send, !+z
return
#q:: 
    Send, !+a
return

;ocr
#z::
    Send, ^!o
return

;snip
#+a::
    Send, ^!b
return
#a::
    Send, ^!q
return
#+s::
    Send, ^+a
return

; ;englesh symbol style
; `::
;     Send {Asc 096} ;output `~
; return
; /::
;     Send {Asc 047} ;output /
; return
; !/::
;     Send 、
; return
; ]::
;     Send {Asc 093} ;output ]
; return
; [::
;     Send {Asc 091} ;output [
; return
; \::
;     Send {Asc 092} ;output \
; return
; $::
;     Send {Asc 036} ;output $
; return

; Global bad environment settings ; {{{1

; The following environment parameters must be set, Otherwise, the shortcut key setting is invalid
#UseHook On
Setkeydelay, -1

; It is used to record whether Chinese punctuation is used in the Chinese state of Sogou input method, Not used by default
ime_us_cn_point := 0

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

;typora
#IfWinActive ahk_exe Typora.exe
    {
        #1::addFontColor("apricot")
        #2::addFontColor("green")
        #3::addFontColor("cornflowerblue")
        #4::addFontColor("cyan") 
        #5::addFontColor("purple")
        Esc & q up::addCodeshell()
        Esc & w::addTitle()

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
        Send,shell
        Send,{Enter}
        Return
    } 

    addTitle(){
        Send, ^5
        Return
    } 

