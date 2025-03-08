@echo off
setlocal enabledelayedexpansion

REM ��ȡ�û�ѡ��
echo ��ѡ�����ϵͳ:
echo 1, Windows
echo 2, Linux

REM �������Ƿ����
set /p "system=������: "

REM �����û�ѡ���ӡ��Ӧϵͳ����
if "%system%"=="1" (
    echo ��ѡ��Ĳ���ϵͳ��: Windows.
    set "CONAN_COMMAND=conan.exe"
) else if "%system%"=="2" (
    echo ��ѡ��Ĳ���ϵͳ��: Linux.
    set "CONAN_COMMAND=conan"
) else (
    echo ��Ч��ѡ��: %system%�������� 1 �� 2 ��ѡ�����ϵͳ
    exit /b 1
)

echo ��ѡ���Ʒ��:
echo 1, ���ܶ�·����Ʒ��
echo 2, ����˫ģ��Ʒ��

REM �������Ƿ����
set /p "product_line=������: "

REM �����û�ѡ���ӡ��Ӧϵͳ����
if "!product_line!"=="1" (
    echo ��ѡ��Ĳ�Ʒ����: ���ܶ�·����Ʒ��.
) else if "!product_line!"=="2" (
    echo ��ѡ��Ĳ�Ʒ����: ����˫ģ��Ʒ��.
) else (
    echo ��Ч��ѡ��
    exit /b 1
)

REM ��ʾ�û������˺�
echo ����������conan jfrog�˺�:

REM �������Ƿ����
set /p "username=������: "

REM ��ʾ�û��������루�ⲻ�ǰ�ȫ�������������ʹ�ã�
echo ����������conan jfrog����:

REM �������Ƿ����
set /p "password=������: "

"%CONAN_COMMAND%" remote remove "*" 2>nul

"%CONAN_COMMAND%" remote add pib-all http://172.17.0.250:8082/artifactory/api/conan/pib-all
echo �������ֿ� pib-all
if errorlevel 1 (
    echo �������ֿ� pib-all ʧ��
    exit /b 1
)
echo ��¼����ֿ� pib-all
"%CONAN_COMMAND%" remote login pib-all !username! -p !password!
if errorlevel 1 (
    echo ��¼����ֿ� pib-all ʧ��
    exit /b 1
)

REM ����Զ������ֿ�
"%CONAN_COMMAND%" remote add pdm-all http://172.17.0.250:8082/artifactory/api/conan/pdm-all
echo �������ֿ� pdm-all
if errorlevel 1 (
    echo �������ֿ� pdm-all ʧ��
    exit /b 1
)
echo ��¼����ֿ� pdm-all
"%CONAN_COMMAND%" remote login pdm-all !username! -p !password!
if errorlevel 1 (
    echo ��¼����ֿ� pdm-all ʧ��
    exit /b 1
)

REM ����Զ�̿����ֿ��б�
REM �����Ʒ��
if "!product_line!"=="1" (
    set "remotes=pib-algorithm pib-classlib pib-general pib-mcudriver pib-rtos pib-subsystem"
REM �ز���Ʒ��
) else if "!product_line!"=="2" (
    set "remotes=pdm-general pdm-sdk pib-general"
)

REM ѭ����Ӻ͵�¼Զ�ֿ̲�
for %%r in (%remotes%) do (
    echo ���Զ�ֿ̲� %%r
    "%CONAN_COMMAND%" remote add %%r http://172.17.0.250:8082/artifactory/api/conan/%%r
    if errorlevel 1 (
        echo ���Զ�ֿ̲� %%r ʧ��
        exit /b 1
    )

    echo ��¼Զ�ֿ̲� %%r
    "%CONAN_COMMAND%" remote login %%r !username! -p !password!
    if errorlevel 1 (
        echo ��¼Զ�ֿ̲� %%r ʧ��
        exit /b 1
    )
)

echo �������
pause

exit /b
