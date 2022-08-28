SetWinDelay, 10
SetTitleMatchMode, RegEx

; A Window struct, defined by top-left (x,y) and dimensions width x height
Window(x, y, width, height)
{
    return {x: x, y: y, width: width, height: height}
}

#!Left::    SetWindowStruct(GetQuarterWindow(GetPrevQuarterIndex()))
#!Right::   SetWindowStruct(GetQuarterWindow(GetNextQuarterIndex()))
#!^Left::   SetWindowStruct(GetSixthWindow(GetPrevSixthIndex()))
#!^Right::  SetWindowStruct(GetSixthWindow(GetNextSixthIndex()))
#!Numpad0:: SetWindowStruct(GetQuarterWindow(0))
#!Numpad1:: SetWindowStruct(GetQuarterWindow(1))
#!Numpad2:: SetWindowStruct(GetQuarterWindow(2))
#!Numpad3:: SetWindowStruct(GetQuarterWindow(3))

#Up::
w1 := Centered(Window(GetQuarterX(0), GetTopY(), Get2ThirdWidth(), GetFullHeight()))
w2 := Window(GetQuarterX(0), GetTopY(), GetFullWidth(), GetFullHeight())
CycleWindows(w1, w2)
return

#Down::
w1 := Window(GetQuarterX(1), GetTopY(), GetHalfWidth(), GetFullHeight())
w2 := Centered(Window(GetQuarterX(0), GetTopY(), GetThirdWidth(), GetFullHeight()))
CycleWindows(w1, w2)
return

#Left::
w1 := Window(GetQuarterX(0), GetTopY(), GetHalfWidth(), GetFullHeight())
w2 := Window(GetQuarterX(0), GetTopY(), GetThirdWidth(), GetFullHeight())
w3 := Window(GetQuarterX(0), GetTopY(), Get3QuarterWidth(), GetFullHeight())
CycleWindows(w1, w2, w3)
return

#Right::
w1 := Window(GetQuarterX(2), GetTopY(), GetHalfWidth(), GetFullHeight())
w2 := Window(GetThirdX(2), GetTopY(), GetThirdWidth(), GetFullHeight())
w3 := Window(GetQuarterX(1), GetTopY(), Get3QuarterWidth(), GetFullHeight())
CycleWindows(w1, w2, w3)
return

#!Up::
current := GetCurrentWindow()
w1 := Window(current.x, GetTopY(), current.width, GetHalfHeight())
w2 := Window(current.x, GetTopY(), current.width, GetFullHeight())
CycleWindows(w1, w2)
return

#!Down::
current := GetCurrentWindow()
w1 := Window(current.x, GetMidY(), current.width, GetHalfHeight())
w2 := Window(current.x, GetTopY(), current.width, GetFullHeight())
CycleWindows(w1, w2)
return

#!0::
DisplayMessage("{1}", WindowToString(GetCurrentWindow()))
return

Centered(window)
{
    x := A_ScreenWidth // 2 - window.width // 2
    y := A_ScreenHeight // 2 - window.height // 2
    return Window(x, y, window.width, window.height)
}

GetCurrentWindow()
{
    WinGetPos, x, y, width, height, A
    return Window(x, y, width, height)
}

GetCenterX(window)
{
    return window.x + window.width // 2
}

SetWindow(x, y, width, height)
{
    SetWindowStruct(Window(x, y, width, height))
}

SetWindowStruct(window)
{
    WinRestore, A
    WinMove, A,, window.x, window.y, window.width, window.height
}

CycleWindows(windows*)
{
    if (windows.Count() == 0)
    {
        return
    }

    currentWindow := GetCurrentWindow()
    for i, w in windows
    {
        if (IsSame(currentWindow, w))
        {
            SetWindowStruct(windows[Mod(i, windows.Count()) + 1])
            return
        }
    }

    SetWindowStruct(windows[1])
}

IsSame(windows*)
{
    for _, w in windows
    {
        front := windows[1]
        if (w.x != front.x or w.y != front.y or w.width != front.width or w.height != front.height)
        {
            return false
        }
    }
    return true
}

GetPrevQuarterIndex()
{
    currentCenterX := GetCenterX(GetCurrentWindow())
    loop 3
    {
        idx := A_Index
        w := GetQuarterWindow(idx)
        if (currentCenterX <= GetCenterX(w))
        {
            return idx - 1
        }
    }
    return 3
}

GetNextQuarterIndex()
{
    currentCenterX := GetCenterX(GetCurrentWindow())
    loop 3
    {
        idx := 3 - A_Index
        w := GetQuarterWindow(idx)
        if (currentCenterX >= GetCenterX(w))
        {
            return idx + 1
        }
    }
    return 0
}

