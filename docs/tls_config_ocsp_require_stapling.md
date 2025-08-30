TLS\_CONFIG\_OCSP\_REQUIRE\_STAPLING(3) - Library Functions Manual

# NAME

**tls\_config\_ocsp\_require\_stapling** - OCSP configuration for libtls

# SYNOPSIS

**#include &lt;tls.h>**

*void*  
**tls\_config\_ocsp\_require\_stapling**(*struct tls\_config \*config*);

# DESCRIPTION

**tls\_config\_ocsp\_require\_stapling**()
requires that a valid stapled OCSP response be provided
during the TLS handshake.

# SEE ALSO

tls\_config\_add\_keypair\_file(3),
tls\_handshake(3),
tls\_init(3),
tls\_ocsp\_process\_response(3)

# HISTORY

These functions appeared in
OpenBSD 6.1.

# AUTHORS

Bob Beck &lt;[beck@openbsd.org](mailto:beck@openbsd.org)&gt;

Debian - January 31, 2017
