param (
    [switch]$Gen
)

$raylibRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $raylibRoot

# Ensure CMake presets exist
if (-not (Test-Path "$raylibRoot\CMakePresets.json")) {
    Write-Error "CMakePresets.json not found in $raylibRoot"
    exit 1
}

# Define build configurations
$builds = @(
    @{Preset="dll"; Config="release"},
    @{Preset="dll"; Config="debug"},
    @{Preset="static"; Config="release"},
    @{Preset="static"; Config="debug"}
)

foreach ($b in $builds) {
    Write-Host "====================================="
    Write-Host "Building $($b.Preset) $($b.Config)"
    Write-Host "====================================="

    # Configure
    cmake --preset $($b.Preset)

    # Build
    cmake --build --preset "$($b.Preset)-$($b.Config)" --config $($b.Config)

    if ($LASTEXITCODE -ne 0) {
        Write-Error "Build failed for $($b.Preset) $($b.Config)"
        exit 1
    }
}

Write-Host "`n✅ All builds completed successfully!"

if ($Gen) {
    # Paths
    $raylibRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
    $parserDir = Join-Path $raylibRoot "tools\parser"
    $outputDir = Join-Path $raylibRoot "raylib-beef\raylib-api"
    if (-not (Test-Path $outputDir)) { New-Item -ItemType Directory -Path $outputDir | Out-Null }

    # =========================
    # Compile raylib-parser
    # =========================
    Write-Host "Compiling raylib-parser..."
    $parserExe = Join-Path $parserDir "raylib_parser.exe"

    # Use cl.exe (MSVC) to compile
    & cl.exe `
        /nologo /EHsc /Fe:$parserExe `
        "$parserDir\raylib_parser.c"

    if ($LASTEXITCODE -ne 0) {
        Write-Error "Failed to compile raylib-parser"
        exit 1
    }

    # =========================
    # Run parser for all formats
    # =========================
    $formats = @("JSON")
    $headers = @(
        @{Input="src\raylib.h"; Def="RLAPI"; Truncate=$null; Output="raylib"},
        @{Input="src\raymath.h"; Def="RMAPI"; Truncate=$null; Output="raymath"},
        @{Input="src\rlgl.h"; Def="RLAPI"; Truncate="RLGL IMPLEMENTATION"; Output="rlgl"}
        #@{Input="vendor\reasings\src\reasings.h"; Def="EASEDEF"; Truncate=$null; Output="reasings"},
        #@{Input="vendor\raygui\src\raygui.h"; Def="RAYGUIAPI"; Truncate="RAYGUI IMPLEMENTATION"; Output="raygui"},
        #@{Input="vendor\rmem\src\rmem.h"; Def="RMEMAPI"; Truncate="RMEM IMPLEMENTATION"; Output="rmem"},
        #@{Input="vendor\rres\src\rres.h"; Def="RRESAPI"; Truncate="RRES IMPLEMENTATION"; Output="rres"}
    )

    foreach ($format in $formats) {
        Write-Host "`nGenerating format: $format"

        foreach ($hdr in $headers) {
            $input = Join-Path $raylibRoot $hdr.Input
            $output = Join-Path $outputDir "$($hdr.Output).$format"
            $def = $hdr.Def
            $trunc = $hdr.Truncate

            $args = @("-i", $input, "-o", $output, "-f", $format, "-d", $def)
            if ($trunc) { $args += @("-t", $trunc) }

            Write-Host "  Processing $($hdr.Output)..."
            & $parserExe @args

            if ($LASTEXITCODE -ne 0) {
                Write-Error "raylib-parser failed on $($hdr.Output) for format $format"
                exit 1
            }
        }
    }

    Write-Host "`n✅ raylib-parser finished successfully. Outputs are in $outputDir"

    # =========================
    # Build and run C# generator
    # =========================
    $generatorProj = Join-Path $raylibRoot "raylib-beef\generator\generator.csproj"

    if (-not (Test-Path $generatorProj)) {
        Write-Error "C# generator project not found at $generatorProj"
        exit 1
    }

    Write-Host "`nBuilding C# generator project..."
    & dotnet build $generatorProj -c Release

    if ($LASTEXITCODE -ne 0) {
        Write-Error "Failed to build generator.csproj"
        exit 1
    }

    Write-Host "Running C# generator project..."
    & dotnet run --project $generatorProj -c Release

    if ($LASTEXITCODE -ne 0) {
        Write-Error "Failed to run generator.csproj"
        exit 1
    }

    Write-Host "`n✅ C# generator executed successfully."
}