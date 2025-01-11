@echo off
title PXNG Free Tweaking Utility V4.1
color 0a
mode con: cols=80 lines=30

rem Create header with centered options
echo ================================================================
echo             PXNG Free Tweaking Utility V4.1
echo       Optimize Your System for Performance
echo ================================================================
echo.

rem Create log file
set LOG_FILE=PXNG_Tweaks_Log.txt
echo [INFO] %date% %time% - PXNG Free Tweaking Utility Started > %LOG_FILE%

rem Hardware Detection Function
call :detect_hardware

:backup_prompt
echo Before starting, do you want to create a registry backup? (Recommended)
echo 1. Yes, create backup
echo 2. No, skip
set /p choice=Enter your choice (1 or 2): 
if "%choice%"=="1" goto create_backup
if "%choice%"=="2" goto menu
goto backup_prompt

:create_backup
echo Creating backup...
reg export HKLM\System\CurrentControlSet\Control PXNG_Backup_System.reg >nul
reg export HKCU PXNG_Backup_User.reg >nul
if %errorlevel%==0 (
    echo [INFO] Backup created successfully >> %LOG_FILE%
    echo Backup created successfully: PXNG_Backup_System.reg and PXNG_Backup_User.reg
) else (
    echo [WARNING] Backup creation failed. Continuing without backup... >> %LOG_FILE%
    echo Warning: Backup creation failed. Continuing without backup...
)
echo.
pause
goto menu

:menu
cls
echo                                               ============================================================
echo                                                                PXNG Free Tweaking Utility V4.1                                                             
echo                                                                 Main Menu - Select an Option
echo                                               ============================================================
echo.
echo                                                      1. Apply CPU Tweaks        2. Apply GPU Tweaks
echo.
echo                                                      3. Apply RAM Tweaks        4. Apply Ethernet Tweaks
echo.
echo                                                      5. Apply Windows Tweaks    6. Apply General Tweaks
echo.
echo                                                      7. Exit
echo                                               ============================================================
set /p choice=Enter your choice (1-7): 

if "%choice%"=="1" goto cpu_tweaks
if "%choice%"=="2" goto gpu_tweaks
if "%choice%"=="3" goto ram_tweaks
if "%choice%"=="4" goto ethernet_tweaks
if "%choice%"=="5" goto windows_tweaks
if "%choice%"=="6" goto general_tweaks
if "%choice%"=="7" goto exit
echo Invalid choice. Try again.
pause
goto menu

:cpu_tweaks
cls
echo                                               ============================================================                                               
echo                                                               PXNG Free Tweaking Utility V4.1
echo                                                                  Applying CPU Tweaks...
echo                                               ============================================================
rem Apply CPU tweaks and log the actions
echo [INFO] Applying CPU tweaks... >> %LOG_FILE%

rem Set processor performance minimum state to 0% (for max efficiency)
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\0cc5b647-c1df-4637-891a-dec35c318583" /v Attributes /t REG_DWORD /d 2 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\0cc5b647-c1df-4637-891a-dec35c318583" /v ValueMin /t REG_DWORD /d 0 /f

rem Set processor priority for foreground apps
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v Win32PrioritySeparation /t REG_DWORD /d 26 /f

rem Disable Time Broker service
reg add "HKLM\SYSTEM\CurrentControlSet\Services\TimeBrokerSvc" /v Start /t REG_DWORD /d 4 /f

echo CPU tweaks applied successfully!
echo [INFO] CPU tweaks applied successfully! >> %LOG_FILE%
pause
goto menu

:gpu_tweaks
cls
echo                                              ============================================================
echo                                                               PXNG Free Tweaking Utility V4.1
echo                                                                  Applying GPU Tweaks...
echo                                              ============================================================
rem Apply GPU tweaks and log the actions
echo [INFO] Applying GPU tweaks... >> %LOG_FILE%

rem Enable hardware-accelerated GPU scheduling
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v HwSchMode /t REG_DWORD /d 2 /f

rem Enable GPU preemption for better rendering
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Scheduler" /v EnablePreemption /t REG_DWORD /d 2 /f

rem Enable GPU maximum performance mode for NVIDIA GPUs
reg add "HKCU\Software\NVIDIA Corporation\Global\NVTweak" /v "PowerMizerMode" /t REG_DWORD /d 1 /f

rem Enable V-Sync to prevent screen tearing (useful for smooth visuals)
reg add "HKCU\Software\NVIDIA Corporation\Global\NVTweak" /v "ForceVSYNC" /t REG_DWORD /d 1 /f

rem Force maximum GPU clock speed
reg add "HKCU\Software\NVIDIA Corporation\Global\NVTweak" /v "OverrideMaxClock" /t REG_DWORD /d 1 /f

rem Disable hardware acceleration for web browsers (optional for reducing GPU load)
reg add "HKCU\Software\Microsoft\Internet Explorer\Main" /v "UseHWAcceleration" /t REG_DWORD /d 0 /f

rem Disable integrated GPU in favor of dedicated GPU (for laptops with both)
reg add "HKLM\SYSTEM\CurrentControlSet\Services\amdide" /v "Start" /t REG_DWORD /d 4 /f

