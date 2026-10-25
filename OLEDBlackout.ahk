#Requires AutoHotkey v2.0
#SingleInstance Force
Persistent

global windows := []
global active := false
global currentHotkey := "^!b"
global settingsPath := A_AppData "\OLEDBlackout\settings.ini"
DirCreate(A_AppData "\OLEDBlackout")
currentHotkey := IniRead(settingsPath, "Settings", "Hotkey", "^!b")

A_TrayMenu.Delete()
A_TrayMenu.Add("Toggle blackout", (*) => Toggle())
A_TrayMenu.Add("Change hotkey...", (*) => ChangeHotkey())
A_TrayMenu.Add("Start with Windows", (*) => ToggleStartup())
A_TrayMenu.Add()
A_TrayMenu.Add("Exit", (*) => ExitApp())
A_TrayMenu.Default := "Toggle blackout"
try Hotkey(currentHotkey, (*) => Toggle(), "On")
catch {
    currentHotkey := "^!b"
    Hotkey(currentHotkey, (*) => Toggle(), "On")
}
if !FileExist(StartupLink())
    EnableStartup()
UpdateMenu()

Toggle() {
    global active
    if active
        Restore()
    else
        Blackout()
}
Blackout() {
    global windows, active
    if active
        return
    Loop MonitorGetCount() {
        MonitorGet(A_Index, &l, &t, &r, &b)
        g := Gui("-Caption +AlwaysOnTop +ToolWindow -DPIScale")
        g.BackColor := "000000"
        g.MarginX := 0
        g.MarginY := 0
        g.Show("x" l " y" t " w" (r-l) " h" (b-t) " NA")
        windows.Push(g)
    }
    active := true
    Hotkey("Escape", (*) => Restore(), "On")
}
Restore() {
    global windows, active
    if !active
        return
    for g in windows
        g.Destroy()
    windows := []
    active := false
    Hotkey("Escape", "Off")
}
ChangeHotkey() {
    global currentHotkey
    Restore()
    g := Gui(, "OLED Blackout - Settings")
    g.AddText(, "Hotkey: ^ Ctrl, ! Alt, + Shift, # Windows")
    e := g.AddEdit("w300", currentHotkey)
    b := g.AddButton("Default", "Save")
    b.OnEvent("Click", (*) => SaveHotkey(g, e.Value))
    g.Show()
}
SaveHotkey(g, value) {
    global currentHotkey, settingsPath
    value := Trim(value)
    if !value {
        MsgBox("Enter a hotkey.")
        return
    }
    try {
        if value != currentHotkey {
            Hotkey(value, (*) => Toggle(), "On")
            Hotkey(currentHotkey, "Off")
        }
        currentHotkey := value
        IniWrite(value, settingsPath, "Settings", "Hotkey")
        g.Destroy()
    } catch Error as e {
        MsgBox("Invalid hotkey: " e.Message)
    }
}
StartupLink() => A_Startup "\OLED Blackout.lnk"
EnableStartup() {
    try FileCreateShortcut(A_IsCompiled ? A_ScriptFullPath : A_AhkPath, StartupLink(), A_ScriptDir, A_IsCompiled ? "" : '"' A_ScriptFullPath '"', "OLED Blackout")
}
ToggleStartup() {
    if FileExist(StartupLink())
        FileDelete(StartupLink())
    else
        EnableStartup()
    UpdateMenu()
}
UpdateMenu() {
    if FileExist(StartupLink())
        A_TrayMenu.Check("Start with Windows")
    else
        A_TrayMenu.Uncheck("Start with Windows")
}
