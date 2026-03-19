@echo off
setlocal

set "DEVECO_HOME="
if defined DEVECO_STUDIO_HOME (
  if exist "%DEVECO_STUDIO_HOME%\tools\hvigor\bin\hvigorw.js" (
    set "DEVECO_HOME=%DEVECO_STUDIO_HOME%"
  )
)
if not defined DEVECO_HOME (
  if exist "C:\Program Files\HuaWei\DevEco Studio\tools\hvigor\bin\hvigorw.js" (
    set "DEVECO_HOME=C:\Program Files\HuaWei\DevEco Studio"
  )
)
if not defined DEVECO_HOME (
  if exist "D:\develop\Huawei\DevEco Studio\tools\hvigor\bin\hvigorw.js" (
    set "DEVECO_HOME=D:\develop\Huawei\DevEco Studio"
  )
)
if not defined DEVECO_HOME (
  echo DevEco Studio installation not found.
  echo Set DEVECO_STUDIO_HOME or update hvigorw.cmd to your local installation path.
  exit /b 1
)

set "HVGOR_JS=%DEVECO_HOME%\tools\hvigor\bin\hvigorw.js"
set "DEVECO_SDK_HOME=%DEVECO_HOME%\sdk"
set "NODE_EXE=%DEVECO_HOME%\tools\node\node.exe"

if not exist "%HVGOR_JS%" (
  echo hvigor wrapper not found: "%HVGOR_JS%"
  echo Please update HVGOR_JS in hvigorw.cmd to your local DevEco Studio installation path.
  exit /b 1
)

if not exist "%DEVECO_SDK_HOME%" (
  echo DevEco SDK not found: "%DEVECO_SDK_HOME%"
  echo Please update DEVECO_SDK_HOME in hvigorw.cmd to your local DevEco SDK root.
  exit /b 1
)

if not exist "%NODE_EXE%" (
  echo DevEco node.exe not found: "%NODE_EXE%"
  exit /b 1
)

set "DEVECO_SDK_HOME=%DEVECO_SDK_HOME%"
"%NODE_EXE%" "%HVGOR_JS%" %*
