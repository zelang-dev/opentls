TLS\_ACCEPT\_SOCKET(3) - Library Functions Manual

# NAME

**tls\_accept\_socket**,
**tls\_accept\_fds**,
**tls\_accept\_cbs** - accept an incoming client connection in a TLS server

# SYNOPSIS

**#include &lt;tls.h>**

*int*  
**tls\_accept\_socket**(*struct tls \*tls*,
*struct tls \*\*cctx*,
*int socket*);

*int*  
**tls\_accept\_fds**(*struct tls \*tls*,
*struct tls \*\*cctx*,
*int fd\_read*,
*int fd\_write*);

*int*  
**tls\_accept\_cbs**(*struct tls \*tls*,
*struct tls \*\*cctx*,
*ssize\_t (\*tls\_read\_cb)(struct tls \*ctx, void \*buf, size\_t buflen, void \*cb\_arg)*,
*ssize\_t (\*tls\_write\_cb)(struct tls \*ctx, const void \*buf, size\_t buflen, void \*cb\_arg)*,
*void \*cb\_arg*);

# DESCRIPTION

After creating a TLS server context
*tls*
with
tls\_server(3)
and configuring it with
tls\_configure(3),
a server can accept a new client connection by calling
**tls\_accept\_socket**()
on an already established socket connection.

Alternatively, a new client connection can be accepted over a pair of existing
file descriptors by calling
**tls\_accept\_fds**().

Calling
**tls\_accept\_cbs**()
allows read and write callback functions to handle data transfers.
The specified
*cb\_arg*
parameter is passed back to the functions,
and can contain a pointer to any caller-specified data.

All these functions create a new context suitable for reading and writing
and return it in
\*&zwnj;*cctx*.

# RETURN VALUES

These functions return 0 on success or -1 on error.

# SEE ALSO

tls\_close(3),
tls\_config\_set\_session\_id(3),
tls\_configure(3),
tls\_connect(3),
tls\_init(3),
tls\_server(3)

# HISTORY

**tls\_accept\_socket**()
appeared in
OpenBSD 5.6
and got its final name in
OpenBSD 5.7.

**tls\_accept\_fds**()
appeared in
OpenBSD 5.8
and
**tls\_accept\_cbs**()
in
OpenBSD 6.1.

# AUTHORS

Joel Sing &lt;[jsing@openbsd.org](mailto:jsing@openbsd.org)&gt;

**tls\_accept\_cbs**()
was written by
Tobias Pape &lt;[tobias@netshed.de](mailto:tobias@netshed.de)&gt;.

Debian - May 26, 2018
