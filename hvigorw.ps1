$devecoHome = $null
if ($env:DEVECO_STUDIO_HOME -and (Test-Path (Join-Path $env:DEVECO_STUDIO_HOME 'tools\hvigor\bin\hvigorw.js'))) {
  $devecoHome = $env:DEVECO_STUDIO_HOME
}
if (-not $devecoHome) {
  $defaultHome = 'C:\Program Files\HuaWei\DevEco Studio'
  if (Test-Path (Join-Path $defaultHome 'tools\hvigor\bin\hvigorw.js')) {
    $devecoHome = $defaultHome
  }
}
if (-not $devecoHome) {
  $legacyHome = 'D:\develop\Huawei\DevEco Studio'
  if (Test-Path (Join-Path $legacyHome 'tools\hvigor\bin\hvigorw.js')) {
    $devecoHome = $legacyHome
  }
}
if (-not $devecoHome) {
  Write-Error 'DevEco Studio installation not found. Set DEVECO_STUDIO_HOME or update hvigorw.ps1.'
  exit 1
}

$hvigorJs = Join-Path $devecoHome 'tools\hvigor\bin\hvigorw.js'
$devecoSdkHome = Join-Path $devecoHome 'sdk'
$nodeExe = Join-Path $devecoHome 'tools\node\node.exe'

if (-not (Test-Path $hvigorJs)) {
  Write-Error "hvigor wrapper not found: $hvigorJs"
  Write-Error 'Please update hvigorw.ps1 to your local DevEco Studio installation path.'
  exit 1
}

if (-not (Test-Path $devecoSdkHome)) {
  Write-Error "DevEco SDK not found: $devecoSdkHome"
  Write-Error 'Please update DEVECO_SDK_HOME in hvigorw.ps1 to your local DevEco SDK root.'
  exit 1
}

if (-not (Test-Path $nodeExe)) {
  Write-Error "DevEco node.exe not found: $nodeExe"
  exit 1
}

$env:DEVECO_SDK_HOME = $devecoSdkHome
& $nodeExe $hvigorJs @args
