# Mbed TLS 4.2.0 — Nintendo Switch Support

Nintendo Switch homebrew support for Mbed TLS 4.2.0 and TF-PSA-Crypto.

## Requirements

Linux, CMake, GNU Make, Python 3, jsonschema, Perl,
devkitPro, devkitA64, and libnx.

Ubuntu / Pop!_OS dependency:

    sudo apt install python3-jsonschema

## Clone

Clone recursively to include all upstream submodules:

    git clone --recursive <repository-url>

Use the nintendo-switch-support branch.

## Build

From the repository root:

    ./ports/nintendo-switch/build.sh

Or specify an external build directory:

    ./ports/nintendo-switch/build.sh /path/to/build

By default, devkitPro is expected at /opt/devkitpro.

## Build outputs

The install/lib directory contains:

- libmbedtls.a
- libmbedx509.a
- libmbedcrypto.a
- libtfpsacrypto.a
- switch_platform.o

The crypto archive names may refer to the same underlying library.
Do not link both unnecessarily.

## Switch platform integration

The platform object supplies:

- mbedtls_ms_time
- mbedtls_psa_external_get_random
- mbedtls_platform_zeroize

Applications must link switch_platform.o and the required static
libraries using the devkitPro/libnx Switch linker configuration.

A minimal executable was successfully linked using switch.specs.

## Validation

Verified:

- Clean CMake configuration
- Static library compilation
- Header and library installation
- Switch platform object compilation
- Platform symbol verification
- Nintendo Switch AArch64 ELF linking

Runtime operation, TLS/DTLS interoperability, and WebRTC functionality
have not yet been validated by these publication tests.

## Licensing

Upstream Mbed TLS history, copyright notices, and licenses are
preserved. Submodule licenses remain applicable.

Nintendo Switch support is provided as a community contribution
without any guarantee of ongoing maintenance.
