# Copyright (c) 2014-2015 Brent Cook
#
# Permission to use, copy, modify, and distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

AC_INIT([libretls], m4_esyscmd(tr -d '\n' < VERSION))
AC_SUBST([LIBTLS_VERSION], m4_esyscmd([tr -d '\n' < LIBTLS_VERSION]))

AC_CANONICAL_HOST
AM_INIT_AUTOMAKE([subdir-objects foreign])
AC_CONFIG_MACRO_DIR([m4])

m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])])

# This must be saved before AC_PROG_CC
USER_CFLAGS="$CFLAGS"

AC_PROG_CC([cc gcc])
AM_PROG_CC_C_O
LT_INIT([pic-only])

CHECK_OS_OPTIONS

CHECK_C_HARDENING_OPTIONS

DISABLE_AS_EXECUTABLE_STACK
AM_PROG_AS

DISABLE_COMPILER_WARNINGS

CHECK_LIBC_COMPAT
CHECK_CRYPTO_COMPAT
CHECK_VA_COPY

AC_MSG_CHECKING([if .gnu.warning accepts long strings])
AC_LINK_IFELSE([AC_LANG_SOURCE([[
extern void SSLv3_method();
__asm__(".section .gnu.warning.SSLv3_method\n\t.ascii \"SSLv3_method is insecure\"\n\t.text");
int main() {return 0;}
]])], [
    AC_DEFINE(HAS_GNU_WARNING_LONG, 1, [Define if .gnu.warning accepts long strings.])
    AC_MSG_RESULT(yes)
], [
   AC_MSG_RESULT(no)
])

AX_CHECK_OPENSSL([], [AC_MSG_ERROR([unable to find OpenSSL])])

AC_CONFIG_FILES([
	Makefile
	include/Makefile
	man/Makefile
	libtls.pc
])

AC_OUTPUT
