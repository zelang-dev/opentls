#[=======================================================================[

Copyright (c) 2019 John Norrbin <jlnorrbin@johnex.se>

Permission to use, copy, modify, and distribute this software for any
purpose with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

FindopenTLS
------------

Find the openTLS encryption library.

Optional Components
^^^^^^^^^^^^^^^^^^^

This module supports two optional components: SSL and TLS.  Both
components have associated imported targets, as described below.

Imported Targets
^^^^^^^^^^^^^^^^

This module defines the following imported targets:

openTLS::TLS
    The openTLS tls library, if found. Requires and includes OpenSSL::SSL and OpenSSL::Crypto automatically.

Result Variables
^^^^^^^^^^^^^^^^

This module will set the following variables in your project:

``OPENTLS_FOUND``
    System has the openTLS library. If no components are requested it only requires the crypto library.
``OPENTLS_INCLUDE_DIR``
    The openTLS include directory.
``OPENTLS_TLS_LIBRARY``
    The openTLS TLS library.
``OPENTLS_LIBRARIES``
    All openTLS libraries.
OPENTLS_VERSION
    This is set to $major.$minor.$revision (e.g. 2.6.8).

Hints
^^^^^

Set OPENTLS_ROOT_DIR to the root directory of an openTLS installation.

]=======================================================================]

# Find TLS Library
find_library(opentls_TLS_LIBRARY
    NAMES
        libtls
        openTLS
        libopenTLS
        libretls
        tls
)
mark_as_advanced(opentls_TLS_LIBRARY)

# Find Include Path
find_path(opentls_INCLUDE_DIR
    NAMES tls.h
)
set(OPENTLS_INCLUDE_DIR ${INCLUDE_INSTALL_DIR})
mark_as_advanced(opentls_INCLUDE_DIR)

include (FindPackageHandleStandardArgs)
# Set Find Package Arguments
find_package_handle_standard_args(opentls
    FOUND_VAR opentls_FOUND
    REQUIRED_VARS OPENTLS_TLS_LIBRARY OPENTLS_INCLUDE_DIR
    VERSION_VAR OPENTLS_VERSION
    HANDLE_COMPONENTS
        FAIL_MESSAGE
        "Could NOT find openTLS, try setting the path to openTLS using the OPENTLS_ROOT_DIR environment variable"
)

set(OPENTLS_FOUND ${opentls_FOUND})

# openTLS Found
if(OPENTLS_FOUND)
	set(OPENTLS_INCLUDE_DIRS ${OPENTLS_INCLUDE_DIR})
	set(OPENTLS_TLS_LIBRARIES ${OPENTLS_TLS_LIBRARY})
    # Set openTLS::TLS
    if(NOT TARGET openTLS::TLS AND EXISTS "${OPENTLS_TLS_LIBRARY}")
        add_library(openTLS::TLS UNKNOWN IMPORTED)
        set_target_properties(
            openTLS::TLS
            PROPERTIES
                INTERFACE_INCLUDE_DIRECTORIES "${OPENTLS_INCLUDE_DIRS}"
                IMPORTED_LOCATION "${OPENTLS_TLS_LIBRARIES}"
                INTERFACE_LINK_LIBRARIES ${OPENSSL_LIBRARIES}
        )
    endif() # openTLS::TLS
endif(OPENTLS_FOUND)
