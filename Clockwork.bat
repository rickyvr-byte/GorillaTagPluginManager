::[Bat To Exe Converter]
::
::YAwzoRdxOk+EWAjk
::fBw5plQjdCyDJGyX8VAjFCldTw+bAE+1EbsQ5+n//NaqrUMWUaw2e4C7
::YAwzuBVtJxjWCl3EqQJgSA==
::ZR4luwNxJguZRRnk
::Yhs/ulQjdF+5
::cxAkpRVqdFKZSjk=
::cBs/ulQjdF+5
::ZR41oxFsdFKZSDk=
::eBoioBt6dFKZSDk=
::cRo6pxp7LAbNWATEpCI=
::egkzugNsPRvcWATEpCI=
::dAsiuh18IRvcCxnZtBJQ
::cRYluBh/LU+EWAnk
::YxY4rhs+aU+JeA==
::cxY6rQJ7JhzQF1fEqQJQ
::ZQ05rAF9IBncCkqN+0xwdVs0
::ZQ05rAF9IAHYFVzEqQJQ
::eg0/rx1wNQPfEVWB+kM9LVsJDGQ=
::fBEirQZwNQPfEVWB+kM9LVsJDGQ=
::cRolqwZ3JBvQF1fEqQJQ
::dhA7uBVwLU+EWDk=
::YQ03rBFzNR3SWATElA==
::dhAmsQZ3MwfNWATElA==
::ZQ0/vhVqMQ3MEVWAtB9wSA==
::Zg8zqx1/OA3MEVWAtB9wSA==
::dhA7pRFwIByZRRnk
::Zh4grVQjdCyDJGyX8VAjFCldTw+bAE+1EbsQ5+n//NakrkIeX/UwaoSV36yLQA==
::YB416Ek+ZG8=
::
::
::978f952a14a936cc963da21a135fa983
@echo off
setlocal enabledelayedexpansion
title Clockwork - GTAG Plugin tool
color 0A

:: Configuration
set "CONFIG_FILE=%~dp0installer_config.txt"
set "REPO_MODE_FILE=%~dp0repo_mode.txt"
set "CUSTOM_REPO_FILE=%~dp0custom_repo.txt"
set "OFFICIAL_REPO=https://raw.githubusercontent.com/rickyvr-byte/GorillaTagPluginManager/refs/heads/main/list.txt"
set "TEMP_LIST=%TEMP%\gt_plugins.txt"
set "TEMP_INFO=%TEMP%\gt_plugin_info.txt"
set "CURRENT_PAGE=1"
set "PLUGINS_PER_PAGE=5"

:: Load saved plugins folder path
set "PLUGINS_FOLDER="
if exist "%CONFIG_FILE%" (
    for /f "usebackq tokens=* delims=" %%a in ("%CONFIG_FILE%") do (
        set "PLUGINS_FOLDER=%%a"
        goto :loaded_folder
    )
)
:loaded_folder

:: Load repo mode (official or unofficial)
set "REPO_MODE=official"
if exist "%REPO_MODE_FILE%" (
    for /f "usebackq tokens=* delims=" %%a in ("%REPO_MODE_FILE%") do (
        set "REPO_MODE=%%a"
        goto :loaded_mode
    )
) else (
    echo official>"%REPO_MODE_FILE%"
)
:loaded_mode

:: Load custom repo URL
set "CUSTOM_REPO="
if exist "%CUSTOM_REPO_FILE%" (
    for /f "usebackq tokens=* delims=" %%a in ("%CUSTOM_REPO_FILE%") do (
        set "CUSTOM_REPO=%%a"
        goto :loaded_custom
    )
)
:loaded_custom

:: Set active plugin list URL based on mode
if /i "%REPO_MODE%"=="unofficial" (
    if defined CUSTOM_REPO (
        set "PLUGIN_LIST_URL=%CUSTOM_REPO%"
    ) else (
        set "PLUGIN_LIST_URL=%OFFICIAL_REPO%"
    )
) else (
    set "PLUGIN_LIST_URL=%OFFICIAL_REPO%"
)

:MAIN_MENU
cls
echo ===============================================
echo    CLOCKWORK - GTAG PLUGIN TOOL
echo ===============================================
echo.
echo 1. Install Plugins
echo 2. Settings
echo 3. Exit
echo.
echo ===============================================
choice /c 123 /n /m "Select an option (1-3): "

