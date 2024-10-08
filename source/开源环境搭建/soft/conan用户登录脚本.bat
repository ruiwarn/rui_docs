@echo off
setlocal enabledelayedexpansion

REM 获取用户选择
echo 请选择操作系统:
echo 1, Windows
echo 2, Linux

REM 检查变量是否存在
set /p "system=请输入: "

REM 根据用户选择打印相应系统名字
if "%system%"=="1" (
    echo 您选择的操作系统是: Windows.
    set "CONAN_COMMAND=conan.exe"
) else if "%system%"=="2" (
    echo 您选择的操作系统是: Linux.
    set "CONAN_COMMAND=conan"
) else (
    echo 无效的选择: %system%，请输入 1 或 2 来选择操作系统
    exit /b 1
)

echo 请选择产品线:
echo 1, 智能断路器产品线
echo 2, 高速双模产品线

REM 检查变量是否存在
set /p "product_line=请输入: "

REM 根据用户选择打印相应系统名字
if "!product_line!"=="1" (
    echo 您选择的产品线是: 智能断路器产品线.
) else if "!product_line!"=="2" (
    echo 您选择的产品线是: 高速双模产品线.
) else (
    echo 无效的选择
    exit /b 1
)

REM 提示用户输入账号
echo 请输入您的conan jfrog账号:

REM 检查变量是否存在
set /p "username=请输入: "

REM 提示用户输入密码（这不是安全的做法，请谨慎使用）
echo 请输入您的conan jfrog密码:

REM 检查变量是否存在
set /p "password=请输入: "

"%CONAN_COMMAND%" remote remove "*" 2>nul

"%CONAN_COMMAND%" remote add pib-all http://172.17.0.250:8082/artifactory/api/conan/pib-all
echo 添加虚拟仓库 pib-all
if errorlevel 1 (
    echo 添加虚拟仓库 pib-all 失败
    exit /b 1
)
echo 登录虚拟仓库 pib-all
"%CONAN_COMMAND%" remote login pib-all !username! -p !password!
if errorlevel 1 (
    echo 登录虚拟仓库 pib-all 失败
    exit /b 1
)

REM 定义远程虚拟仓库
"%CONAN_COMMAND%" remote add pdm-all http://172.17.0.250:8082/artifactory/api/conan/pdm-all
echo 添加虚拟仓库 pdm-all
if errorlevel 1 (
    echo 添加虚拟仓库 pdm-all 失败
    exit /b 1
)
echo 登录虚拟仓库 pdm-all
"%CONAN_COMMAND%" remote login pdm-all !username! -p !password!
if errorlevel 1 (
    echo 登录虚拟仓库 pdm-all 失败
    exit /b 1
)

REM 定义远程开发仓库列表
REM 量测产品线
if "!product_line!"=="1" (
    set "remotes=pib-algorithm pib-classlib pib-general pib-mcudriver pib-rtos pib-subsystem"
REM 载波产品线
) else if "!product_line!"=="2" (
    set "remotes=pdm-general pdm-sdk pib-general"
)

REM 循环添加和登录远程仓库
for %%r in (%remotes%) do (
    echo 添加远程仓库 %%r
    "%CONAN_COMMAND%" remote add %%r http://172.17.0.250:8082/artifactory/api/conan/%%r
    if errorlevel 1 (
        echo 添加远程仓库 %%r 失败
        exit /b 1
    )

    echo 登录远程仓库 %%r
    "%CONAN_COMMAND%" remote login %%r !username! -p !password!
    if errorlevel 1 (
        echo 登录远程仓库 %%r 失败
        exit /b 1
    )
)

echo 操作完成
pause

exit /b
