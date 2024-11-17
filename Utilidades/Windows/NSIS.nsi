!include x64.nsh
!include FileFunc.nsh

OutFile "Levanter.exe"
Icon "D:\Documentos\LinuxMint\ICO\levanter.ico" #Aqui el logo
RequestExecutionLevel highest
Name "Instalador Levanter by Lyfe"

Section "MainSection" SEC01

    SetOutPath $TEMP
    File /oname=$TEMP\Levanter.ps1 "D:\Escritorio\Levanter.ps1" #El Script de Instalacion
    ${If} ${RunningX64}
        ExecWait '"$WINDIR\SysNative\cmd.exe" /c "powershell -NoProfile -ExecutionPolicy Bypass -File "$TEMP\Levanter.ps1"' #Variables para ejecucion nativa en 64Bits
    ${Else}
        ExecWait '"$WINDIR\SysNative\cmd.exe" /c "powershell -NoProfile -ExecutionPolicy Bypass -File "$TEMP\Levanter.ps1"'
    ${EndIf}

    Quit
SectionEnd

    