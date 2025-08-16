# Delay execution until all targets are defined
cmake_language(DEFER CALL set_target_properties raylib PROPERTIES
    OUTPUT_NAME "staticraylib"
)
