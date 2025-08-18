$thisPath = Split-Path -Parent $MyInvocation.MyCommand.Path

$raylibRoot = Join-Path $thisPath "..\"
Set-Location $raylibRoot

$parserDir = Join-Path $raylibRoot "tools\parser"
$parserExe = Join-Path $parserDir "raylib_parser.exe"
$outputDir = Join-Path $raylibRoot "raylib-beef\raylib-api"
if (-not (Test-Path $outputDir)) { New-Item -ItemType Directory -Path $outputDir | Out-Null }