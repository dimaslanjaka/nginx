!define UninstId "Nginx" ; You might want to use a GUID here
!include LogicLib.nsh
!include MUI2.nsh
!include x64.nsh
!addplugindir ".\EXT"
!include ".\EXT\Include\EnvVarUpdate.nsh" #download http://nsis.sourceforge.net/mediawiki/images/a/ad/EnvVarUpdate.7z
;Request application privileges for Windows Vista
RequestExecutionLevel admin

; Unicode
!if "${NSIS_PACKEDVERSION}" > 0x02ffffff ; NSIS 3+
  Unicode true
!endif

!define PRODUCT_NAME "Nginx"
!define PRODUCT_VERSION "2.0.0"
!define PRODUCT_PUBLISHER "Dimas Lanjaka"
!define PRODUCT_WEB_SITE "https://www.webmanajemen.com"
!define PRODUCT_DIR_REGKEY "Software\Microsoft\Windows\CurrentVersion\App Paths\nginx-service.exe"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"

; Settings
Name "${PRODUCT_NAME}" ; ${PRODUCT_VERSION}"
OutFile "nginx-service.exe"
InstallDir "$PROGRAMFILES\Nginx"
Icon "nginx.ico"
UninstallIcon "${NSISDIR}\Contrib\Graphics\Icons\nsis1-uninstall.ico"
InstallDirRegKey HKLM "${PRODUCT_DIR_REGKEY}" ""
DirText "Setup will install $(^Name) in the following folder.$\r$\n$\r$\nTo install in a different folder, click Browse and select another folder."
ShowInstDetails show
ShowUnInstDetails show

;!define MUI_COMPONENTSPAGE_SMALLDESC ;No value
;!define MUI_UI "nginx-service.exe" ;Value
;!define MUI_INSTFILESPAGE_COLORS "FFFFFF 000000" ;Two colors

;--------------------------------
;Interface Settings
  !define MUI_ABORTWARNING
  !define MUI_ICON "nginx.ico"
  !define MUI_UNICON "nginx.ico"

;--------------------------------
;Pages

  !insertmacro MUI_PAGE_WELCOME
  !insertmacro MUI_PAGE_LICENSE "EXT/Docs/Modern UI/License.txt"
  !insertmacro MUI_PAGE_COMPONENTS
  !insertmacro MUI_PAGE_DIRECTORY
  !insertmacro MUI_PAGE_INSTFILES
  !insertmacro MUI_PAGE_FINISH

  !insertmacro MUI_UNPAGE_WELCOME
  !insertmacro MUI_UNPAGE_CONFIRM
  !insertmacro MUI_UNPAGE_LICENSE "EXT/Docs/Modern UI/License.txt"
  !insertmacro MUI_UNPAGE_COMPONENTS
  !insertmacro MUI_UNPAGE_DIRECTORY
  !insertmacro MUI_UNPAGE_INSTFILES
  !insertmacro MUI_UNPAGE_FINISH

;--------------------------------
;Languages

  !insertmacro MUI_LANGUAGE "English" ; The first language is the default language
  !insertmacro MUI_LANGUAGE "French"
  !insertmacro MUI_LANGUAGE "German"
  !insertmacro MUI_LANGUAGE "Spanish"
  !insertmacro MUI_LANGUAGE "Indonesian"

;--------------------------------
;Reserve Files

  ;If you are using solid compression, files that are required before
  ;the actual installation should be stored first in the data block,
  ;because this will make your installer start faster.

  !insertmacro MUI_RESERVEFILE_LANGDLL

;--------------------------------
;Installer Sections
Section "Nginx" SecInstallation

  SetOutPath "$INSTDIR"

  ${EnvVarUpdate} $0 "PATH" "R" "HKLM" "$INSTDIR"  ; Remove path of old rev
  ${EnvVarUpdate} $0 "PATH" "A" "HKLM" "$INSTDIR"  ; Append the new one

  ; Sect 01
  File "/oname=$InstDir\nginx-service.exe" "${__FILE__}" ; Dummy file
  WriteUninstaller "$InstDir\uninst.exe"
  WriteRegStr HKCU "Software\Software\Microsoft\Windows\CurrentVersion\Uninstall\${UninstId}" "DisplayName" "$(^Name)"
  WriteRegStr HKCU "Software\Software\Microsoft\Windows\CurrentVersion\Uninstall\${UninstId}" "UninstallString" '"$InstDir\uninst.exe"'
  WriteRegStr HKCU "Software\Software\Microsoft\Windows\CurrentVersion\Uninstall\${UninstId}" "QuietUninstallString" '"$InstDir\uninst.exe" /S'

  ; Sect 02
  SetOverwrite try
  File "nssm.exe"
  File "nginx.exe"
  File /r contrib
  File /r conf
  File /r ssl
  File /r docs
  File /r html
  File /r "sites-available"
  File /r "node_modules"
  File "node.exe"
  CreateDirectory $INSTDIR\logs
  CreateDirectory $INSTDIR\temp
  CreateDirectory $INSTDIR\sites-enabled

  ;Store installation folder
  WriteRegStr HKCU "Software\Nginx" "" $INSTDIR

  ;Create uninstaller
  ;WriteUninstaller "$INSTDIR\uninst.exe"

