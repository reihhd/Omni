#Requires AutoHotkey v2.0
#SingleInstance Force

localVersionFile := A_ScriptDir "\version.txt"
localExe := A_ScriptDir "\Omni.exe"
tempExe := A_ScriptDir "\Omni_new.exe"
remoteVersionURL := "https://raw.githubusercontent.com/reihhd/Omni/main/version.txt"
remoteExeURL := "https://raw.githubusercontent.com/reihhd/Omni/main/Omni.exe"
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

UpdateStatus("New version available:" remoteVersion "`nDownloading...")
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

UpdateStatus("Update successful!`nPlease restart Omni.exe")
Sleep(3000)
ExitApp
