TLS\_INIT(3) - Library Functions Manual

# NAME

**tls\_init**,
**tls\_config\_new**,
**tls\_config\_free**,
**tls\_config\_error** - initialize TLS client and server API

# SYNOPSIS

**#include &lt;tls.h>**

*int*  
**tls\_init**(*void*);

*struct tls\_config \*&zwnj;*  
**tls\_config\_new**(*void*);

*void*  
**tls\_config\_free**(*struct tls\_config \*config*);

*const char \*&zwnj;*  
**tls\_config\_error**(*struct tls\_config \*config*);

# DESCRIPTION

The
**tls**
family of functions establishes a secure communications channel
using the TLS socket protocol.
Both clients and servers are supported.

The
**tls\_init**()
function initializes global data structures.
It is no longer necessary to call this function directly,
since it is invoked internally when needed.
It may be called more than once, and may be called concurrently.

Before a connection is created, a configuration must be created.
The
**tls\_config\_new**()
function allocates, initializes, and returns a new default configuration
object that can be used for future connections.
Several functions exist to change the options of the configuration; see
tls\_config\_set\_protocols(3),
tls\_load\_file(3),
tls\_config\_ocsp\_require\_stapling(3),
and
tls\_config\_verify(3).

The
**tls\_config\_error**()
function may be used to retrieve a string containing more information
about the most recent error relating to a configuration.

A TLS connection object is created by
tls\_client(3)
or
tls\_server(3)
and configured with
tls\_configure(3).

A client connection is initiated after configuration by calling
tls\_connect(3).
A server can accept a new client connection by calling
tls\_accept\_socket(3)
on an already established socket connection.

Two functions are provided for input and output,
tls\_read(3)
and
tls\_write(3).
Both automatically perform the
tls\_handshake(3)
when needed.

The properties of established TLS connections
can be inspected with the functions described in
tls\_conn\_version(3)
and
tls\_ocsp\_process\_response(3).

After use, a TLS connection should be closed with
tls\_close(3)
and then freed by calling
tls\_free(3).

When no more contexts are to be configured,
the configuration object should be freed by calling
**tls\_config\_free**().
It is safe to call
**tls\_config\_free**()
as soon as the final call to
**tls\_configure**()
has been made.
If
*config*
is
`NULL`,
no action occurs.

# RETURN VALUES

**tls\_init**()
returns 0 on success or -1 on error.

**tls\_config\_new**()
returns
`NULL`
on error or an out of memory condition.

**tls\_config\_error**()
returns
`NULL`
if no error occurred with
*config*
at all, or if memory allocation failed while trying to assemble the
string describing the most recent error related to
*config*.

# SEE ALSO

tls\_accept\_socket(3),
tls\_client(3),
tls\_config\_ocsp\_require\_stapling(3),
tls\_config\_set\_protocols(3),
tls\_config\_verify(3),
tls\_conn\_version(3),
tls\_connect(3),
tls\_load\_file(3),
tls\_ocsp\_process\_response(3),
tls\_read(3)

# HISTORY

The
**tls**
API first appeared in
OpenBSD 5.6
as a response to the unnecessary challenges other APIs present in
order to use them safely.

All functions were renamed from
**ressl\_\*&zwnj;**()
to
**tls\_\*&zwnj;**()
for
OpenBSD 5.7.

**tls\_config\_error**()
appeared in
OpenBSD 6.0.

# AUTHORS

Joel Sing &lt;[jsing@openbsd.org](mailto:jsing@openbsd.org)&gt;  
Ted Unangst &lt;[tedu@openbsd.org](mailto:tedu@openbsd.org)&gt;

Many others contributed to various parts of the library; see the
individual manual pages for more information.

# CAVEATS

The function
**tls\_config\_error**()
returns an internal pointer.
It must not be freed by the application, or a double free error
will occur.
The pointer will become invalid when the next error occurs with
*config*.
Consequently, if the application may need the message at a later
time, it has to copy the string before calling the next
**libtls**
function involving
*config*,
or a segmentation fault or read access to unintended data is the
likely result.

Debian - July 9, 2018
