. "$PSScriptRoot\paths.ps1"

# =========================
# Compile raylib-parser
# =========================
Write-Host "Compiling raylib-parser..."

# Use cl.exe (MSVC) to compile
& cl.exe `
    /nologo /EHsc /Fe:$parserExe `
    "$parserDir\raylib_parser.c"

if ($LASTEXITCODE -ne 0) {
    Write-Error "Failed to compile raylib-parser"
    exit 1
}