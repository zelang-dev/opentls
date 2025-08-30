TLS\_CLIENT(3) - Library Functions Manual

# NAME

**tls\_client**,
**tls\_server**,
**tls\_configure**,
**tls\_reset**,
**tls\_free** - configure a TLS connection

# SYNOPSIS

**#include &lt;tls.h>**

*struct tls \*&zwnj;*  
**tls\_client**(*void*);

*struct tls \*&zwnj;*  
**tls\_server**(*void*);

*int*  
**tls\_configure**(*struct tls \*ctx*,
*struct tls\_config \*config*);

*void*  
**tls\_free**(*struct tls \*ctx*);

*void*  
**tls\_reset**(*struct tls \*ctx*);

# DESCRIPTION

A TLS connection is represented as a
*struct tls*
object called a
"context".
A new context is created by either the
**tls\_client**()
or
**tls\_server**()
functions.
**tls\_client**()
is used in TLS client programs,
**tls\_server**()
in TLS server programs.

The context can then be configured with the function
**tls\_configure**().
The same
*tls\_config*
object can be used to configure multiple contexts.

After configuration,
tls\_connect(3)
can be called on objects created with
**tls\_client**(),
and
tls\_accept\_socket(3)
on objects created with
**tls\_server**().

After use, a TLS context should be closed with
tls\_close(3),
and then freed by calling
**tls\_free**().
If
**tls\_free**()
is called with an argument of
`NULL`,
no action occurs.

A TLS context can be reset by calling
**tls\_reset**(),
allowing for it to be reused.
This is essentially equivalent to calling
**tls\_free**(),
followed by a call to the same function that was used to originally allocate
the TLS context.

# RETURN VALUES

**tls\_client**()
and
**tls\_server**()
return
`NULL`
on error or an out of memory condition.

**tls\_configure**()
returns 0 on success or -1 on error.

# SEE ALSO

tls\_accept\_socket(3),
tls\_config\_new(3),
tls\_connect(3),
tls\_init(3)

# HISTORY

These functions appeared in
OpenBSD 5.6
and got their final names in
OpenBSD 5.7.

# AUTHORS

Joel Sing &lt;[jsing@openbsd.org](mailto:jsing@openbsd.org)&gt;

Debian - August 12, 2017