GetPrevSixthIndex()
{
    currentCenterX := GetCenterX(GetCurrentWindow())
    loop 5
    {
        idx := A_Index
        w := GetSixthWindow(idx)
        if (currentCenterX <= GetCenterX(w))
        {
            return idx - 1
        }
    }
    return 5
}

GetNextSixthIndex()
{
    currentCenterX := GetCenterX(GetCurrentWindow())
    loop 5
    {
        idx := 5 - A_Index
        w := GetSixthWindow(idx)
        if (currentCenterX >= GetCenterX(w))
        {
            return idx + 1
        }
    }
    return 0
}

GetQuarterWindow(index)
{
    return Window(GetQuarterX(index), GetTopY(), GetQuarterWidth(), GetFullHeight())
}

GetSixthWindow(index)
{
    return Window(GetSixthX(index), GetTopY(), GetSixthWidth(), GetFullHeight())
}

GetTopY()
{
    return -GetWindowTopBufferSize()
}

GetMidY()
{
    return GetTopY() + A_ScreenHeight // 2
}

GetQuarterX(idx)
{
    return idx <= 0 ? -GetWindowLeftBufferSize() : GetQuarterX(idx - 1) + A_ScreenWidth // 4
}

GetSixthX(idx)
{
    return idx <= 0 ? -GetWindowLeftBufferSize() : GetSixthX(idx - 1) + A_ScreenWidth // 6
}

GetThirdX(idx)
{
    return idx <= 0 ? -GetWindowLeftBufferSize() : GetThirdX(idx - 1) + A_ScreenWidth // 3
}

GetQuarterWidth()
{
    return A_ScreenWidth // 4 + GetTotalHorizontalBufferSize()
}

GetHalfWidth()
{
    return A_ScreenWidth // 2 + GetTotalHorizontalBufferSize()
}

GetSixthWidth()
{
    return A_ScreenWidth // 6 + GetTotalHorizontalBufferSize()
}

Get3QuarterWidth()
{
    return A_ScreenWidth * 3 // 4 + GetTotalHorizontalBufferSize()
}

GetFullWidth()
{
    return A_ScreenWidth + GetTotalHorizontalBufferSize()
}

GetHalfHeight()
{
    return A_ScreenHeight // 2 + GetTotalVerticalBufferSize()
}

GetFullHeight()
{
    return A_ScreenHeight + GetTotalVerticalBufferSize()
}

GetThirdWidth()
{
    return A_ScreenWidth // 3 + GetTotalHorizontalBufferSize()
}

Get2ThirdWidth()
{
    return A_ScreenWidth * 2 // 3 + GetTotalHorizontalBufferSize()
}

GetTotalHorizontalBufferSize()
{
    return GetWindowLeftBufferSize() + GetWindowRightBufferSize()
}

GetTotalVerticalBufferSize()
{
    return GetWindowTopBufferSize() + GetWindowBottomBufferSize()
}

GetWindowLeftBufferSize()
{
    UNBUFFERED_APPS := ["1Password.exe", "slack.exe", "whatsapp.exe", "excel.exe", "Illustrator.exe", "draw.io"]
    return IsAnyActive(UNBUFFERED_APPS) ? 0 : 8
}

GetWindowRightBufferSize()
{
    UNBUFFERED_APPS := ["1Password.exe", "slack.exe", "whatsapp.exe", "excel.exe", "Illustrator.exe", "draw.io"]
    return IsAnyActive(UNBUFFERED_APPS) ? 0 : 8
}

GetWindowTopBufferSize()
{
    UNBUFFERED_APPS := ["1Password.exe", "slack.exe", "whatsapp.exe", "excel.exe", "Illustrator.exe", "draw.io"]
    return IsAnyActive(UNBUFFERED_APPS) ? 0 : 1
}

GetWindowBottomBufferSize()
{
    UNBUFFERED_APPS := ["1Password.exe", "slack.exe", "whatsapp.exe", "excel.exe", "Illustrator.exe", "draw.io"]
    return IsAnyActive(UNBUFFERED_APPS) ? 0 : 8
}

IsAnyActive(apps)
{
    for _, app in apps
    {
        if (WinActive("ahk_exe " . app))
        {
            return true
        }
    }
    return false
}

WindowToString(window)
{
    return Format("[{3}x{4} @ ({1},{2})]", window.x, window.y, window.width, window.height)
}

DisplayMessage(format, args*)
{
    MsgBox % Format(format, args*)
}