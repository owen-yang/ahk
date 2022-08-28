#IfWinActive ahk_exe sublime_text.exe

; Use forward/back mouse buttons to jump locations
XButton1:: Send !-
XButton2:: Send !=

#IfWinActive


#IfWinActive ahk_exe thunderbird.exe

; Open a link from Thunderbird in an incognito Chrome window
; Alt-Ctrl-Shift-NumpadSub is the hotkey, and a mouse button is mapped to this hotkey
^!+NumpadSub::
savedClipboard := Clipboard
Clipboard :=
Sleep 100
Send {RButton}
Sleep 50
Send C
Sleep 50
if (InStr(Clipboard, "http") == 1)
{
    Run "C:\Program Files\Google\Chrome\Application\chrome.exe" "-incognito" "--single-argument" %Clipboard%
}
Clipboard := savedClipboard
return

#IfWinActive

#IfWinActive ahk_exe chrome.exe

; Refresh a Chrome tab
; Alt-Ctrl-Shift-NumpadAdd is the hotkey, and a mouse button is mapped to this hotkey
^!+NumpadAdd::
Send ^r
return

#IfWinActive