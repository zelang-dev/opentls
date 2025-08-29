include $(top_srcdir)/Makefile.am.common

SUBDIRS = include man
ACLOCAL_AMFLAGS = -I m4

pkgconfigdir = $(libdir)/pkgconfig
pkgconfig_DATA = libtls.pc

lib_LTLIBRARIES = libtls.la

EXTRA_DIST = VERSION
EXTRA_DIST += LIBTLS_VERSION
EXTRA_DIST += tls.sym
EXTRA_DIST += README.7
EXTRA_DIST += scripts
EXTRA_DIST += empty.c

CLEANFILES = libtls_la_objects.mk

EXTRA_libtls_la_DEPENDENCIES = libtls_la_objects.mk

libtls_la_objects.mk: Makefile
	@echo "libtls_la_objects= $(libtls_la_OBJECTS)" \
	  | sed -e 's/ *$$//' -e 's/  */ $$\(abs_top_builddir\)\/tls\//g' \
	  > libtls_la_objects.mk

libtls_la_LDFLAGS = -version-info @LIBTLS_VERSION@ -no-undefined -export-symbols $(top_srcdir)/tls.sym
libtls_la_LDFLAGS += $(OPENSSL_LDFLAGS)
libtls_la_LIBADD = $(OPENSSL_LIBS)
libtls_la_LIBADD += $(PLATFORM_LDADD)

libtls_la_CPPFLAGS = $(AM_CPPFLAGS)
libtls_la_CPPFLAGS += $(OPENSSL_INCLUDES)

libtls_la_SOURCES = tls.c
libtls_la_SOURCES += tls_client.c
libtls_la_SOURCES += tls_bio_cb.c
libtls_la_SOURCES += tls_config.c
libtls_la_SOURCES += tls_conninfo.c
libtls_la_SOURCES += tls_keypair.c
libtls_la_SOURCES += tls_server.c
libtls_la_SOURCES += tls_signer.c
libtls_la_SOURCES += tls_ocsp.c
libtls_la_SOURCES += tls_peer.c
libtls_la_SOURCES += tls_util.c
libtls_la_SOURCES += tls_verify.c
noinst_HEADERS = tls_internal.h

if HOST_WIN
libtls_la_SOURCES += compat/ftruncate.c
libtls_la_SOURCES += compat/pread.c
libtls_la_SOURCES += compat/pwrite.c
endif

libtls_la_LIBADD += libcompat.la
if !HAVE_EXPLICIT_BZERO
libtls_la_LIBADD += libcompatnoopt.la
endif

noinst_LTLIBRARIES = libcompat.la

# compatibility functions that need to be built without optimizations
if !HAVE_EXPLICIT_BZERO
noinst_LTLIBRARIES += libcompatnoopt.la

libcompatnoopt_la_CFLAGS = -O0
libcompatnoopt_la_SOURCES =

if HOST_WIN
libcompatnoopt_la_SOURCES += compat/explicit_bzero_win.c
else
libcompatnoopt_la_SOURCES += compat/explicit_bzero.c
endif
endif

# other compatibility functions
libcompat_la_SOURCES =
libcompat_la_LIBADD = $(PLATFORM_LDADD)
libcompat_la_CPPFLAGS = $(AM_CPPFLAGS)
libcompat_la_CPPFLAGS += $(OPENSSL_INCLUDES)

if !HAVE_STRLCPY
libcompat_la_SOURCES += compat/strlcpy.c
endif

if !HAVE_STRSEP
libcompat_la_SOURCES += compat/strsep.c
endif

if !HAVE_ASPRINTF
libcompat_la_SOURCES += compat/bsd-asprintf.c
endif

if !HAVE_FREEZERO
libcompat_la_SOURCES += compat/freezero.c
endif

if !HAVE_GETPAGESIZE
libcompat_la_SOURCES += compat/getpagesize.c
endif

if !HAVE_GETPROGNAME
if HOST_LINUX
libcompat_la_SOURCES += compat/getprogname_linux.c
else
if HOST_WIN
libcompat_la_SOURCES += compat/getprogname_windows.c
else
libcompat_la_SOURCES += compat/getprogname_unimpl.c
endif
endif
endif

if !HAVE_TIMEGM
libcompat_la_SOURCES += compat/timegm.c
endif

if !HAVE_REALLOCARRAY
libcompat_la_SOURCES += compat/reallocarray.c
endif

if !HAVE_TIMINGSAFE_MEMCMP
libcompat_la_SOURCES += compat/timingsafe_memcmp.c
endif

if HOST_WIN
libcompat_la_SOURCES += compat/posix_win.c
endif

if !HAVE_ARC4RANDOM_BUF
libcompat_la_SOURCES += compat/arc4random.c
libcompat_la_SOURCES += compat/arc4random_uniform.c

if !HAVE_GETENTROPY
if HOST_AIX
libcompat_la_SOURCES += compat/getentropy_aix.c
endif
if HOST_FREEBSD
libcompat_la_SOURCES += compat/getentropy_freebsd.c
endif
if HOST_HPUX
libcompat_la_SOURCES += compat/getentropy_hpux.c
endif
if HOST_LINUX
libcompat_la_SOURCES += compat/getentropy_linux.c
endif
if HOST_NETBSD
libcompat_la_SOURCES += compat/getentropy_netbsd.c
endif
if HOST_DARWIN
libcompat_la_SOURCES += compat/getentropy_osx.c
endif
if HOST_SOLARIS
libcompat_la_SOURCES += compat/getentropy_solaris.c
endif
if HOST_WIN
libcompat_la_SOURCES += compat/getentropy_win.c
endif
endif

endif

noinst_HEADERS += compat/arc4random.h
noinst_HEADERS += compat/arc4random_aix.h
noinst_HEADERS += compat/arc4random_freebsd.h
noinst_HEADERS += compat/arc4random_hpux.h
noinst_HEADERS += compat/arc4random_linux.h
noinst_HEADERS += compat/arc4random_netbsd.h
noinst_HEADERS += compat/arc4random_osx.h
noinst_HEADERS += compat/arc4random_solaris.h
noinst_HEADERS += compat/arc4random_win.h
noinst_HEADERS += compat/chacha_private.h
