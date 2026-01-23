# define name of installer
OutFile "build\aluminum-windows-setup-x86_64.exe"

# Variables
!define NAME "Aluminum"
!define RELEASE_DIR "build\windows\x64\runner\Release"

Name "${NAME}"
InstallDir "$PROGRAMFILES\${NAME}"
RequestExecutionLevel admin

# Pages
Page directory
Page instfiles

# Main section
Section "Aluminum"
    SetOutPath $INSTDIR

    File /r "${RELEASE_DIR}\*.*"

    WriteUninstaller "$INSTDIR\uninstall.exe"
SectionEnd

# Shortcuts section
Section "Shortcuts"
    CreateDirectory "$SMPROGRAMS\${NAME}"
    CreateShortcut "$SMPROGRAMS\${NAME}\${NAME}.lnk" "$INSTDIR\aluminum.exe" 0
    CreateShortcut "$SMPROGRAMS\${NAME}\uninstall_aluminum.lnk" "$INSTDIR\uninstall.exe" 0
SectionEnd

# uninstaller section start
Section "uninstall"

    # Remove the link from the start menu
    Delete "$SMPROGRAMS\${NAME}\*.*"
    RMDir "$SMPROGRAMS\${NAME}"

    # Delete the uninstaller
    Delete $INSTDIR\uninstaller.exe

    RMDir $INSTDIR
# uninstaller section end
SectionEnd
