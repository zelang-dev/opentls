TLS\_CONN\_VERSION(3) - Library Functions Manual

# NAME

**tls\_conn\_version**,
**tls\_conn\_cipher**,
**tls\_conn\_cipher\_strength**,
**tls\_conn\_alpn\_selected**,
**tls\_conn\_servername**,
**tls\_conn\_session\_resumed**,
**tls\_peer\_cert\_provided**,
**tls\_peer\_cert\_contains\_name**,
**tls\_peer\_cert\_chain\_pem**,
**tls\_peer\_cert\_issuer**,
**tls\_peer\_cert\_subject**,
**tls\_peer\_cert\_common\_name**,
**tls\_peer\_cert\_hash**,
**tls\_peer\_cert\_notbefore**,
**tls\_peer\_cert\_notafter** - inspect an established TLS connection

# SYNOPSIS

**#include &lt;tls.h>**

*const char \*&zwnj;*  
**tls\_conn\_version**(*struct tls \*ctx*);

*const char \*&zwnj;*  
**tls\_conn\_cipher**(*struct tls \*ctx*);

*int*  
**tls\_conn\_cipher\_strength**(*struct tls \*ctx*);

*const char \*&zwnj;*  
**tls\_conn\_alpn\_selected**(*struct tls \*ctx*);

*const char \*&zwnj;*  
**tls\_conn\_servername**(*struct tls \*ctx*);

*int*  
**tls\_conn\_session\_resumed**(*struct tls \*ctx*);

*int*  
**tls\_peer\_cert\_provided**(*struct tls \*ctx*);

*int*  
**tls\_peer\_cert\_contains\_name**(*struct tls \*ctx*,
*const char \*name*);

*const uint8\_t \*&zwnj;*  
**tls\_peer\_cert\_chain\_pem**(*struct tls \*ctx*,
*size\_t \*size*);

*const char \*&zwnj;*  
**tls\_peer\_cert\_issuer**(*struct tls \*ctx*);

*const char \*&zwnj;*  
**tls\_peer\_cert\_subject**(*struct tls \*ctx*);

*const char \*&zwnj;*  
**tls\_peer\_cert\_common\_name**(*struct tls \*ctx*);

*const char \*&zwnj;*  
**tls\_peer\_cert\_hash**(*struct tls \*ctx*);

*time\_t*  
**tls\_peer\_cert\_notbefore**(*struct tls \*ctx*);

*time\_t*  
**tls\_peer\_cert\_notafter**(*struct tls \*ctx*);

# DESCRIPTION

These functions return information about a TLS connection and will only
succeed after the handshake is complete (the connection information applies
to both clients and servers, unless noted otherwise):

**tls\_conn\_version**()
returns a string corresponding to a TLS version negotiated with the peer
connected to
*ctx*.

**tls\_conn\_cipher**()
returns a string corresponding to the cipher suite negotiated with the peer
connected to
*ctx*.

**tls\_conn\_cipher\_strength**()
returns the strength in bits for the symmetric cipher that is being
used with the peer connected to
*ctx*.

**tls\_conn\_alpn\_selected**()
returns a string that specifies the ALPN protocol selected for use with the peer
connected to
*ctx*.
If no protocol was selected then NULL is returned.

**tls\_conn\_servername**()
returns a string corresponding to the servername that the client connected to
*ctx*
requested by sending a TLS Server Name Indication extension (server only).

**tls\_conn\_session\_resumed**()
indicates whether a TLS session has been resumed during the handshake with
the server connected to
*ctx*
(client only).

**tls\_peer\_cert\_provided**()
checks if the peer of
*ctx*
has provided a certificate.

**tls\_peer\_cert\_contains\_name**()
checks if the peer of a TLS
*ctx*
has provided a certificate that contains a
SAN or CN that matches
*name*.

**tls\_peer\_cert\_chain\_pem**()
returns a pointer to memory containing a PEM-encoded certificate chain for the
peer certificate from
*ctx*.

**tls\_peer\_cert\_subject**()
returns a string
corresponding to the subject of the peer certificate from
*ctx*.

**tls\_peer\_cert\_issuer**()
returns a string
corresponding to the issuer of the peer certificate from
*ctx*.
**tls\_peer\_cert\_common\_name**()
returns a string
corresponding to the common name of the peer certificate from
*ctx*
or the empty string if no common name is present.

**tls\_peer\_cert\_hash**()
returns a string
corresponding to a hash of the raw peer certificate from
*ctx*
prefixed by a hash name followed by a colon.
The hash currently used is SHA256, though this
could change in the future.
The hash string for a certificate in file
*mycert.crt*
can be generated using the commands:

	h=$(openssl x509 -outform der -in mycert.crt | sha256)
	printf "SHA256:${h}\n"

**tls\_peer\_cert\_notbefore**()
returns the time corresponding to the start of the validity period of
the peer certificate from
*ctx*.

**tls\_peer\_cert\_notafter**()
returns the time corresponding to the end of the validity period of
the peer certificate from
*ctx*.

# RETURN VALUES

The
**tls\_conn\_session\_resumed**()
function returns 1 if a TLS session was resumed or 0 if it was not.

The
**tls\_peer\_cert\_provided**()
and
**tls\_peer\_cert\_contains\_name**()
functions return 1 if the check succeeds or 0 if it does not.

**tls\_peer\_cert\_notbefore**()
and
**tls\_peer\_cert\_notafter**()
return a time in epoch-seconds on success or -1 on error.

The functions that return a pointer return
`NULL`
on error or an out of memory condition.

# SEE ALSO

tls\_configure(3),
tls\_handshake(3),
tls\_init(3),
tls\_ocsp\_process\_response(3)

# HISTORY

**tls\_conn\_version**(),
**tls\_conn\_cipher**(),
**tls\_peer\_cert\_provided**(),
**tls\_peer\_cert\_contains\_name**(),
**tls\_peer\_cert\_issuer**(),
**tls\_peer\_cert\_subject**(),
**tls\_peer\_cert\_hash**(),
**tls\_peer\_cert\_notbefore**(),
and
**tls\_peer\_cert\_notafter**()
appeared in
OpenBSD 5.9.

**tls\_conn\_servername**()
and
**tls\_conn\_alpn\_selected**()
appeared in
OpenBSD 6.1.

**tls\_conn\_session\_resumed**()
appeared in
OpenBSD 6.3.

**tls\_conn\_cipher\_strength**()
appeared in
OpenBSD 6.7.
**tls\_peer\_cert\_common\_name**()
appeared in
OpenBSD 7.7.

# AUTHORS

Bob Beck &lt;[beck@openbsd.org](mailto:beck@openbsd.org)&gt;  
Joel Sing &lt;[jsing@openbsd.org](mailto:jsing@openbsd.org)&gt;

Debian - December 10, 2024
