#Requires AutoHotkey v2.0
#SingleInstance Force

localVersionFile := A_ScriptDir "\version.txt"
localExe := A_ScriptDir "\Omni.exe"
tempExe := A_ScriptDir "\Omni_new.exe"
localChangelogFile := A_ScriptDir "\changelogs.txt"
remoteVersionURL := "https://raw.githubusercontent.com/reihhd/Omni/main/version.txt"
remoteExeURL := "https://raw.githubusercontent.com/reihhd/Omni/main/Omni.exe"
remoteChangelogURL := "https://raw.githubusercontent.com/reihhd/Omni/refs/heads/main/changelogs.txt"
processName := "Omni.exe"

updaterGui := Gui("+AlwaysOnTop", "Omni Updater")
updaterGui.SetFont("s10")
statusText := updaterGui.Add("Text", "w250 Center", "Checking for updates...")
updaterGui.Show("w270 h40")

UpdateStatus(text) {
    global statusText, updaterGui
    statusText.Value := text
    updaterGui.Show()
}

localVersion := ""
if FileExist(localVersionFile) {
    localVersion := Trim(FileRead(localVersionFile))
}

remoteVersion := ""
try {
    whr := ComObject("WinHttp.WinHttpRequest.5.1")
    whr.Open("GET", remoteVersionURL, true)
    whr.Send()
    whr.WaitForResponse()
    remoteVersion := Trim(whr.ResponseText)
} catch {
    UpdateStatus("Failed to check for updates.`nCheck your internet connection.")
    Sleep(3000)
    ExitApp
}

if (localVersion = remoteVersion) {
    UpdateStatus("You are up to date! " remoteVersion " ")
    Sleep(2000)
    ExitApp
}

UpdateStatus("New version available: " remoteVersion "`nDownloading...")
try {
    if FileExist(tempExe)
        FileDelete(tempExe)

    Download(remoteExeURL, tempExe)

    if !FileExist(tempExe) {
        throw Error("Download failed")
    }
} catch {
    UpdateStatus("Download failed. Please try again later.")
    Sleep(3000)
    ExitApp
}

if ProcessExist(processName) {
    UpdateStatus("Omni.exe is running.`nClosing...")
    if WinExist("ahk_exe " processName) {
        WinClose("ahk_exe " processName)
        Sleep(2000)
    }
    if ProcessExist(processName) {
        ProcessClose(processName)
        Sleep(1000)
    }
    if ProcessExist(processName) {
        UpdateStatus("Unable to close Omni.exe.`nPlease close it manually and run again.")
        Sleep(3000)
        ExitApp
    }
}

UpdateStatus("Download complete.`nReplacing old version...")
try {
    if FileExist(localExe) {
        FileDelete(localExe)
    }
    FileMove(tempExe, localExe, 1)

    if FileExist(localVersionFile)
        FileDelete(localVersionFile)
    FileAppend(remoteVersion, localVersionFile)
} catch as e {
    UpdateStatus("Failed to replace old version.`nError: " e.Message "`nPlease close Omni.exe and run updater again.")
    Sleep(5000)
    ExitApp
}

UpdateStatus("Update successful!`nFetching changelog...")

if FileExist(localChangelogFile)
    FileDelete(localChangelogFile)

changelogText := ""
try {
    Download(remoteChangelogURL, localChangelogFile)
    if FileExist(localChangelogFile)
        changelogText := Trim(FileRead(localChangelogFile))
} catch {
    changelogText := "(Failed to download changelog)"
}

updaterGui.Destroy()

clGui := Gui("+AlwaysOnTop +Resize", "Omni Changelog - " remoteVersion)
clGui.SetFont("s10", "Consolas")
clGui.MarginX := 12
clGui.MarginY := 10

clGui.Add("Text", "w480 c333333", "Omni updated to " remoteVersion)
clGui.Add("Text", "w480 c666666", "Changelog:")

changelogBox := clGui.Add("Edit",
    "w480 h300 ReadOnly -Wrap +VScroll BackgroundF5F5F5",
    changelogText)

clGui.Add("Button", "x200 y+10 w100 h28 Default", "Close")
    .OnEvent("Click", (*) => ExitApp())

clGui.OnEvent("Close", (*) => ExitApp())
clGui.Show("w510 h430")
