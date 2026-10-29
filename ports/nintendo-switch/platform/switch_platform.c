/*
 * Nintendo Switch platform integration for Mbed TLS / TF-PSA-Crypto.
 *
 * Uses libnx for monotonic timing and random generation.
 *
 * SPDX-License-Identifier: Apache-2.0 OR GPL-2.0-or-later
 */

#include <stddef.h>
#include <stdint.h>

#include <mbedtls/platform_time.h>
#include <psa/crypto.h>
#include <psa/crypto_extra.h>

#include <switch/arm/counter.h>
#include <switch/kernel/random.h>

/*
 * Monotonic millisecond clock.
 *
 * Original Nintendo Switch implementation adapted from our
 * Mbed TLS 3.6.5 port.
 */
mbedtls_ms_time_t mbedtls_ms_time(void)
{
    return (mbedtls_ms_time_t)
        (armTicksToNs(armGetSystemTick()) / 1000000ULL);
}

/*
 * PSA Crypto external random generator.
 *
 * libnx initializes its ChaCha-based generator using
 * entropy obtained from the Nintendo Switch kernel.
 */
psa_status_t mbedtls_psa_external_get_random(
    mbedtls_psa_external_random_context_t *context,
    uint8_t *output,
    size_t output_size,
    size_t *output_length)
{
    (void)context;

    if (output_length == NULL)
        return PSA_ERROR_INVALID_ARGUMENT;

    *output_length = 0;

    if (output_size != 0 && output == NULL)
        return PSA_ERROR_INVALID_ARGUMENT;

    if (output_size != 0)
        randomGet(output, output_size);

    *output_length = output_size;

    return PSA_SUCCESS;
}


/*
 * Secure memory clearing for Nintendo Switch.
 * Volatile writes prevent dead-store elimination.
 */
void mbedtls_platform_zeroize(void *buffer, size_t length)
{
    volatile unsigned char *p =
        (volatile unsigned char *)buffer;

    while (length-- != 0)
        *p++ = 0;
}
