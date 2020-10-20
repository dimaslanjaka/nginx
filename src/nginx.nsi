!define UninstId "Nginx" ; You might want to use a GUID here
!include LogicLib.nsh
!include "MUI2.nsh"
!include x64.nsh

;Request application privileges for Windows Vista
RequestExecutionLevel admin

; Unicode
Unicode True

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

;Get installation folder from registry if available
;InstallDirRegKey HKCU "Software\Nginx" ""

;Uninstall prevous version
!macro UninstallExisting exitcode uninstcommand
Push `${uninstcommand}`
Call UninstallExisting
Pop ${exitcode}
!macroend
Function UninstallExisting
  Exch $1 ; uninstcommand
  Push $2 ; Uninstaller
  Push $3 ; Len
  StrCpy $3 ""
  StrCpy $2 $1 1
  StrCmp $2 '"' qloop sloop
  sloop:
    StrCpy $2 $1 1 $3
    IntOp $3 $3 + 1
    StrCmp $2 "" +2
    StrCmp $2 ' ' 0 sloop
    IntOp $3 $3 - 1
    Goto run
  qloop:
    StrCmp $3 "" 0 +2
    StrCpy $1 $1 "" 1 ; Remove initial quote
    IntOp $3 $3 + 1
    StrCpy $2 $1 1 $3
    StrCmp $2 "" +2
    StrCmp $2 '"' 0 qloop
  run:
    StrCpy $2 $1 $3 ; Path to uninstaller
    StrCpy $1 161 ; ERROR_BAD_PATHNAME
    GetFullPathName $3 "$2\.." ; $InstDir
    IfFileExists "$2" 0 +4
    ExecWait '"$2" /S _?=$3' $1 ; This assumes the existing uninstaller is a NSIS uninstaller, other uninstallers don't support /S nor _?=
    IntCmp $1 0 "" +2 +2 ; Don't delete the installer if it was aborted
    Delete "$2" ; Delete the uninstaller
    RMDir "$3" ; Try to delete $InstDir
    RMDir "$3\.." ; (Optional) Try to delete the parent of $InstDir
  Pop $3
  Pop $2
  Exch $1 ; exitcode
FunctionEnd

;--------------------------------
;Interface Settings
  !define MUI_ABORTWARNING

