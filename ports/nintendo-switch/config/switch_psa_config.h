#ifndef SWITCH_PSA_CONFIG_H
#define SWITCH_PSA_CONFIG_H
#define MBEDTLS_THREADING_C
#define MBEDTLS_THREADING_PTHREAD


/* Use the Nintendo Switch's libnx random generator. */
#undef MBEDTLS_PSA_BUILTIN_GET_ENTROPY
#define MBEDTLS_PSA_CRYPTO_EXTERNAL_RNG

/* Supply a monotonic millisecond clock through libnx. */
#define MBEDTLS_PLATFORM_ZEROIZE_ALT
#define MBEDTLS_PLATFORM_MS_TIME_ALT

#endif