SectionEnd

;--------------------------------
;Installer Functions
Function .onInit
  ;Architecture check
  ${If} ${RunningX64}
    SetRegView 64
    StrCpy $InstDir "$PROGRAMFILES64\${PRODUCT_NAME}"
  ${Else}
    SetRegView 32
    StrCpy $InstDir "$PROGRAMFILES\${PRODUCT_NAME}"
  ${EndIf}

  ; insert languages display
  ;!define MUI_LANGDLL_ALWAYSSHOW
  ;!define MUI_LANGDLL_ALLLANGUAGES
  !insertmacro MUI_LANGDLL_DISPLAY
FunctionEnd

;--------------------------------
;Descriptions
  ;USE A LANGUAGE STRING IF YOU WANT YOUR DESCRIPTIONS TO BE LANGAUGE SPECIFIC
  ;Assign descriptions to sections
  !insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${SecInstallation} "Installation Section."
  !insertmacro MUI_FUNCTION_DESCRIPTION_END

; install service after installed successful
Function .onInstSuccess
  ExecWait '$INSTDIR\nssm.exe install Nginx "$INSTDIR\nginx.exe"'

  ; https://stackoverflow.com/questions/41517201/making-a-node-js-service-using-nssm
  ExecWait '$INSTDIR\nssm.exe install Nodengrok "$INSTDIR\node.exe" "$INSTDIR\ngrok\ngrok.js"'
  ExecWait '$INSTDIR\nssm.exe set Nodengrok AppDirectory "$INSTDIR\node.exe"'
  ExecWait '$INSTDIR\nssm.exe set Nodengrok AppParameters ngrok.js'
  ;nssm set jewel-server AppDirectory "D:\jewel"
  ;nssm set jewel-server AppParameters server.js

  ExecWait '"sc.exe" start nginx'
  ExecWait '"sc.exe" start nodengrok'
  WriteRegStr HKLM "SYSTEM\CurrentControlSet\Services\nginx" \
                     "Description" "Nginx HTTP and reverse proxy server"
  WriteRegStr HKLM "SYSTEM\CurrentControlSet\Services\nodengrok" \
                     "Description" "Deploy nginx with ngrok"
  WriteUninstaller "$INSTDIR\uninst.exe"
  WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "" "$INSTDIR\nssm.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$INSTDIR\nginx.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
FunctionEnd

; Cleanup after installation failed
Function .onInstFailed
  Call Cleanup
  MessageBox MB_OK "Better luck next time."
FunctionEnd

; Cleanup
!macro Cleanup UN
Function ${UN}Cleanup
  RMDir /r "$INSTDIR\conf"
  RMDir /r "$INSTDIR\contrib"
  RMDir /r "$INSTDIR\html"
  RMDir /r "$INSTDIR\docs"
  RMDir /r "$INSTDIR\temp"
  RMDir /r "$INSTDIR\node_modules"
  Delete $INSTDIR\node.exe
  Delete $INSTDIR\nginx.exe
  Delete $INSTDIR\nssm.exe
  Delete "$InstDir\nginx-service.exe"
  Delete "$InstDir\uninst.exe"
  ; delete installation dir
  RMDir "$InstDir"
FunctionEnd
!macroend
!insertmacro Cleanup ""
!insertmacro Cleanup "un."

;--------------------------------
;Uninstaller Section

Section "Uninstall"
  ExecWait '"sc.exe" stop nginx'
  ExecWait "$INSTDIR\nssm.exe remove nginx confirm"

  DeleteRegKey HKCU "Software\Software\Microsoft\Windows\CurrentVersion\Uninstall\${UninstId}"
  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY}"
  DeleteRegKey /ifempty HKCU "Software\Nginx"

  # remove the variable
  ${un.EnvVarUpdate} $0 "PATH" "R" "HKLM" "$INSTDIR"      ; Remove path of latest rev

  SetAutoClose true
SectionEnd

;--------------------------------
;Uninstaller Functions

Function un.onInit
  !insertmacro MUI_UNGETLANGUAGE

  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "Are you sure you want to completely remove $(^Name) and all of its components?" IDYES +2
  Abort
FunctionEnd

; on uninstall success
Function un.onUninstSuccess
  HideWindow
  Call un.Cleanup
  MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) was successfully removed from your computer."
FunctionEnd