;--------------------------------
;Pages

  !insertmacro MUI_PAGE_WELCOME
  !insertmacro MUI_PAGE_LICENSE "${NSISDIR}\Docs\Modern UI\License.txt"
  !insertmacro MUI_PAGE_COMPONENTS
  !insertmacro MUI_PAGE_DIRECTORY
  !insertmacro MUI_PAGE_INSTFILES
  !insertmacro MUI_PAGE_FINISH

  !insertmacro MUI_UNPAGE_WELCOME
  !insertmacro MUI_UNPAGE_CONFIRM
  !insertmacro MUI_UNPAGE_LICENSE "${NSISDIR}\Docs\Modern UI\License.txt"
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
  !insertmacro MUI_LANGUAGE "SpanishInternational"
  !insertmacro MUI_LANGUAGE "SimpChinese"
  !insertmacro MUI_LANGUAGE "TradChinese"
  !insertmacro MUI_LANGUAGE "Japanese"
  !insertmacro MUI_LANGUAGE "Korean"
  !insertmacro MUI_LANGUAGE "Italian"
  !insertmacro MUI_LANGUAGE "Dutch"
  !insertmacro MUI_LANGUAGE "Danish"
  !insertmacro MUI_LANGUAGE "Swedish"
  !insertmacro MUI_LANGUAGE "Norwegian"
  !insertmacro MUI_LANGUAGE "NorwegianNynorsk"
  !insertmacro MUI_LANGUAGE "Finnish"
  !insertmacro MUI_LANGUAGE "Greek"
  !insertmacro MUI_LANGUAGE "Russian"
  !insertmacro MUI_LANGUAGE "Portuguese"
  !insertmacro MUI_LANGUAGE "PortugueseBR"
  !insertmacro MUI_LANGUAGE "Polish"
  !insertmacro MUI_LANGUAGE "Ukrainian"
  !insertmacro MUI_LANGUAGE "Czech"
  !insertmacro MUI_LANGUAGE "Slovak"
  !insertmacro MUI_LANGUAGE "Croatian"
  !insertmacro MUI_LANGUAGE "Bulgarian"
  !insertmacro MUI_LANGUAGE "Hungarian"
  !insertmacro MUI_LANGUAGE "Thai"
  !insertmacro MUI_LANGUAGE "Romanian"
  !insertmacro MUI_LANGUAGE "Latvian"
  !insertmacro MUI_LANGUAGE "Macedonian"
  !insertmacro MUI_LANGUAGE "Estonian"
  !insertmacro MUI_LANGUAGE "Turkish"
  !insertmacro MUI_LANGUAGE "Lithuanian"
  !insertmacro MUI_LANGUAGE "Slovenian"
  !insertmacro MUI_LANGUAGE "Serbian"
  !insertmacro MUI_LANGUAGE "SerbianLatin"
  !insertmacro MUI_LANGUAGE "Arabic"
  !insertmacro MUI_LANGUAGE "Farsi"
  !insertmacro MUI_LANGUAGE "Hebrew"
  !insertmacro MUI_LANGUAGE "Indonesian"
  !insertmacro MUI_LANGUAGE "Mongolian"
  !insertmacro MUI_LANGUAGE "Luxembourgish"
  !insertmacro MUI_LANGUAGE "Albanian"
  !insertmacro MUI_LANGUAGE "Breton"
  !insertmacro MUI_LANGUAGE "Belarusian"
  !insertmacro MUI_LANGUAGE "Icelandic"
  !insertmacro MUI_LANGUAGE "Malay"
  !insertmacro MUI_LANGUAGE "Bosnian"
  !insertmacro MUI_LANGUAGE "Kurdish"
  !insertmacro MUI_LANGUAGE "Irish"
  !insertmacro MUI_LANGUAGE "Uzbek"
  !insertmacro MUI_LANGUAGE "Galician"
  !insertmacro MUI_LANGUAGE "Afrikaans"
  !insertmacro MUI_LANGUAGE "Catalan"
  !insertmacro MUI_LANGUAGE "Esperanto"
  !insertmacro MUI_LANGUAGE "Asturian"
  !insertmacro MUI_LANGUAGE "Basque"
  !insertmacro MUI_LANGUAGE "Pashto"
  !insertmacro MUI_LANGUAGE "ScotsGaelic"
  !insertmacro MUI_LANGUAGE "Georgian"
  !insertmacro MUI_LANGUAGE "Vietnamese"
  !insertmacro MUI_LANGUAGE "Welsh"
  !insertmacro MUI_LANGUAGE "Armenian"
  !insertmacro MUI_LANGUAGE "Corsican"
  !insertmacro MUI_LANGUAGE "Tatar"
  !insertmacro MUI_LANGUAGE "Hindi"

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

  ; Sect 03 : Add environtment variable
  ; Check for write access
  EnVar::Check "NULL" "NULL"
  Pop $0
  DetailPrint "EnVar::Check write access HKCU returned=|$0|"

  ; Set to HKLM
  EnVar::SetHKLM

  ; Check for write access
  EnVar::Check "NULL" "NULL"
  Pop $0
  DetailPrint "EnVar::Check write access HKLM returned=|$0|"

  ; Set back to HKCU
  EnVar::SetHKCU
  DetailPrint "EnVar::SetHKCU"

  ; Check for a 'temp' variable
  EnVar::Check "temp" "NULL"
  Pop $0
  DetailPrint "EnVar::Check returned=|$0|"

   ; Add a value
  EnVar::AddValue "NGINX_HOME" $INSTDIR
  Pop $0
  DetailPrint "EnVar::AddValue returned=|$0|"

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
  !define MUI_LANGDLL_ALWAYSSHOW
  !define MUI_LANGDLL_ALLLANGUAGES
  !insertmacro MUI_LANGDLL_DISPLAY

  ; remove previous installation
  ReadRegStr $0 HKCU "Software\Software\Microsoft\Windows\CurrentVersion\Uninstall\${UninstId}" "UninstallString"
  ${If} $0 != ""
  ${AndIf} ${Cmd} `MessageBox MB_YESNO|MB_ICONQUESTION "Uninstall previous version?" /SD IDYES IDYES`
    !insertmacro UninstallExisting $0 $0
    ${If} $0 <> 0
      MessageBox MB_YESNO|MB_ICONSTOP "Failed to uninstall, continue anyway?" /SD IDYES IDYES +2
        Abort
    ${EndIf}
  ${EndIf}
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
  ExecWait '$INSTDIR\nssm.exe install Nodengrok "$INSTDIR\node.exe" "$INSTDIR\ngrok\ngrok.js"'
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
  EnVar::Delete "NGINX_HOME"
  Pop $0
  DetailPrint "EnVar::Delete returned=|$0|"

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