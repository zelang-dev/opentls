TLS\_CONFIG\_SET\_SESSION\_ID(3) - Library Functions Manual

# NAME

**tls\_config\_set\_session\_fd**,
**tls\_config\_set\_session\_id**,
**tls\_config\_set\_session\_lifetime**,
**tls\_config\_add\_ticket\_key** - configure resuming of TLS handshakes

# SYNOPSIS

**#include &lt;tls.h>**

*int*  
**tls\_config\_set\_session\_fd**(*struct tls\_config \*config*,
*int session\_fd*);

*int*  
**tls\_config\_set\_session\_id**(*struct tls\_config \*config*,
*const unsigned char \*session\_id*,
*size\_t len*);

*int*  
**tls\_config\_set\_session\_lifetime**(*struct tls\_config \*config*,
*int lifetime*);

*int*  
**tls\_config\_add\_ticket\_key**(*struct tls\_config \*config*,
*uint32\_t keyrev*,
*unsigned char \*key*,
*size\_t keylen*);

# DESCRIPTION

**tls\_config\_set\_session\_fd**()
sets a file descriptor to be used to manage data for TLS sessions (client only).
The given file descriptor must be a regular file and be owned by the current
user, with permissions being restricted to only allow the owner to read and
write the file (0600).
If the file has a non-zero length, the client will attempt to read session
data from this file and resume the previous TLS session with the server.
Upon a successful handshake the file will be updated with current session
data, if available.
The caller is responsible for closing this file descriptor, after all TLS
contexts that have been configured to use it have been freed via
**tls\_free**().

**tls\_config\_set\_session\_id**()
sets the session identifier that will be used by the TLS server when
sessions are enabled (server only).
By default a random value is used.

**tls\_config\_set\_session\_lifetime**()
sets the lifetime to be used for TLS sessions (server only).
Session support is disabled if a lifetime of zero is specified, which is the
default.

**tls\_config\_add\_ticket\_key**()
adds a key used for the encryption and authentication of TLS tickets
(server only).
By default keys are generated and rotated automatically based on their lifetime.
This function should only be used to synchronise ticket encryption key across
multiple processes.
Re-adding a known key will result in an error, unless it is the most recently
added key.

# RETURN VALUES

These functions return 0 on success or -1 on error.

# SEE ALSO

tls\_accept\_socket(3),
tls\_config\_set\_protocols(3),
tls\_init(3),
tls\_load\_file(3),
tls\_server(3)

# HISTORY

**tls\_config\_set\_session\_id**(),
**tls\_config\_set\_session\_lifetime**()
and
**tls\_config\_add\_ticket\_key**()
appeared in
OpenBSD 6.1.

**tls\_config\_set\_session\_fd**()
appeared in
OpenBSD 6.3.

# AUTHORS

Claudio Jeker &lt;[claudio@openbsd.org](mailto:claudio@openbsd.org)&gt;  
Joel Sing &lt;[jsing@openbsd.org](mailto:jsing@openbsd.org)&gt;

Debian - February 10, 2018