if errorlevel 3 goto EXIT
if errorlevel 2 goto SETTINGS
if errorlevel 1 goto FETCH_PLUGINS
goto MAIN_MENU

:SETTINGS
cls
echo ===============================================
echo    SETTINGS
echo ===============================================
echo.
if defined PLUGINS_FOLDER (
    echo Plugins Folder: %PLUGINS_FOLDER%
) else (
    echo Plugins Folder: [Not Set]
)
echo.
if /i "%REPO_MODE%"=="official" (
    echo Repository Mode: Official
) else (
    echo Repository Mode: Unofficial
    if defined CUSTOM_REPO (
        echo Custom Repo: %CUSTOM_REPO%
    ) else (
        echo Custom Repo: [Not Set]
    )
)
echo.
echo ===============================================
echo 1. Set Plugins Folder Path
echo 2. Toggle Repository Mode (Official/Unofficial)
echo 3. Set Custom Repository URL
echo 4. Back to Main Menu
echo.
echo ===============================================
choice /c 1234 /n /m "Select an option (1-4): "

if errorlevel 4 goto MAIN_MENU
if errorlevel 3 goto SET_CUSTOM_REPO
if errorlevel 2 goto TOGGLE_REPO_MODE
if errorlevel 1 goto SET_FOLDER
goto SETTINGS

:SET_FOLDER
cls
echo ===============================================
echo    SET PLUGINS FOLDER PATH
echo ===============================================
echo.
echo Enter the full path to your Gorilla Tag plugins folder
echo Example: C:\Program Files\Steam\steamapps\common\Gorilla Tag\BepInEx\plugins
echo.
set /p NEW_FOLDER="Plugins Folder Path: "

if not exist "%NEW_FOLDER%" (
    echo.
    echo [ERROR] Folder does not exist!
    pause
    goto SET_FOLDER
)

echo %NEW_FOLDER%>"%CONFIG_FILE%"
set "PLUGINS_FOLDER=%NEW_FOLDER%"

echo.
echo [SUCCESS] Plugins folder path saved!
pause
goto SETTINGS

:TOGGLE_REPO_MODE
cls
echo ===============================================
echo    TOGGLE REPOSITORY MODE
echo ===============================================
echo.
if /i "%REPO_MODE%"=="official" (
    echo Current Mode: Official
    echo.
    echo Official Repository: Verified plugins from the official list
    echo Unofficial Repository: Use a custom plugin list URL
    echo.
    echo ===============================================
    echo.
    set /p toggle_choice="Switch to Unofficial mode? (Y/N): "
    
    if /i "!toggle_choice!"=="Y" (
        if not defined CUSTOM_REPO (
            echo.
            echo [WARNING] No custom repository URL set!
            echo You need to set a custom repository URL in settings.
            pause
            goto SETTINGS
        )
        set "REPO_MODE=unofficial"
        echo unofficial>"%REPO_MODE_FILE%"
        set "PLUGIN_LIST_URL=!CUSTOM_REPO!"
        echo.
        echo [SUCCESS] Switched to Unofficial mode!
        pause
    )
) else (
    echo Current Mode: Unofficial
    echo.
    echo Official Repository: Verified plugins from the official list
    echo Unofficial Repository: Use a custom plugin list URL
    echo.
    echo ===============================================
    echo.
    set /p toggle_choice="Switch to Official mode? (Y/N): "
    
    if /i "!toggle_choice!"=="Y" (
        set "REPO_MODE=official"
        echo official>"%REPO_MODE_FILE%"
        set "PLUGIN_LIST_URL=%OFFICIAL_REPO%"
        echo.
        echo [SUCCESS] Switched to Official mode!
        pause
    )
)

goto SETTINGS

:SET_CUSTOM_REPO
cls
echo ===============================================
echo    SET CUSTOM REPOSITORY URL
echo ===============================================
echo.
if defined CUSTOM_REPO (
    echo Current Custom Repo: %CUSTOM_REPO%
    echo.
)
echo Enter the raw URL to your custom plugin list file
echo Example: https://raw.githubusercontent.com/username/repo/main/list.txt
echo.
echo (Type CLEAR to remove custom repo, or BACK to cancel)
echo.
set /p NEW_REPO="Custom Repository URL: "

