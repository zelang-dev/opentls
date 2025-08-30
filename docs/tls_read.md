TLS\_READ(3) - Library Functions Manual

# NAME

**tls\_read**,
**tls\_write**,
**tls\_handshake**,
**tls\_error**,
**tls\_close** - use a TLS connection

# SYNOPSIS

**#include &lt;tls.h>**

*ssize\_t*  
**tls\_read**(*struct tls \*ctx*,
*void \*buf*,
*size\_t buflen*);

*ssize\_t*  
**tls\_write**(*struct tls \*ctx*,
*const void \*buf*,
*size\_t buflen*);

*int*  
**tls\_handshake**(*struct tls \*ctx*);

*const char \*&zwnj;*  
**tls\_error**(*struct tls \*ctx*);

*int*  
**tls\_close**(*struct tls \*ctx*);

# DESCRIPTION

**tls\_read**()
reads
*buflen*
bytes of data from the socket into
*buf*.
It returns the amount of data read.

**tls\_write**()
writes
*buflen*
bytes of data from
*buf*
to the socket.
It returns the amount of data written.

**tls\_handshake**()
explicitly performs the TLS handshake.
It is only necessary to call this function if you need to guarantee that the
handshake has completed, as both
**tls\_read**()
and
**tls\_write**()
automatically perform the TLS handshake when necessary.

The
**tls\_error**()
function may be used to retrieve a string containing more information
about the most recent error relating to a context.

**tls\_close**()
closes a connection after use.
Only the TLS layer will be shut down and the caller is responsible for closing
the file descriptors, unless the connection was established using
tls\_connect(3)
or
tls\_connect\_servername(3).
After closing the connection,
*ctx*
can be passed to
tls\_free(3).

# RETURN VALUES

**tls\_read**()
and
**tls\_write**()
return a size on success or -1 on error.

**tls\_handshake**()
and
**tls\_close**()
return 0 on success or -1 on error.

The
**tls\_read**(),
**tls\_write**(),
**tls\_handshake**(),
and
**tls\_close**()
functions also have two special return values:

`TLS_WANT_POLLIN`

> The underlying read file descriptor needs to be readable in order to continue.

`TLS_WANT_POLLOUT`

> The underlying write file descriptor needs to be writeable in order to continue.

In the case of blocking file descriptors, the same function call should be
repeated immediately.
In the case of non-blocking file descriptors, the same function call should be
repeated when the required condition has been met.

Callers of these functions cannot rely on the value of the global
*errno*.
To prevent mishandling of error conditions,
**tls\_read**(),
**tls\_write**(),
**tls\_handshake**(),
and
**tls\_close**()
all explicitly clear
*errno*.

**tls\_error**()
returns
`NULL`
if no error occurred with
*ctx*
during or since the last call to
**tls\_handshake**(),
**tls\_read**(),
**tls\_write**(),
**tls\_close**(),
or
tls\_reset(3)
involving
*ctx*,
or if memory allocation failed while trying to assemble the string
describing the most recent error related to
*ctx*.

# EXAMPLES

The following example demonstrates how to handle TLS writes on a blocking
file descriptor:

	...
	while (len > 0) {
		ssize_t ret;
	
		ret = tls_write(ctx, buf, len);
		if (ret == TLS_WANT_POLLIN || ret == TLS_WANT_POLLOUT)
			continue;
		if (ret == -1)
			errx(1, "tls_write: %s", tls_error(ctx));
		buf += ret;
		len -= ret;
	}
	...

The following example demonstrates how to handle TLS writes on a
non-blocking file descriptor using
poll(2):

	...
	pfd[0].fd = fd;
	pfd[0].events = POLLIN|POLLOUT;
	while (len > 0) {
		nready = poll(pfd, 1, 0);
		if (nready == -1)
			err(1, "poll");
		if ((pfd[0].revents & (POLLERR|POLLNVAL)))
			errx(1, "bad fd %d", pfd[0].fd);
		if ((pfd[0].revents & (pfd[0].events|POLLHUP))) {
			ssize_t ret;
	
			ret = tls_write(ctx, buf, len);
			if (ret == TLS_WANT_POLLIN)
				pfd[0].events = POLLIN;
			else if (ret == TLS_WANT_POLLOUT)
				pfd[0].events = POLLOUT;
			else if (ret == -1)
				errx(1, "tls_write: %s", tls_error(ctx));
			else {
				buf += ret;
				len -= ret;
			}
		}
	}
	...

# SEE ALSO

tls\_accept\_socket(3),
tls\_configure(3),
tls\_conn\_version(3),
tls\_connect(3),
tls\_init(3),
tls\_ocsp\_process\_response(3)

# HISTORY

**tls\_read**(),
**tls\_write**(),
**tls\_error**(),
and
**tls\_close**()
appeared in
OpenBSD 5.6
and got their final names in
OpenBSD 5.7.

**tls\_handshake**()
appeared in
OpenBSD 5.9.

# AUTHORS

Joel Sing &lt;[jsing@openbsd.org](mailto:jsing@openbsd.org)&gt;
with contributions from  
Bob Beck &lt;[beck@openbsd.org](mailto:beck@openbsd.org)&gt;

# CAVEATS

The function
**tls\_error**()
returns an internal pointer.
It must not be freed by the application, or a double free error
will occur.
The pointer will become invalid when the next error occurs with
*ctx*.
Consequently, if the application may need the message at a later
time, it has to copy the string before calling the next
**libtls**
function involving
*ctx*,
or a segmentation fault or read access to unintended data is the
likely result.

Debian - September 18, 2023
