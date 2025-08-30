TLS\_CONFIG\_SET\_PROTOCOLS(3) - Library Functions Manual

# NAME

**tls\_config\_set\_protocols**,
**tls\_config\_parse\_protocols**,
**tls\_config\_set\_alpn**,
**tls\_config\_set\_ciphers**,
**tls\_config\_set\_dheparams**,
**tls\_config\_set\_ecdhecurves**,
**tls\_config\_prefer\_ciphers\_client**,
**tls\_config\_prefer\_ciphers\_server** - TLS protocol and cipher selection

# SYNOPSIS

**#include &lt;tls.h>**

*int*  
**tls\_config\_set\_protocols**(*struct tls\_config \*config*,
*uint32\_t protocols*);

*int*  
**tls\_config\_parse\_protocols**(*uint32\_t \*protocols*,
*const char \*protostr*);

*int*  
**tls\_config\_set\_alpn**(*struct tls\_config \*config*,
*const char \*alpn*);

*int*  
**tls\_config\_set\_ciphers**(*struct tls\_config \*config*,
*const char \*ciphers*);

*int*  
**tls\_config\_set\_dheparams**(*struct tls\_config \*config*,
*const char \*params*);

*int*  
**tls\_config\_set\_ecdhecurves**(*struct tls\_config \*config*,
*const char \*curves*);

*void*  
**tls\_config\_prefer\_ciphers\_client**(*struct tls\_config \*config*);

*void*  
**tls\_config\_prefer\_ciphers\_server**(*struct tls\_config \*config*);

# DESCRIPTION

These functions modify a configuration by setting parameters.
The configuration options apply to both clients and servers, unless noted
otherwise.

**tls\_config\_set\_protocols**()
specifies which versions of the TLS protocol may be used.
Possible values are the bitwise OR of:

`TLS_PROTOCOL_TLSv1_2`  
`TLS_PROTOCOL_TLSv1_3`

Additionally, the values
`TLS_PROTOCOL_TLSv1`
(TLSv1.2, TLSv1.3),
`TLS_PROTOCOLS_ALL`
(all supported protocols) and
`TLS_PROTOCOLS_DEFAULT`
(TLSv1.2 and TLSv1.3) may be used.

The
**tls\_config\_parse\_protocols**()
utility function parses a protocol string and returns the corresponding
value via the
*protocols*
argument.
This value can then be passed to the
**tls\_config\_set\_protocols**()
function.
The protocol string is a comma or colon separated list of keywords.
Valid keywords are:

`tlsv1.2`

`tlsv1.3`

`all`

> (all supported protocols)

`default`

> (an alias for `secure`)

`legacy`

> (an alias for `all`)

`secure`

> (currently TLSv1.2 and TLSv1.3)

If a value has a negative prefix (in the form of a leading exclamation mark)
then it is removed from the list of available protocols, rather than being
added to it.

**tls\_config\_set\_alpn**()
sets the ALPN protocols that are supported.
The alpn string is a comma separated list of protocols, in order of preference.

**tls\_config\_set\_ciphers**()
sets the list of ciphers that may be used.
Lists of ciphers are specified by name, and the
permitted names are:

`secure` (or alias `default`)  
`compat`  
`legacy`  
`insecure` (or alias `all`)

Alternatively, libssl cipher strings can be specified.
See the CIPHERS section of
openssl(1)
for further information.

**tls\_config\_set\_dheparams**()
specifies the parameters that will be used during Diffie-Hellman Ephemeral
(DHE) key exchange.
Possible values are:

`none`  
`auto`  
`legacy`

In
`auto`
mode, the key size for the ephemeral key is automatically selected
based on the size of the private key being used for signing.
In
`legacy`
mode, 1024 bit ephemeral keys are used.
The default value is
`none`,
which disables DHE key exchange.

**tls\_config\_set\_ecdhecurves**()
specifies the names of the elliptic curves that may be used during Elliptic
Curve Diffie-Hellman Ephemeral (ECDHE) key exchange.
This is a comma separated list, given in order of preference.
The special value of "default" will use the default curves (currently X25519,
P-256 and P-384).
This function replaces
**tls\_config\_set\_ecdhecurve**(),
which is deprecated.

**tls\_config\_prefer\_ciphers\_client**()
prefers ciphers in the client's cipher list when selecting a cipher suite
(server only).
This is considered to be less secure than preferring the server's list.

**tls\_config\_prefer\_ciphers\_server**()
prefers ciphers in the server's cipher list when selecting a cipher suite
(server only).
This is considered to be more secure than preferring the client's list and is
the default.

# RETURN VALUES

These functions return 0 on success or -1 on error.

# SEE ALSO

tls\_config\_ocsp\_require\_stapling(3),
tls\_config\_set\_session\_id(3),
tls\_config\_verify(3),
tls\_init(3),
tls\_load\_file(3)

# HISTORY

**tls\_config\_set\_ciphers**()
appeared in
OpenBSD 5.6
and got its final name in
OpenBSD 5.7.

**tls\_config\_set\_protocols**(),
**tls\_config\_parse\_protocols**(),
**tls\_config\_set\_dheparams**(),
and
**tls\_config\_set\_ecdhecurve**()
appeared in
OpenBSD 5.7,
**tls\_config\_prefer\_ciphers\_client**()
and
**tls\_config\_prefer\_ciphers\_server**()
in
OpenBSD 5.9,
and
**tls\_config\_set\_alpn**()
in
OpenBSD 6.1.

# AUTHORS

Joel Sing &lt;[jsing@openbsd.org](mailto:jsing@openbsd.org)&gt;
with contributions from  
Ted Unangst &lt;[tedu@openbsd.org](mailto:tedu@openbsd.org)&gt;
(**tls\_config\_set\_ciphers**())
and  
Reyk Floeter &lt;[reyk@openbsd.org](mailto:reyk@openbsd.org)&gt;
(**tls\_config\_set\_ecdhecurve**())

Debian - July 2, 2023
