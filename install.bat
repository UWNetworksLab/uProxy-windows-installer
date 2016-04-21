:: Name:     install.bat
:: Purpose:  Builds Windows Installer for Firefox with uProxy
:: Version: 0.1.1
:: uProxy version: 0.8.39

@ECHO OFF
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION

REM Current directory path
SET parent=%~dp0

REM URL to get the uProxy add-on, get here: https://addons.mozilla.org/en-US/firefox/addon/uproxy-firefox/
SET uproxyAddonURL=https://addons.mozilla.org/firefox/downloads/file/421107/uproxy_beta-0.8.39-fx-windows.xpi

REM Set version and language with default values
SET version=45.0.1
SET languages=en-US zh-CN

REM Set version and language from optional args
:Argloop
IF NOT "%1"=="" (
    IF "%1"=="-version" (
        SET version=%2
        SHIFT & SHIFT
        GOTO Argloop
    )
    IF "%1"=="-v" (
        SET version=%2
        SHIFT & SHIFT
        GOTO Argloop
    )
    IF "%1"=="-language" (
        SET languages=%2
        SHIFT & SHIFT
        GOTO Argloop
    )
    IF "%1"=="-l" (
        SET languages=%2
        SHIFT & SHIFT
        GOTO Argloop
    )
    REM If the arg is not -version or -language raise error
    IF NOT "%1"=="" (
        ECHO Invalid argument entry: %1
        GOTO End
    )
)

REM Make sure 7-Zip is installed
SET zipPath="C:\Program Files\7-Zip\7z.exe"
IF NOT exist %zipPath% (
    ECHO Error: 7-Zip cannot be found at %zipPath%. You need to install 7-Zip.
    GOTO End
)
SET sevenzip=%zipPath%
ECHO Found 7-Zip at %zipPath%

REM Make sure Signtool is installed
SET signtoolPath="C:\Program Files\Microsoft SDKs\Windows\v7.1\Bin\signtool.exe"
IF NOT exist %signtoolPath% (
    ECHO Error: Signtool.exe cannot be found at %signtoolPath%. You need to install Microsoft SDKs v7.1 with Signtool.exe included.
    GOTO End
)
SET signtool=%signtoolPath%
ECHO Found Signtool at %signtoolPath%

ECHO Starting to build firefox v%version% setup files for languages %languages%

REM Setting up file structure
FOR %%f in (build dist firefox extension) DO (
    IF exist %%f\ (
        RMDIR /S /Q %%f\
    )
    MKDIR %%f\
)

REM Download latest uProxy add-on from uproxyAddonURL
SET fileURL=%uproxyAddonURL%
SET fileLocation=%parent%extension\uproxy.xpi
REM downloadfile.vbs is a script that downloads the file at fileURL to the set fileLocation
cscript.exe src\downloadfile.vbs
IF errorlevel 1 GOTO End

REM Check that uproxy.xpi downloaded successfully
IF NOT exist !fileLocation! (
    ECHO Error: Could not download xpi file from Firefox. Get correct link here: https://addons.mozilla.org/en-US/firefox/addon/uproxy-firefox/
    GOTO End
)
SET fileURL=
SET fileLocation=

FOR %%s in (%languages%) DO (
    SET lang=%%s
    SET buildPath=%parent%build\!lang!
    MKDIR !buildPath!
    SET distPath=%parent%dist\!lang!
    MKDIR !distPath!
    SET firefoxPath=%parent%firefox\!lang!
    MKDIR !firefoxPath!
    
    ECHO Building firefox installer version %version% language !lang!...
    
    REM Downloading firefox setup.exe from Mozilla
    SET fileURL=http://ftp.mozilla.org/pub/firefox/releases/%version%/win64/!lang!/Firefox%%20Setup%%20%version%.exe
    SET fileLocation=!firefoxPath!\firefox_%version%_!lang!.exe
    cscript.exe src\downloadfile.vbs
    
    REM Check that setup.exe downloaded successfully
    IF NOT exist !fileLocation! (
        ECHO Could not download Firefox. Check http://ftp.mozilla.org/pub/firefox/releases/ for valid versions and languages.
        GOTO End
    )
    
    REM Extracting files from Firefox_setup.exe
    %sevenzip% x -y !fileLocation! -o!buildPath!
    
    SET fileURL=
    SET fileLocation=
    
    REM Copy new files from src to build
    COPY /Y src\core\custom-config.cfg !buildPath!\core\custom-config.cfg
    IF NOT exist !buildPath!\core\defaults\pref {
        MKDIR !buildPath!\core\defaults\pref\
    }
    COPY /Y src\core\pref\local-settings.js !buildPath!\core\defaults\pref\local-settings.js
    COPY /Y src\core\pref\user.js !buildPath!\core\defaults\pref\user.js
    COPY /Y src\core\pref\channel-prefs.js !buildPath!\core\defaults\pref\channel-prefs.js
    
    REM Add each file to the uninstall file
    SET uninstallFile=!buildPath!\core\precomplete
    ECHO remove "custom-config.cfg" >> !uninstallFile!
    ECHO remove "defaults/pref/local-settings.js" >> !uninstallFile!
    ECHO remove "defaults/pref/user.js" >> !uninstallFile!
    ECHO remove "defaults/pref/channel-prefs.js" >> !uninstallFile!
    ECHO rmdir "defaults/pref/" >> !uninstallFile!
    ECHO rmdir "defaults/" >> !uninstallFile!

    REM Copy landing page for language to core
    REM TODO: Uncomment following lines to add landing page
    REM COPY /Y src\landingpage\en-US\uproxy.html !buildPath!\core\uproxy.html
    REM ECHO remove "uproxy.html" >> !uninstallFile!
    
    REM Copy all distribution files last
    MKDIR !buildPath!\core\distribution
    XCOPY /E src\core\distribution !buildPath!\core\distribution
    
    REM Extract uproxy.xpi to extension directory
    %sevenzip% x -y %parent%extension\uproxy.xpi -o!buildPath!\core\distribution\extensions\jid1-uTe1Bgrsb76jSA@jetpack

    REM Compress files into build\%lang%\app.7z
    CD !buildPath!
    %sevenzip% a -r -t7z app.7z -mx -m0=BCJ2 -m1=LZMA:d24 -m2=LZMA:d19 -m3=LZMA:d19 -mb0:1 -mb0s1:2 -mb0s2:3
    CD %parent%
    
    REM Repackage app.7z into custom exe
    SET distFile=Firefox_with_uProxy_%version%_!lang!.exe
    COPY /B src\7zSD.sfx+src\app.tag+!buildPath!\app.7z !distPath!\!distFile!
    ECHO Completed build for !distFile!
    
    REM Sign final exe with signtool.exe
    ECHO Remember to sign !distFile! with signtool
    REM TODO: Uncomment following line to sign package when we have a cert 
    REM %signtool% sign /v /n uProxy /p [password] /f [uProxy.pfx] /t http://timestamp.verisign.com/scripts/timstamp.dll !distPath!\!distFile!
)

:END
ENDLOCAL
ECHO ON
@EXIT /B 0