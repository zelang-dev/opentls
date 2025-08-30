TLS\_LOAD\_FILE(3) - Library Functions Manual

# NAME

**tls\_load\_file**,
**tls\_unload\_file**,
**tls\_config\_set\_ca\_file**,
**tls\_config\_set\_ca\_path**,
**tls\_config\_set\_ca\_mem**,
**tls\_config\_set\_cert\_file**,
**tls\_config\_set\_cert\_mem**,
**tls\_config\_set\_crl\_file**,
**tls\_config\_set\_crl\_mem**,
**tls\_config\_set\_key\_file**,
**tls\_config\_set\_key\_mem**,
**tls\_config\_set\_ocsp\_staple\_mem**,
**tls\_config\_set\_ocsp\_staple\_file**,
**tls\_config\_set\_keypair\_file**,
**tls\_config\_set\_keypair\_mem**,
**tls\_config\_set\_keypair\_ocsp\_file**,
**tls\_config\_set\_keypair\_ocsp\_mem**,
**tls\_config\_add\_keypair\_file**,
**tls\_config\_add\_keypair\_ocsp\_mem**,
**tls\_config\_add\_keypair\_ocsp\_file**,
**tls\_config\_add\_keypair\_mem**,
**tls\_config\_clear\_keys**,
**tls\_config\_set\_verify\_depth**,
**tls\_config\_verify\_client**,
**tls\_config\_verify\_client\_optional**,
**tls\_default\_ca\_cert\_file** - TLS certificate and key configuration

# SYNOPSIS

**#include &lt;tls.h>**

*uint8\_t \*&zwnj;*  
**tls\_load\_file**(*const char \*file*,
*size\_t \*len*,
*char \*password*);

*void*  
**tls\_unload\_file**(*uint8\_t \*buf*,
*size\_t len*);

*int*  
**tls\_config\_set\_ca\_file**(*struct tls\_config \*config*,
*const char \*ca\_file*);

*int*  
**tls\_config\_set\_ca\_path**(*struct tls\_config \*config*,
*const char \*ca\_path*);

*int*  
**tls\_config\_set\_ca\_mem**(*struct tls\_config \*config*,
*const uint8\_t \*cert*,
*size\_t len*);

*int*  
**tls\_config\_set\_cert\_file**(*struct tls\_config \*config*,
*const char \*cert\_file*);

*int*  
**tls\_config\_set\_cert\_mem**(*struct tls\_config \*config*,
*const uint8\_t \*cert*,
*size\_t len*);

*int*  
**tls\_config\_set\_crl\_file**(*struct tls\_config \*config*,
*const char \*crl\_file*);

*int*  
**tls\_config\_set\_crl\_mem**(*struct tls\_config \*config*,
*const uint8\_t \*crl*,
*size\_t len*);

*int*  
**tls\_config\_set\_key\_file**(*struct tls\_config \*config*,
*const char \*key\_file*);

*int*  
**tls\_config\_set\_key\_mem**(*struct tls\_config \*config*,
*const uint8\_t \*key*,
*size\_t len*);

*int*  
**tls\_config\_set\_ocsp\_staple\_mem**(*struct tls\_config \*config*,
*const uint8\_t \*staple*,
*size\_t len*);

*int*  
**tls\_config\_set\_ocsp\_staple\_file**(*struct tls\_config \*config*,
*const char \*staple\_file*);

*int*  
**tls\_config\_set\_keypair\_file**(*struct tls\_config \*config*,
*const char \*cert\_file*,
*const char \*key\_file*);

*int*  
**tls\_config\_set\_keypair\_mem**(*struct tls\_config \*config*,
*const uint8\_t \*cert*,
*size\_t cert\_len*,
*const uint8\_t \*key*,
*size\_t key\_len*);

*int*  
**tls\_config\_set\_keypair\_ocsp\_file**(*struct tls\_config \*config*,
*const char \*cert\_file*,
*const char \*key\_file*,
*const char \*staple\_file*);

*int*  
**tls\_config\_set\_keypair\_ocsp\_mem**(*struct tls\_config \*config*,
*const uint8\_t \*cert*,
*size\_t cert\_len*,
*const uint8\_t \*key*,
*size\_t key\_len*,
*const uint8\_t \*staple*,
*size\_t staple\_len*);

*int*  
**tls\_config\_add\_keypair\_file**(*struct tls\_config \*config*,
*const char \*cert\_file*,
*const char \*key\_file*);

*int*  
**tls\_config\_add\_keypair\_mem**(*struct tls\_config \*config*,
*const uint8\_t \*cert*,
*size\_t cert\_len*,
*const uint8\_t \*key*,
*size\_t key\_len*);

*int*  
**tls\_config\_add\_keypair\_ocsp\_file**(*struct tls\_config \*config*,
*const char \*cert\_file*,
*const char \*key\_file*,
*const char \*staple\_file*);

*int*  
**tls\_config\_add\_keypair\_ocsp\_mem**(*struct tls\_config \*config*,
*const uint8\_t \*cert*,
*size\_t cert\_len*,
*const uint8\_t \*key*,
*size\_t key\_len*,
*const uint8\_t \*staple*,
*size\_t staple\_len*);

*void*  
**tls\_config\_clear\_keys**(*struct tls\_config \*config*);

*int*  
**tls\_config\_set\_verify\_depth**(*struct tls\_config \*config*,
*int verify\_depth*);

*void*  
**tls\_config\_verify\_client**(*struct tls\_config \*config*);

*void*  
**tls\_config\_verify\_client\_optional**(*struct tls\_config \*config*);

