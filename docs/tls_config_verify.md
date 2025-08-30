TLS\_CONFIG\_VERIFY(3) - Library Functions Manual

# NAME

**tls\_config\_verify**,
**tls\_config\_insecure\_noverifycert**,
**tls\_config\_insecure\_noverifyname**,
**tls\_config\_insecure\_noverifytime** - insecure TLS configuration

# SYNOPSIS

**#include &lt;tls.h>**

*void*  
**tls\_config\_verify**(*struct tls\_config \*config*);

*void*  
**tls\_config\_insecure\_noverifycert**(*struct tls\_config \*config*);

*void*  
**tls\_config\_insecure\_noverifyname**(*struct tls\_config \*config*);

*void*  
**tls\_config\_insecure\_noverifytime**(*struct tls\_config \*config*);

# DESCRIPTION

These functions disable parts of the normal certificate verification
process, resulting in insecure configurations.
Be very careful when using them.

**tls\_config\_insecure\_noverifycert**()
disables certificate verification and OCSP validation.

**tls\_config\_insecure\_noverifyname**()
disables server name verification (client only).

**tls\_config\_insecure\_noverifytime**()
disables validity checking of certificates and OCSP validation.

**tls\_config\_verify**()
reenables server name and certificate verification.

# SEE ALSO

tls\_client(3),
tls\_config\_ocsp\_require\_stapling(3),
tls\_config\_set\_protocols(3),
tls\_conn\_version(3),
tls\_connect(3),
tls\_handshake(3),
tls\_init(3)

# HISTORY

**tls\_config\_verify**()
appeared in
OpenBSD 5.6
and got its final name in
OpenBSD 5.7.

**tls\_config\_insecure\_noverifycert**()
and
**tls\_config\_insecure\_noverifyname**()
appeared in
OpenBSD 5.7
and
**tls\_config\_insecure\_noverifytime**
in
OpenBSD 5.9.

# AUTHORS

Joel Sing &lt;[jsing@openbsd.org](mailto:jsing@openbsd.org)&gt;  
Ted Unangst &lt;[tedu@openbsd.org](mailto:tedu@openbsd.org)&gt;

Debian - March 2, 2017