if /i "%NEW_REPO%"=="BACK" goto SETTINGS
if /i "%NEW_REPO%"=="CLEAR" (
    del "%CUSTOM_REPO_FILE%" >nul 2>&1
    set "CUSTOM_REPO="
    echo.
    echo [SUCCESS] Custom repository cleared!
    pause
    goto SETTINGS
)

echo %NEW_REPO%>"%CUSTOM_REPO_FILE%"
set "CUSTOM_REPO=%NEW_REPO%"

if /i "%REPO_MODE%"=="unofficial" (
    set "PLUGIN_LIST_URL=%CUSTOM_REPO%"
)

echo.
echo [SUCCESS] Custom repository URL saved!
echo.
echo To use this repository, switch to Unofficial mode.
pause
goto SETTINGS

:FETCH_PLUGINS
if not defined PLUGINS_FOLDER (
    cls
    echo ===============================================
    echo    ERROR
    echo ===============================================
    echo.
    echo Plugins folder path is not set!
    echo Please configure it in Settings first.
    echo.
    pause
    goto MAIN_MENU
)

cls
echo ===============================================
echo    LOADING PLUGINS
echo ===============================================
echo.
echo Fetching plugin list from GitHub...
echo.

curl -s -L -o "%TEMP_LIST%" "%PLUGIN_LIST_URL%"

if not exist "%TEMP_LIST%" (
    echo [ERROR] Failed to fetch plugin list!
    pause
    goto MAIN_MENU
)

:: Count total plugins
set "TOTAL_PLUGINS=0"
for /f %%a in (%TEMP_LIST%) do set /a TOTAL_PLUGINS+=1

set "CURRENT_PAGE=1"
goto INSTALL_MENU

:INSTALL_MENU
cls
echo ===============================================
echo    AVAILABLE PLUGINS - Page %CURRENT_PAGE%
echo ===============================================
echo.

:: Calculate page boundaries
set /a START_LINE=(%CURRENT_PAGE%-1)*%PLUGINS_PER_PAGE%+1
set /a END_LINE=%CURRENT_PAGE%*%PLUGINS_PER_PAGE%

:: Display plugins for current page
set "LINE_NUM=0"
set "DISPLAY_NUM=0"
for /f "usebackq delims=" %%a in ("%TEMP_LIST%") do (
    set /a LINE_NUM+=1
    if !LINE_NUM! GEQ %START_LINE% if !LINE_NUM! LEQ %END_LINE% (
        set /a DISPLAY_NUM+=1
        set "PLUGIN_!DISPLAY_NUM!=%%a"
        
        :: Extract repo name
        set "REPO=%%a"
        set "REPO=!REPO:https://github.com/=!"
        
        echo !DISPLAY_NUM!. !REPO!
    )
)

echo.
echo ===============================================
set /a TOTAL_PAGES=(%TOTAL_PLUGINS%+%PLUGINS_PER_PAGE%-1)/%PLUGINS_PER_PAGE%

if %CURRENT_PAGE% LSS %TOTAL_PAGES% echo N. Next Page
if %CURRENT_PAGE% GTR 1 echo P. Previous Page
echo B. Back to Main Menu
echo.
set /p plugin_choice="Select option: "

if /i "%plugin_choice%"=="B" goto MAIN_MENU
if /i "%plugin_choice%"=="N" (
    if %CURRENT_PAGE% LSS %TOTAL_PAGES% (
        set /a CURRENT_PAGE+=1
        goto INSTALL_MENU
    )
    goto INSTALL_MENU
)
if /i "%plugin_choice%"=="P" (
    if %CURRENT_PAGE% GTR 1 (
        set /a CURRENT_PAGE-=1
        goto INSTALL_MENU
    )
    goto INSTALL_MENU
)

:: Check if valid number
set "SELECTED_PLUGIN="
if "%plugin_choice%" GEQ "1" if "%plugin_choice%" LEQ "%DISPLAY_NUM%" (
    set "SELECTED_PLUGIN=!PLUGIN_%plugin_choice%!"
)

if not defined SELECTED_PLUGIN goto INSTALL_MENU

goto INSTALL_PLUGIN

:INSTALL_PLUGIN
cls
echo ===============================================
echo    FETCHING PLUGIN INFO
echo ===============================================
echo.
echo Repository: %SELECTED_PLUGIN%
echo.

:: Extract owner and repo name
set "REPO_URL=%SELECTED_PLUGIN%"
set "REPO_PATH=!REPO_URL:https://github.com/=!"

