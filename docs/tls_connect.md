TLS\_CONNECT(3) - Library Functions Manual

# NAME

**tls\_connect**,
**tls\_connect\_fds**,
**tls\_connect\_servername**,
**tls\_connect\_socket**,
**tls\_connect\_cbs** - instruct a TLS client to establish a connection

# SYNOPSIS

**#include &lt;tls.h>**

*int*  
**tls\_connect**(*struct tls \*ctx*,
*const char \*host*,
*const char \*port*);

*int*  
**tls\_connect\_fds**(*struct tls \*ctx*,
*int fd\_read*,
*int fd\_write*,
*const char \*servername*);

*int*  
**tls\_connect\_servername**(*struct tls \*ctx*,
*const char \*host*,
*const char \*port*,
*const char \*servername*);

*int*  
**tls\_connect\_socket**(*struct tls \*ctx*,
*int s*,
*const char \*servername*);

*int*  
**tls\_connect\_cbs**(*struct tls \*ctx*,
*ssize\_t (\*tls\_read\_cb)(struct tls \*ctx, void \*buf, size\_t buflen, void \*cb\_arg)*,
*ssize\_t (\*tls\_write\_cb)(struct tls \*ctx, const void \*buf, size\_t buflen, void \*cb\_arg)*,
*void \*cb\_arg*,
*const char \*servername*);

# DESCRIPTION

After creating a TLS client context with
tls\_client(3)
and configuring it with
tls\_configure(3),
a client connection is initiated by calling
**tls\_connect**().
This function will create a new socket, connect to the specified
*host*
and
*port*,
and then establish a secure connection.
The
*port*
may be numeric or a service name.
If it is
`NULL`,
then a
*host*
of the format "hostname:port" is permitted.
The name to use for verification is inferred from the
*host*
value.

The
**tls\_connect\_servername**()
function has the same behaviour, however the name to use for verification is
explicitly provided, for the case where the TLS server name differs from the
DNS name.

An already existing socket can be upgraded to a secure connection by calling
**tls\_connect\_socket**().

Alternatively, a secure connection can be established over a pair of existing
file descriptors by calling
**tls\_connect\_fds**().

Calling
**tls\_connect\_cbs**()
allows read and write callback functions to handle data transfers.
The specified cb\_arg parameter is passed back to the functions,
and can contain a pointer to any caller-specified data.

# RETURN VALUES

These functions return 0 on success or -1 on error.

# SEE ALSO

tls\_accept\_socket(3),
tls\_client(3),
tls\_close(3),
tls\_config\_ocsp\_require\_stapling(3),
tls\_configure(3),
tls\_handshake(3),
tls\_init(3)

# HISTORY

**tls\_connect**()
and
**tls\_connect\_socket**()
appeared in
OpenBSD 5.6
and got their final names in
OpenBSD 5.7.

**tls\_connect\_fds**()
and
**tls\_connect\_servername**()
appeared in
OpenBSD 5.7
and
**tls\_connect\_cbs**()
in
OpenBSD 6.1.

# AUTHORS

Joel Sing &lt;[jsing@openbsd.org](mailto:jsing@openbsd.org)&gt;  
Reyk Floeter &lt;[reyk@openbsd.org](mailto:reyk@openbsd.org)&gt;

**tls\_connect\_cbs**()
was written by
Tobias Pape &lt;[tobias@netshed.de](mailto:tobias@netshed.de)&gt;.

Debian - July 9, 2018
