#ifndef SWITCH_MBEDTLS_CONFIG_H
#define SWITCH_MBEDTLS_CONFIG_H

/* Nintendo Switch platform integration. */
#undef MBEDTLS_NET_C
#undef MBEDTLS_TIMING_C

/* Required for DTLS-SRTP / WebRTC. */
#define MBEDTLS_SSL_DTLS_SRTP

#endif