echo Fetching latest release information...
echo.

:: Get release info using GitHub API
set "TEMP_RELEASE=%TEMP%\gt_release.json"
set "TEMP_REPO=%TEMP%\gt_repo.json"

curl -s -L "https://api.github.com/repos/%REPO_PATH%/releases/latest" > "%TEMP_RELEASE%"
curl -s -L "https://api.github.com/repos/%REPO_PATH%" > "%TEMP_REPO%"

:: Parse JSON for name and description
for /f "tokens=*" %%a in ('powershell -Command "& {$json = Get-Content '%TEMP_RELEASE%' -Raw | ConvertFrom-Json; Write-Host $json.name}"') do set "RELEASE_NAME=%%a"
for /f "tokens=*" %%a in ('powershell -Command "& {$json = Get-Content '%TEMP_RELEASE%' -Raw | ConvertFrom-Json; Write-Host $json.tag_name}"') do set "VERSION=%%a"
for /f "tokens=*" %%a in ('powershell -Command "& {$json = Get-Content '%TEMP_REPO%' -Raw | ConvertFrom-Json; Write-Host $json.description}"') do set "DESCRIPTION=%%a"

cls
echo ===============================================
echo    PLUGIN INFORMATION
echo ===============================================
echo.
echo Name: %RELEASE_NAME%
echo Version: %VERSION%
echo Description: %DESCRIPTION%
echo.
echo Repository: %REPO_PATH%
echo Target Folder: %PLUGINS_FOLDER%
echo.
echo ===============================================
echo.
set /p install_confirm="Install this plugin? (Y/N): "

if /i not "%install_confirm%"=="Y" goto INSTALL_MENU

echo.
echo Analyzing release assets...
echo.

:: Find DLL file in release
for /f "tokens=*" %%a in ('powershell -Command "& {$json = Get-Content '%TEMP_RELEASE%' -Raw | ConvertFrom-Json; $asset = $json.assets | Where-Object {$_.name -like '*.dll'} | Select-Object -First 1; if($asset) {Write-Host $asset.name}}"') do set "DLL_NAME=%%a"
for /f "tokens=*" %%a in ('powershell -Command "& {$json = Get-Content '%TEMP_RELEASE%' -Raw | ConvertFrom-Json; $asset = $json.assets | Where-Object {$_.name -like '*.dll'} | Select-Object -First 1; if($asset) {Write-Host $asset.browser_download_url}}"') do set "DLL_URL=%%a"

if not defined DLL_NAME (
    echo.
    echo [ERROR] No DLL file found in latest release!
    pause
    goto INSTALL_MENU
)

set "TARGET_FILE=%PLUGINS_FOLDER%\%DLL_NAME%"

:: Check if already installed
if exist "%TARGET_FILE%" (
    echo.
    echo [WARNING] Plugin already installed!
    set /p replace_choice="Replace it? (Y/N): "
    if /i not "!replace_choice!"=="Y" goto INSTALL_MENU
    del "%TARGET_FILE%"
)

echo.
echo Downloading %DLL_NAME%...
echo.

curl -L -o "%TARGET_FILE%" "%DLL_URL%"

if not exist "%TARGET_FILE%" (
    echo.
    echo ===============================================
    echo [ERROR] Download failed!
    echo ===============================================
    echo.
    echo Possible causes:
    echo 1. No internet connection
    echo 2. Windows Defender blocking the file
    echo.
    set /p defender_choice="Disable Windows Defender? (Y/N): "
    
    if /i "!defender_choice!"=="Y" (
        echo.
        echo Disabling Windows Defender...
        powershell -Command "Start-Process powershell -ArgumentList 'Set-MpPreference -DisableRealtimeMonitoring $true' -Verb RunAs"
        timeout /t 3 >nul
        
        echo.
        set /p retry_choice="Retry download? (Y/N): "
        if /i "!retry_choice!"=="Y" goto INSTALL_PLUGIN
    )
    
    pause
    goto INSTALL_MENU
)

echo.
echo ===============================================
echo [SUCCESS] Plugin installed!
echo ===============================================
echo.
echo File: %TARGET_FILE%
echo.
pause
goto INSTALL_MENU

:EXIT
cls
echo.
echo Thanks for using the installer!
timeout /t 2 >nul
exit
