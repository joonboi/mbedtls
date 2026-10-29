set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR aarch64)

if(NOT DEFINED ENV{DEVKITPRO} OR "$ENV{DEVKITPRO}" STREQUAL "")
    set(DEVKITPRO_ROOT "/opt/devkitpro")
else()
    set(DEVKITPRO_ROOT "$ENV{DEVKITPRO}")
endif()

set(CMAKE_C_COMPILER
    "${DEVKITPRO_ROOT}/devkitA64/bin/aarch64-none-elf-gcc")
set(CMAKE_CXX_COMPILER
    "${DEVKITPRO_ROOT}/devkitA64/bin/aarch64-none-elf-g++")

set(CMAKE_AR
    "${DEVKITPRO_ROOT}/devkitA64/bin/aarch64-none-elf-ar")
set(CMAKE_RANLIB
    "${DEVKITPRO_ROOT}/devkitA64/bin/aarch64-none-elf-ranlib")

set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

set(CMAKE_C_FLAGS_INIT
    "-march=armv8-a -mtune=cortex-a57 -mtp=soft -ffunction-sections -fdata-sections"
)

set(CMAKE_FIND_ROOT_PATH
    "${DEVKITPRO_ROOT}/devkitA64"
    "${DEVKITPRO_ROOT}/libnx"
)

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
