.. 嵌入式知识库文档集 documentation master file, created by
   sphinx-quickstart on Sat Oct  5 14:12:53 2024.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

====================
开源环境搭建
====================

.. image:: https://img.shields.io/badge/环境-Windows-blue
   :alt: Windows环境

.. image:: https://img.shields.io/badge/IDE-VSCode-007ACC
   :alt: VSCode

.. image:: https://img.shields.io/badge/编译器-ARM--GCC-brightgreen
   :alt: ARM-GCC

.. image:: https://img.shields.io/badge/包管理-Conan-6699CB
   :alt: Conan

.. image:: https://img.shields.io/badge/工具链-MinGW-yellow
   :alt: MinGW

本指南将详细介绍开源环境的开发环境搭建过程，适配与所有单片机，包括STM32等。我们将使用VSCode作为集成开发环境,结合ARM-GCC编译器、Conan包管理器和MinGW工具链,构建一个强大而完整的开发环境。

📦 软件要求
-----------

以下是所需软件及其版本的详细列表:

.. list-table::
   :header-rows: 1
   :widths: 15 15 35 35
   :class: custom-table

   * - 📌 软件
     - 🔢 版本
     - 📝 说明
     - 🔗 下载链接
   * - Visual Studio Code
     - 最新版
     - 强大的集成开发环境
     - `VSCode官方下载 <https://code.visualstudio.com/download>`_
   * - ARM-GCC
     - gcc-arm-none-eabi-10.3-2021.10-win32
     - ARM架构的GCC编译器
     - `ARM-GCC下载 <https://developer.arm.com/-/media/Files/downloads/gnu-rm/10.3-2021.10/gcc-arm-none-eabi-10.3-2021.10-win32.exe>`_
   * - Conan
     - 2.0.4
     - 现代化C/C++包管理器
     - 通过pip安装
   * - Python
     - 3.8.x
     - 用于运行Conan
     - :download:`Python3.8.7下载 <soft/python-3.8.7-amd64.exe>`
   * - MinGW
     - 11.0.0-r5
     - Windows的GNU工具集,包含cmake等工具
     - `MinGW 11.0.0-r5下载 <https://sourceforge.net/projects/mingw-w64/files/Toolchains%20targetting%20Win64/Personal%20Builds/mingw-builds/11.0.0/threads-posix/seh/x86_64-11.0.0-release-posix-seh-rt_v9-rev5.7z/download>`_
   * - J-Link
     - 建议7.0以下
     - SEGGER J-Link调试器软件
     - :download:`J-LinkV698c下载 <soft/JLink_Windows_V698c.exe>`

🛠️ 安装步骤
------------

1. 安装Visual Studio Code
^^^^^^^^^^^^^^^^^^^^^^^^^

.. image:: https://code.visualstudio.com/assets/images/code-stable.png
   :alt: VSCode Logo
   :width: 100px
   :align: right

1. 访问 `VSCode官方下载页面 <https://code.visualstudio.com/download>`_
2. 下载并运行Windows版安装程序
3. 按照安装向导的提示完成安装

2. 安装ARM-GCC编译器
^^^^^^^^^^^^^^^^^^^^

1. 下载gcc-arm-none-eabi-10.3-2021.10-win32.exe
2. 运行安装程序,选择安装目录(例如: C:\\Program Files (x86)\\GNU Arm Embedded Toolchain)
3. 完成安装后,将安装目录下的bin文件夹添加到系统环境变量PATH中

3. 安装Python 3.8
^^^^^^^^^^^^^^^^^

.. image:: https://www.python.org/static/community_logos/python-logo-generic.svg
   :alt: Python Logo
   :width: 100px
   :align: right

1. 访问 `Python 3.8.10下载页面 <https://www.python.org/downloads/release/python-3810/>`_
2. 下载Windows安装程序(64位)
3. 运行安装程序,确保勾选"Add Python 3.8 to PATH"选项
4. 完成安装

4. 安装Conan
^^^^^^^^^^^^

1. 打开命令提示符或PowerShell
2. 运行以下命令安装Conan 2.0.4:

   .. code-block:: bash

      pip install conan==2.0.4

3. 安装完成后,验证安装:

   .. code-block:: bash

      conan --version

4. 生成conan配置文件:

   .. code-block:: bash

      conan profile detect --force

5. 下载并覆盖配置文件:
   
   :download:`settings.yml <soft/settings.yml>`

6. 下载并解压profile文件:
   
   :download:`profiles.zip <soft/profiles.zip>`

7. 使用登录脚本进行Conan登录:
   
   :download:`conan用户注册脚本 <soft/conan用户登录脚本.bat>`

5. 安装MinGW
^^^^^^^^^^^^

1. 下载 `MinGW 11.0.0-r5 <https://sourceforge.net/projects/mingw-w64/files/Toolchains%20targetting%20Win64/Personal%20Builds/mingw-builds/11.0.0/threads-posix/seh/x86_64-11.0.0-release-posix-seh-rt_v9-rev5.7z/download>`_
2. 解压文件到指定目录,例如 C:\\MinGW
3. 将MinGW的bin目录(C:\\MinGW\\bin)添加到系统环境变量PATH中

6. 安装J-Link软件
^^^^^^^^^^^^^^^^^

1. 访问 `SEGGER J-Link下载页面 <https://www.segger.com/downloads/jlink/>`_
2. 下载适用于Windows的J-Link软件包
3. 运行安装程序,按照向导完成安装
4. 将J-Link安装目录添加到系统环境变量PATH中

🔧 配置环境变量
---------------

为确保所有工具可以在命令行中正常使用,需要将以下路径添加到系统环境变量PATH中:

1. ARM-GCC bin目录: ``C:\Program Files (x86)\GNU Arm Embedded Toolchain\10.3 2021.10\bin``
2. MinGW bin目录: ``C:\MinGW\bin``
3. J-Link安装目录: ``C:\Program Files (x86)\SEGGER\JLink``

添加环境变量的步骤:

1. 右键点击"此电脑"或"我的电脑",选择"属性"
2. 点击"高级系统设置"
3. 在"系统属性"窗口中,点击"环境变量"
4. 在"系统变量"部分,找到并选中"Path"变量,然后点击"编辑"
5. 在新窗口中,点击"新建",然后添加上述路径
6. 点击"确定"保存所有更改

✅ 验证安装
-----------

完成所有安装和配置后,打开一个新的命令提示符或PowerShell窗口,运行以下命令验证各个组件是否正确安装:

.. code-block:: bash

   vscode --version
   arm-none-eabi-gcc --version
   python --version
   conan --version
   gcc --version
   JLink.exe --version
   cmake --version

如果所有命令都能正确返回版本信息,则说明环境已经成功搭建。

🎉 结语
-------

恭喜您! 您已经成功完成了开源开发环境的搭建。这个强大的环境包括:

- VSCode作为现代化IDE
- ARM-GCC用于交叉编译
- Conan用于高效的包管理
- MinGW提供Windows下的GNU工具支持

确保所有工具都在PATH中,以便在VSCode的集成终端中使用。如果在使用过程中遇到任何问题,请检查相应的软件版本和环境变量设置。

祝您开发顺利,创造出令人惊叹的项目!

.. note::
   如有任何疑问或需要进一步的帮助,请随时联系我。

   