echo GPU tweaks applied successfully!
echo [INFO] GPU tweaks applied successfully! >> %LOG_FILE%
pause
goto menu
:ram_tweaks
cls
echo                                              ============================================================
echo                                                               PXNG Free Tweaking Utility V4.1  
echo                                                                  Applying RAM Tweaks...
echo                                              ============================================================
rem Apply RAM tweaks and log the actions
echo [INFO] Applying RAM tweaks... >> %LOG_FILE%

rem Enable LargeSystemCache for better memory management
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v LargeSystemCache /t REG_DWORD /d 1 /f

rem Disable paging executive to keep core Windows services in memory
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v DisablePagingExecutive /t REG_DWORD /d 1 /f

rem Increase system page file size for performance
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v PagingFiles /t REG_MULTI_SZ /d "C:\pagefile.sys 4096 8192" /f

rem Set physical memory usage to maximum (for high-performance systems)
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "LowMemorySystem" /t REG_DWORD /d 1 /f

rem Enable ReadyBoost for additional caching
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "EnableReadyBoost" /t REG_DWORD /d 1 /f

rem Reduce memory usage for background apps
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "MemoryUsage" /t REG_DWORD /d 1 /f

rem Set maximum RAM cache size for faster access
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "IoPageLockLimit" /t REG_DWORD /d 262144 /f

echo RAM tweaks applied successfully!
echo [INFO] RAM tweaks applied successfully! >> %LOG_FILE%
pause
goto menu

:ethernet_tweaks
cls
echo                                               ============================================================
echo                                                               PXNG Free Tweaking Utility V4.1
echo                                                                  Applying Ethernet Tweaks...
echo                                               ============================================================
rem Apply Ethernet tweaks and log the actions
echo [INFO] Applying Ethernet tweaks... >> %LOG_FILE%

rem Disable Nagle's Algorithm for lower latency
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v TcpNoDelay /t REG_DWORD /d 1 /f

rem Set TCP/UDP buffer size for optimized network throughput
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpWindowSize" /t REG_DWORD /d 8388608 /f

rem Enable Receive Side Scaling (for multi-core CPUs)
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v EnableRSS /t REG_DWORD /d 1 /f

rem Enable Jumbo Frames for better performance on large networks
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v EnableJumboFrames /t REG_DWORD /d 1 /f

rem Disable auto-tuning to improve speed
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v TcpAutotuning /t REG_DWORD /d 0 /f

rem Optimize the MaxMTU size for best throughput
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v "MTU" /t REG_DWORD /d 1500 /f

rem Enable QoS Packet Scheduler for priority routing
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "EnableQoS" /t REG_DWORD /d 1 /f

echo Ethernet tweaks applied successfully!
echo [INFO] Ethernet tweaks applied successfully! >> %LOG_FILE%
pause
goto menu

:windows_tweaks
cls
echo                                                ============================================================
echo                                                               PXNG Free Tweaking Utility V4.1 
echo                                                                  Applying Windows Tweaks...
echo                                                ============================================================
rem Apply Windows tweaks and log the actions
echo [INFO] Applying Windows tweaks... >> %LOG_FILE%

rem Reduce menu animation delay
reg add "HKCU\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d 0 /f

rem Set power plan to high performance
powercfg -setactive SCHEME_MAX

echo Windows tweaks applied successfully!
echo [INFO] Windows tweaks applied successfully! >> %LOG_FILE%
pause
goto menu

:general_tweaks
cls
echo                                                  ============================================================
echo                                                               PXNG Free Tweaking Utility V4.1   
echo                                                                  Applying General Tweaks...
echo                                                  ============================================================
rem Apply Windows tweaks and log the actions
echo [INFO] Applying Windows tweaks... >> %LOG_FILE%

rem Reduce menu animation delay
reg add "HKCU\Control Panel\Desktop" /v MenuShowDelay /t REG_DWORD /d 0 /f

rem Disable Windows Defender real-time protection (optional for performance)
reg add "HKLM\SOFTWARE\Microsoft\Windows Defender\Real-Time Protection" /v "DisableRealtimeMonitoring" /t REG_DWORD /d 1 /f

rem Turn off Cortana and speech services
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "AllowCortana" /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Speech" /v "EnableSpeechRecognition" /t REG_DWORD /d 0 /f

rem Disable unnecessary Windows services (like Superfetch and Windows Search)
reg add "HKLM\SYSTEM\CurrentControlSet\Services\SysMain" /v Start /t REG_DWORD /d 4 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WSearch" /v Start /t REG_DWORD /d 4 /f

rem Set system to high performance power plan
powercfg /setactive SCHEME_MIN

echo Windows tweaks applied successfully!
echo [INFO] Windows tweaks applied successfully! >> %LOG_FILE%
pause
goto menu


:exit
cls
echo                                                    ============================================================
echo                                                         Thanks for using PXNG Free Tweaking Utility V4.1
echo                                                    ============================================================
echo [INFO] %date% %time% - PXNG Free Tweaking Utility Exited >> %LOG_FILE%
pause
exit

:detect_hardware
echo ============================================================
echo                 PXNG Free Tweaking Utility V4.1
echo                      Detecting hardware...
echo ============================================================
echo CPU: %PROCESSOR_IDENTIFIER%
echo GPU: %SystemRoot%\System32\DriverStore\FileRepository\*driver*.inf
echo RAM: %TotalPhysicalMemory% bytes
echo Ethernet Adapter: %NETWORK_ADAPTER%
pause
goto menu
