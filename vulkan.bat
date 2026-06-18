@echo off
title S23 Vulkan Tool - Correto
:menu
cls
echo ==============================================
echo    S23 Vulkan (SkiaVK) Tool - Windows
echo ==============================================
echo 1) Ativar Vulkan (SkiaVK) e Reiniciar Apps
echo 2) Restaurar OpenGL (Reinicia o celular)
echo 3) Sair
echo ==============================================
set /p choice="Escolha [1-3]: "

if "%choice%"=="1" goto vulkan
if "%choice%"=="2" goto opengl
if "%choice%"=="3" exit
goto menu

:vulkan
echo.
echo [Injetando propriedades do Vulkan/SkiaVK...]
adb shell setprop debug.hwui.renderer skiavk
adb shell setprop debug.hwui.skia_backend vk

echo [Fechando processos para forcar a aplicacao...]
adb shell "pm list packages --user 0 | cut -f 2 -d ':' | while read pkg; do am force-stop --user 0 $pkg; done"
adb shell am force-stop com.android.systemui
adb shell am force-stop com.sec.android.app.launcher

echo [Concluido! Verifique via GPUWatch.]
pause
goto menu

:opengl
echo.
echo [Restaurando motor grafico padrao (OpenGL)...]
adb shell setprop debug.hwui.renderer opengl
adb shell setprop debug.hwui.skia_backend gl

echo [Reiniciando o aparelho para limpar o cache...]
adb reboot
exit