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

OPENTLS_FOUND
    System has the openTLS library. If no components are requested it only requires the crypto library.
OPENTLS_INCLUDE_DIR
    The openTLS include directory.
OPENTLS_TLS_LIBRARY
    The openTLS TLS library.
OPENTLS_LIBRARIES
    All openTLS libraries.
OPENTLS_VERSION
    This is set to $major.$minor.$revision (e.g. 2.6.8).

Hints
^^^^^

Set OPENTLS_ROOT_DIR to the root directory of an openTLS installation.

]=======================================================================]

INCLUDE(FindPackageHandleStandardArgs)

# Set Hints
set(_OPENTLS_ROOT_HINTS
    ${OPENTLS_ROOT_DIR}
    ENV OPENTLS_ROOT_DIR
)

# Set Paths
if (WIN32)
    file(TO_CMAKE_PATH "$ENV{PROGRAMFILES}" _programfiles)
    set(_OPENTLS_ROOT_PATHS
        "${_programfiles}/openTLS"
    )
    unset(_programfiles)
elseif(APPLE)
    # Homebrew installs openTLS here
    set(_OPENTLS_ROOT_PATHS
        "/usr/local/opt/opentls"
    )
else()
    set(_OPENTLS_ROOT_PATHS
        "/usr/local/"
    )
endif()

# Combine
set(_OPENTLS_ROOT_HINTS_AND_PATHS
    HINTS ${_OPENTLS_ROOT_HINTS}
    PATHS ${_OPENTLS_ROOT_PATHS}
)

# Find Include Path
find_path(OPENTLS_INCLUDE_DIR
    NAMES
        tls.h
    ${_OPENTLS_ROOT_HINTS_AND_PATHS}
    PATH_SUFFIXES
        include
)

# Find TLS Library
find_library(OPENTLS_TLS_LIBRARY
    NAMES
        opentls
        libretls
        libtls
        tls
        NAMES_PER_DIR
    ${_OPENTLS_ROOT_HINTS_AND_PATHS}
    PATH_SUFFIXES
        lib
)

# Set Libraries
set(OPENTLS_LIBRARIES ${OPENSSL_LIBRARIES} ${OPENTLS_TLS_LIBRARY})

# Mark Variables As Advanced
mark_as_advanced(OPENTLS_INCLUDE_DIR OPENTLS_LIBRARIES OPENTLS_TLS_LIBRARY)

# Find Version File
if(OPENTLS_INCLUDE_DIR AND EXISTS "${OPENTLS_INCLUDE_DIR}/openssl/opensslv.h")

    # Get Version From File
    file(STRINGS "${OPENTLS_INCLUDE_DIR}/openssl/opensslv.h" OPENSSLV.H REGEX "#define OPENTLS_VERSION_TEXT[ ]+\".*\"")

    # Match Version String
    string(REGEX REPLACE ".*\".*([0-9]+)\\.([0-9]+)\\.([0-9]+)\"" "\\1;\\2;\\3" OPENTLS_VERSION_LIST "${OPENSSLV.H}")

    # Split Parts
    list(GET OPENTLS_VERSION_LIST 0 OPENTLS_VERSION_MAJOR)
    list(GET OPENTLS_VERSION_LIST 1 OPENTLS_VERSION_MINOR)
    list(GET OPENTLS_VERSION_LIST 2 OPENTLS_VERSION_REVISION)

    # Set Version String
    set(OPENTLS_VERSION "${OPENTLS_VERSION_MAJOR}.${OPENTLS_VERSION_MINOR}.${OPENTLS_VERSION_REVISION}")

endif()

# Set Find Package Arguments
find_package_handle_standard_args(openTLS
    REQUIRED_VARS
        OPENTLS_TLS_LIBRARY
        OPENTLS_INCLUDE_DIR
    VERSION_VAR
        OPENTLS_VERSION
    HANDLE_COMPONENTS
        FAIL_MESSAGE
        "Could NOT find openTLS, try setting the path to openTLS using the OPENTLS_ROOT_DIR environment variable"
)

# openTLS Found
if(OPENTLS_FOUND)

    # Set openTLS::TLS
    if(NOT TARGET openTLS::TLS AND EXISTS "${OPENTLS_TLS_LIBRARY}")
        add_library(openTLS::TLS UNKNOWN IMPORTED)
        set_target_properties(
            openTLS::TLS
            PROPERTIES
                INTERFACE_INCLUDE_DIRECTORIES "${OPENTLS_INCLUDE_DIR}" "${OPENSSL_INCLUDE_DIR}"
                IMPORTED_LINK_INTERFACE_LANGUAGES "C"
                IMPORTED_LOCATION "${OPENTLS_TLS_LIBRARY}"
                INTERFACE_LINK_LIBRARIES ${OPENSSL_LIBRARIES}
        )

    endif() # openTLS::TLS

endif(OPENTLS_FOUND)
