. "$PSScriptRoot\paths.ps1"

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