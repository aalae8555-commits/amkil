@echo off
setlocal EnableDelayedExpansion
set JAVA_HOME=C:\Users\med\.jdks\jbr_dcevm-11.0.16
set PATH=%JAVA_HOME%\bin;%PATH%
title ONI APK Builder

set "SRC_DIR=D:\project_prem\oni aimkill\NVL AIMKILL"
set "BUILD_DIR=D:\project_prem\NVL_AIMKILL"

:menu
cls
echo ========================================
echo        ONI APK BUILD SYSTEM
echo ========================================
echo.
echo [1] Build Debug APK (Standard)
echo [2] Build Release APK (Optimized)
echo [3] Clean Project (Fix Errors)
echo [4] Exit
echo.
set /p choice="Enter choice (1-4): "

if "%choice%"=="1" goto debug
if "%choice%"=="2" goto release
if "%choice%"=="3" goto clean
if "%choice%"=="4" goto end
goto menu

:debug
echo.
echo [*] Syncing source files...
robocopy "%SRC_DIR%\app\src\main\java" "%BUILD_DIR%\app\src\main\java" /MIR /NFL /NDL /NJH /NJS /NC /NS /NP >nul 2>&1
robocopy "%SRC_DIR%\app\src\main\jni"  "%BUILD_DIR%\app\src\main\jni"  /MIR /NFL /NDL /NJH /NJS /NC /NS /NP >nul 2>&1
robocopy "%SRC_DIR%\app\src\main\res"  "%BUILD_DIR%\app\src\main\res"  /MIR /NFL /NDL /NJH /NJS /NC /NS /NP >nul 2>&1
copy /Y "%SRC_DIR%\app\src\main\AndroidManifest.xml" "%BUILD_DIR%\app\src\main\AndroidManifest.xml" >nul 2>&1
echo [*] Sync complete.
echo.
echo [*] Building Debug APK...
pushd "%BUILD_DIR%"
call gradlew.bat assembleDebug
set RESULT=%ERRORLEVEL%
popd
if %RESULT% equ 0 (
    echo.
    echo [!] Build SUCCESSFUL!
    if not exist "%SRC_DIR%\app\build\outputs\apk\debug\" mkdir "%SRC_DIR%\app\build\outputs\apk\debug\"
    copy /Y "%BUILD_DIR%\app\build\outputs\apk\debug\app-debug.apk" "%SRC_DIR%\app\build\outputs\apk\debug\app-debug.apk" >nul 2>&1
    echo [*] APK saved to: %SRC_DIR%\app\build\outputs\apk\debug\
    start "" "%SRC_DIR%\app\build\outputs\apk\debug\"
) else (
    echo.
    echo [X] Build FAILED! Please check the logs above.
)
pause
goto menu

:release
echo.
echo [*] Syncing source files...
robocopy "%SRC_DIR%\app\src\main\java" "%BUILD_DIR%\app\src\main\java" /MIR /NFL /NDL /NJH /NJS /NC /NS /NP >nul 2>&1
robocopy "%SRC_DIR%\app\src\main\jni"  "%BUILD_DIR%\app\src\main\jni"  /MIR /NFL /NDL /NJH /NJS /NC /NS /NP >nul 2>&1
robocopy "%SRC_DIR%\app\src\main\res"  "%BUILD_DIR%\app\src\main\res"  /MIR /NFL /NDL /NJH /NJS /NC /NS /NP >nul 2>&1
copy /Y "%SRC_DIR%\app\src\main\AndroidManifest.xml" "%BUILD_DIR%\app\src\main\AndroidManifest.xml" >nul 2>&1
echo [*] Sync complete.
echo.
echo [*] Building Release APK...
pushd "%BUILD_DIR%"
call gradlew.bat assembleRelease
set RESULT=%ERRORLEVEL%
popd
if %RESULT% equ 0 (
    echo.
    echo [!] Build SUCCESSFUL!
    if not exist "%SRC_DIR%\app\build\outputs\apk\release\" mkdir "%SRC_DIR%\app\build\outputs\apk\release\"
    copy /Y "%BUILD_DIR%\app\build\outputs\apk\release\app-release-unsigned.apk" "%SRC_DIR%\app\build\outputs\apk\release\app-release-unsigned.apk" >nul 2>&1
    echo [*] APK saved to: %SRC_DIR%\app\build\outputs\apk\release\
    start "" "%SRC_DIR%\app\build\outputs\apk\release\"
) else (
    echo.
    echo [X] Build FAILED! Please check the logs above.
)
pause
goto menu

:clean
echo.
echo [*] Cleaning project...
pushd "%BUILD_DIR%"
call gradlew.bat clean
popd
echo.
echo [!] Clean complete.
pause
goto menu

:end
exit
