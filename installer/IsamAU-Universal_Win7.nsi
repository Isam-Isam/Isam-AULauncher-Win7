Section "Isam AULauncher (required)" SecMain
  SectionIn RO

  DetailPrint "Fetching latest release from GitHub (Win7 Compatible)..."
  DetailPrint "URL: ${DOWNLOAD_URL}"

  ; Force TLS 1.2 + TLS 1.1 on Windows 7 WinINet stack
  ; 0xA00 = Security Protocol TLS 1.1 (0x200) + TLS 1.2 (0x800)
  System::Call 'wininet::InternetSetOption(i 0, i 81, *i 0xA00, i 4) i'

  ; URLDownloadToFile with flag 0x10 (BINDF_GETNEWESTVERSION)
  System::Call 'urlmon::URLDownloadToFile(i 0, t"${DOWNLOAD_URL}", t"$PLUGINSDIR\IsamAU-All.zip", i 0x10, i 0) i .r0'

  ${If} $0 != "0"
    MessageBox MB_ICONSTOP "Download failed (error code $0). Windows 7 requires KB2999226 and TLS 1.2 support."
    Quit
  ${EndIf}

  ; --- Extract via PowerShell ---
  DetailPrint "Extracting files..."
  CreateDirectory "$PLUGINSDIR\extracted"

  FileOpen $0 "$PLUGINSDIR\_extract.ps1" w
  FileWrite $0 'Expand-Archive -Path "$PLUGINSDIR\IsamAU-All.zip" -DestinationPath "$PLUGINSDIR\extracted" -Force$\r$\n'
  FileClose $0

  nsExec::ExecToStack 'powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$PLUGINSDIR\_extract.ps1"'
  Pop $0
  
  ; --- Copy launcher files ---
  DetailPrint "Installing launcher..."
  SetOutPath "$INSTDIR"
  nsExec::ExecToStack 'cmd /c xcopy /E /Y "$PLUGINSDIR\extracted\IsamAULauncher\*" "$INSTDIR\"'
  Pop $0

  WriteUninstaller "$INSTDIR\Uninstall.exe"
SectionEnd