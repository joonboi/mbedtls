#!/usr/bin/env bash
set -euo pipefail

repo="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
port="$repo/ports/nintendo-switch"

: "${DEVKITPRO:=/opt/devkitpro}"

build="${1:-$repo/build-nintendo-switch}"
install="$build/install"

cc="$DEVKITPRO/devkitA64/bin/aarch64-none-elf-gcc"
nm="$DEVKITPRO/devkitA64/bin/aarch64-none-elf-nm"

test -x "$cc"
test -x "$nm"
test -f "$repo/tf-psa-crypto/CMakeLists.txt"

cmake -G "Unix Makefiles" -S "$repo" -B "$build" \
  -DCMAKE_TOOLCHAIN_FILE="$port/cmake/switch-toolchain.cmake" \
  -DCMAKE_INSTALL_PREFIX="$install" \
  -DCMAKE_C_FLAGS="-march=armv8-a -mtune=cortex-a57 -mtp=soft -ffunction-sections -fdata-sections -fPIC" \
  -DCMAKE_EXE_LINKER_FLAGS="-no-pie" \
  -DENABLE_PROGRAMS=OFF \
  -DENABLE_TESTING=OFF \
  -DUSE_STATIC_MBEDTLS_LIBRARY=ON \
  -DUSE_SHARED_MBEDTLS_LIBRARY=OFF \
  -DUSE_STATIC_TF_PSA_CRYPTO_LIBRARY=ON \
  -DUSE_SHARED_TF_PSA_CRYPTO_LIBRARY=OFF \
  -DMBEDTLS_USER_CONFIG_FILE="$port/config/switch_mbedtls_config.h" \
  -DTF_PSA_CRYPTO_USER_CONFIG_FILE="$port/config/switch_psa_config.h" \
  -DTF_PSA_CRYPTO_CONFIG_SET="MBEDTLS_THREADING_C;MBEDTLS_THREADING_PTHREAD"

cmake --build "$build" --parallel "$(nproc)"
cmake --install "$build"

# Use the same TF-PSA-Crypto include directories that CMake
# generated for the Mbed TLS library compilation.
flags="$build/library/CMakeFiles/mbedtls.dir/flags.make"

if [ ! -f "$flags" ]; then
  echo "ERROR: Expected CMake Makefiles include configuration." >&2
  exit 1
fi

includes="$(sed -n 's/^C_INCLUDES = //p' "$flags")"
test -n "$includes"
read -r -a include_args <<< "$includes"

mkdir -p "$install/lib"

"$cc" \
  -march=armv8-a \
  -mtune=cortex-a57 \
  -mtp=soft \
  -O2 \
  -fPIC \
  -ffunction-sections \
  -fdata-sections \
  -I"$DEVKITPRO/libnx/include" \
  "${include_args[@]}" \
  -I"$port/config" \
  -DMBEDTLS_USER_CONFIG_FILE='"switch_mbedtls_config.h"' \
  -DTF_PSA_CRYPTO_USER_CONFIG_FILE='"switch_psa_config.h"' \
  -c "$port/platform/switch_platform.c" \
  -o "$install/lib/switch_platform.o"

for symbol in \
  mbedtls_ms_time \
  mbedtls_psa_external_get_random \
  mbedtls_platform_zeroize
do
  if ! "$nm" --defined-only "$install/lib/switch_platform.o" |
       awk '$2 == "T" {print $3}' |
       grep -Fxq "$symbol"; then
    echo "ERROR: Missing platform symbol: $symbol" >&2
    exit 1
  fi
done

echo
echo "=== SWITCH BUILD COMPLETE ==="
echo "Libraries: $install/lib"
echo "Platform object: $install/lib/switch_platform.o"
