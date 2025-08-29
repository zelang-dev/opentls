
# **openTLS** - libtls for OpenSSL

## DESCRIPTION

**openTLS** is a fork of [https://causal.agency/libretls/](https://causal.agency/libretls/), which is a port of **libtls** from LibreSSL to OpenSSL. [libtls](https://man.openbsd.org/tls_init.3) is "a new TLS library, designed to make it easier to write foolproof applications".

**libtls** provides an excellent new API, but LibreSSL can be difficult to install on systems which already use OpenSSL. **openTLS** aims to make the **libtls** API more easily and widely available.

## Releases

**openTLS** is based on [LibreSSL-portable](https://www.libressl.org/releases.html) sources. **openTLS** releases track LibreSSL releases, starting with version **3.9.2**.

## Compatibility

The **libtls** provided by **openTLS** is ABI-compatible with the **libtls** provided by the corresponding LibreSSL release.

The behavior of **openTLS** and LibreSSL differs in how the root certificates are loaded by default.
LibreSSL uses a hardcoded path to a CA bundle file, while **openTLS** uses the default CA locations of OpenSSL,
which may include a CA directory. To restore the behavior of LibreSSL, call `tls_config_set_ca_file(3)`
with the path returned by `tls_default_ca_cert_file(3)`. All other behaviors should be identical.

**openTLS** targets the OpenSSL 1.1.0 series. **openTLS** is compatible with OpenSSL 3.0.0 but hasn't been ported away from deprecated APIs.

## Platform Support

**openTLS** should work on the same platforms as [LibreSSL-portable](https://www.libressl.org/releases.html).

## License

**libtls** consists of all new code developed as part of OpenBSD under [OpenBSD's preferred license](https://www.openbsd.org/policy.html) of ISC. Some *compat* sources are under the 3-clause BSD license or the MIT license.

## INSTALLING

To install from a release tarball, run the following:

 ./configure
 make all
 make install

To install from a git checkout,
**autoconf**,
**automake**
and
**libtool**
are required.
Run the following before continuing
with the steps above:

 autoreconf -fi