*const char \*&zwnj;*  
**tls\_default\_ca\_cert\_file**(*void*);

# DESCRIPTION

**tls\_load\_file**()
loads a certificate or key from disk into memory to be used with
**tls\_config\_set\_ca\_mem**(),
**tls\_config\_set\_cert\_mem**(),
**tls\_config\_set\_crl\_mem**()
or
**tls\_config\_set\_key\_mem**().
A private key will be decrypted if the optional
*password*
argument is specified.

**tls\_unload\_file**()
unloads the memory that was returned from an earlier
**tls\_load\_file**()
call, ensuring that the memory contents is discarded.

**tls\_default\_ca\_cert\_file**()
returns the path of the file that contains the default root certificates.

**tls\_config\_set\_ca\_file**()
loads a file containing the root certificates.

**tls\_config\_set\_ca\_path**()
sets the path (directory) which should be searched for root
certificates.

**tls\_config\_set\_ca\_mem**()
sets the root certificates directly from memory.

**tls\_config\_set\_cert\_file**()
loads a file containing the public certificate.

**tls\_config\_set\_cert\_mem**()
sets the public certificate directly from memory.

**tls\_config\_set\_crl\_file**()
loads a file containing the Certificate Revocation List (CRL).

**tls\_config\_set\_crl\_mem**()
sets the CRL directly from memory.

**tls\_config\_set\_key\_file**()
loads a file containing the private key.

**tls\_config\_set\_key\_mem**()
directly sets the private key from memory.

**tls\_config\_set\_ocsp\_staple\_file**()
loads a file containing a DER-encoded OCSP response to be stapled
during the TLS handshake.

**tls\_config\_set\_ocsp\_staple\_mem**()
sets a DER-encoded OCSP response to be stapled during the TLS handshake from
memory.

**tls\_config\_set\_keypair\_file**()
loads two files from which the public certificate and private key will be read.

**tls\_config\_set\_keypair\_mem**()
directly sets the public certificate and private key from memory.

**tls\_config\_set\_keypair\_ocsp\_file**()
loads three files containing the public certificate, private key,
and DER-encoded OCSP staple.

**tls\_config\_set\_keypair\_ocsp\_mem**()
directly sets the public certificate, private key, and DER-encoded OCSP staple
from memory.

**tls\_config\_add\_keypair\_file**()
adds an additional public certificate and private key from the specified files,
used as an alternative certificate for Server Name Indication (server only).

**tls\_config\_add\_keypair\_mem**()
adds an additional public certificate and private key from memory, used as an
alternative certificate for Server Name Indication (server only).

**tls\_config\_add\_keypair\_ocsp\_file**()
adds an additional public certificate, private key, and DER-encoded OCSP staple
from the specified files, used as an alternative certificate for Server Name
Indication (server only).

**tls\_config\_add\_keypair\_ocsp\_mem**()
adds an additional public certificate, private key, and DER-encoded OCSP staple
from memory, used as an alternative certificate for Server Name Indication
(server only).

**tls\_config\_clear\_keys**()
clears any secret keys from memory.

**tls\_config\_set\_verify\_depth**()
limits the number of intermediate certificates that will be followed during
certificate validation.

**tls\_config\_verify\_client**()
enables client certificate verification, requiring the client to send
a certificate (server only).

**tls\_config\_verify\_client\_optional**()
enables client certificate verification, without requiring the client
to send a certificate (server only).

# RETURN VALUES

**tls\_load\_file**()
returns
`NULL`
on error or an out of memory condition.

The other functions return 0 on success or -1 on error.

# SEE ALSO

tls\_config\_ocsp\_require\_stapling(3),
tls\_config\_set\_protocols(3),
tls\_config\_set\_session\_id(3),
tls\_configure(3),
tls\_init(3)

# HISTORY

**tls\_config\_set\_ca\_file**(),
**tls\_config\_set\_ca\_path**(),
**tls\_config\_set\_cert\_file**(),
**tls\_config\_set\_cert\_mem**(),
**tls\_config\_set\_key\_file**(),
**tls\_config\_set\_key\_mem**(),
and
**tls\_config\_set\_verify\_depth**()
appeared in
OpenBSD 5.6
and got their final names in
OpenBSD 5.7.

**tls\_load\_file**(),
**tls\_config\_set\_ca\_mem**(),
and
**tls\_config\_clear\_keys**()
appeared in
OpenBSD 5.7.

**tls\_config\_verify\_client**()
and
**tls\_config\_verify\_client\_optional**()
appeared in
OpenBSD 5.9.

**tls\_config\_set\_keypair\_file**()
and
**tls\_config\_set\_keypair\_mem**()
appeared in
OpenBSD 6.0,
and
**tls\_config\_add\_keypair\_file**()
and
**tls\_config\_add\_keypair\_mem**()
in
OpenBSD 6.1.

**tls\_config\_set\_crl\_file**()
and
**tls\_config\_set\_crl\_mem**()
appeared in
OpenBSD 6.2.

# AUTHORS

Joel Sing &lt;[jsing@openbsd.org](mailto:jsing@openbsd.org)&gt;
with contributions from  
Ted Unangst &lt;[tedu@openbsd.org](mailto:tedu@openbsd.org)&gt;
and  
Bob Beck &lt;[beck@openbsd.org](mailto:beck@openbsd.org)&gt;.

**tls\_load\_file**()
and
**tls\_config\_set\_ca\_mem**()
were written by  
Reyk Floeter &lt;[reyk@openbsd.org](mailto:reyk@openbsd.org)&gt;.

Debian - January 1, 2022
