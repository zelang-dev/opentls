TLS\_OCSP\_PROCESS\_RESPONSE(3) - Library Functions Manual

# NAME

**tls\_ocsp\_process\_response**,
**tls\_peer\_ocsp\_url**,
**tls\_peer\_ocsp\_response\_status**,
**tls\_peer\_ocsp\_cert\_status**,
**tls\_peer\_ocsp\_crl\_reason**,
**tls\_peer\_ocsp\_result**,
**tls\_peer\_ocsp\_revocation\_time**,
**tls\_peer\_ocsp\_this\_update**,
**tls\_peer\_ocsp\_next\_update** - inspect an OCSP response

# SYNOPSIS

**#include &lt;tls.h>**

*int*  
**tls\_ocsp\_process\_response**(*struct tls \*ctx*,
*const unsigned char \*response*,
*size\_t size*);

*const char \*&zwnj;*  
**tls\_peer\_ocsp\_url**(*struct tls \*ctx*);

*int*  
**tls\_peer\_ocsp\_response\_status**(*struct tls \*ctx*);

*int*  
**tls\_peer\_ocsp\_cert\_status**(*struct tls \*ctx*);

*int*  
**tls\_peer\_ocsp\_crl\_reason**(*struct tls \*ctx*);

*const char \*&zwnj;*  
**tls\_peer\_ocsp\_result**(*struct tls \*ctx*);

*time\_t*  
**tls\_peer\_ocsp\_revocation\_time**(*struct tls \*ctx*);

*time\_t*  
**tls\_peer\_ocsp\_this\_update**(*struct tls \*ctx*);

*time\_t*  
**tls\_peer\_ocsp\_next\_update**(*struct tls \*ctx*);

# DESCRIPTION

**tls\_ocsp\_process\_response**()
processes a raw OCSP response in
*response*
of size
*size*
to check the revocation status of the peer certificate from
*ctx*.
A successful return code of 0 indicates that the certificate
has not been revoked.

**tls\_peer\_ocsp\_url**()
returns the URL for OCSP validation of the peer certificate from
*ctx*.

The following functions return information about the peer certificate from
*ctx*
that was obtained by validating a stapled OCSP response during the handshake,
or via a previous call to
**tls\_ocsp\_process\_response**().

**tls\_peer\_ocsp\_response\_status**()
returns the OCSP response status as per RFC 6960 section 2.3.

**tls\_peer\_ocsp\_cert\_status**()
returns the OCSP certificate status code as per RFC 6960 section 2.2.

**tls\_peer\_ocsp\_crl\_reason**()
returns the OCSP certificate revocation reason status code as per RFC 5280
section 5.3.1.

**tls\_peer\_ocsp\_result**()
returns a textual representation of the OCSP status code
returned by one of the previous three functions.
If the OCSP response was valid and the certificate was not
revoked, the string indicates the OCSP certificate status.
Otherwise, the string indicates
the OCSP certificate revocation reason or the OCSP error.

**tls\_peer\_ocsp\_revocation\_time**()
returns the OCSP revocation time.

**tls\_peer\_ocsp\_this\_update**()
returns the OCSP this update time.

**tls\_peer\_ocsp\_next\_update**()
returns the OCSP next update time.

# RETURN VALUES

**tls\_ocsp\_process\_response**()
returns 0 on success or -1 on error.

**tls\_peer\_ocsp\_url**()
and
**tls\_peer\_ocsp\_result**()
return
`NULL`
on error or an out of memory condition.

The
**tls\_peer\_ocsp\_response\_status**()
function returns one of
`TLS_OCSP_RESPONSE_SUCCESSFUL`,
`TLS_OCSP_RESPONSE_MALFORMED`,
`TLS_OCSP_RESPONSE_INTERNALERROR`,
`TLS_OCSP_RESPONSE_TRYLATER`,
`TLS_OCSP_RESPONSE_SIGREQUIRED`,
or
`TLS_OCSP_RESPONSE_UNAUTHORIZED`
on success or -1 on error.

The
**tls\_peer\_ocsp\_cert\_status**()
function returns one of
`TLS_OCSP_CERT_GOOD`,
`TLS_OCSP_CERT_REVOKED`,
or
`TLS_OCSP_CERT_UNKNOWN`
on success, and -1 on error.

The
**tls\_peer\_ocsp\_crl\_reason**()
function returns one of
`TLS_CRL_REASON_UNSPECIFIED`,
`TLS_CRL_REASON_KEY_COMPROMISE`,
`TLS_CRL_REASON_CA_COMPROMISE`,
`TLS_CRL_REASON_AFFILIATION_CHANGED`,
`TLS_CRL_REASON_SUPERSEDED`,
`TLS_CRL_REASON_CESSATION_OF_OPERATION`,
`TLS_CRL_REASON_CERTIFICATE_HOLD`,
`TLS_CRL_REASON_REMOVE_FROM_CRL`,
`TLS_CRL_REASON_PRIVILEGE_WITHDRAWN`,
or
`TLS_CRL_REASON_AA_COMPROMISE`
on success or -1 on error.

**tls\_peer\_ocsp\_revocation\_time**(),
**tls\_peer\_ocsp\_this\_update**(),
and
**tls\_peer\_ocsp\_next\_update**()
return a time in epoch-seconds on success or -1 on error.

# SEE ALSO

tls\_client(3),
tls\_config\_ocsp\_require\_stapling(3),
tls\_conn\_version(3),
tls\_connect(3),
tls\_handshake(3),
tls\_init(3)

# HISTORY

These functions appeared in
OpenBSD 6.1.

# AUTHORS

Bob Beck &lt;[beck@openbsd.org](mailto:beck@openbsd.org)&gt;  
Marko Kreen &lt;[markokr@gmail.com](mailto:markokr@gmail.com)&gt;

Debian - July 24, 2018
