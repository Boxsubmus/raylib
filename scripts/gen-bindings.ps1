. "$PSScriptRoot\paths.ps1"

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

#Write-Host "`nBuilding C# generator project..."
#& dotnet build $generatorProj -c Release
#
#if ($LASTEXITCODE -ne 0) {
#    Write-Error "Failed to build generator.csproj"
#    exit 1
#}

Write-Host "Running C# generator project..."
& dotnet run --project $generatorProj -c Release

if ($LASTEXITCODE -ne 0) {
    Write-Error "Failed to run generator.csproj"
    exit 1
}

Write-Host "`n✅ C# generator executed successfully."