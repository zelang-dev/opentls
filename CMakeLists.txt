cmake_minimum_required (VERSION 3.16.4...4.1.0)
if (CMAKE_VERSION VERSION_GREATER_EQUAL "3.24.0")
    cmake_policy(SET CMP0135 NEW)
	cmake_policy(SET CMP0091 NEW)
endif()

project(opentls
	VERSION 4.1.18
	DESCRIPTION "A new TLS library, designed to make it easier to write foolproof applications."
    LANGUAGES C
)

set(CMAKE_C_STANDARD 90)

include(FetchContent)
include(CheckFunctionExists)
include(CheckSymbolExists)
include(CheckLibraryExists)
include(CheckIncludeFiles)
include(CheckTypeSize)
include(CMakePackageConfigHelpers)
include(CMakeDependentOption)
include(CTest)

set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}" ${CMAKE_MODULE_PATH})
include(cmake_export_symbol)
include(GNUInstallDirs)

set(BUILD_DIR ${CMAKE_CURRENT_SOURCE_DIR}/build)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${BUILD_DIR})
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/built")

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS ON)

option(BUILD_SHARED_LIBS    "Build the library as a shared (dynamically-linked) " OFF)

file(READ ${CMAKE_CURRENT_SOURCE_DIR}/src/VERSION TLS_VERSION)
string(STRIP ${TLS_VERSION} TLS_VERSION)
string(REPLACE ":" "." TLS_VERSION ${TLS_VERSION})
string(REGEX REPLACE "\\..*" "" TLS_MAJOR_VERSION ${TLS_VERSION})

if(NOT BUILD_SHARED_LIBS)
	if(WIN32)
		set(OPENSSL_MSVC_STATIC_RT TRUE)
		add_definitions(-DOPENSSL_MSVC_STATIC_RT=TRUE)
	else()
		set(OPENSSL_USE_STATIC_LIBS TRUE)
		add_definitions(-DOPENSSL_USE_STATIC_LIBS=TRUE)
	endif()
endif()

message("Generated with config types: ${CMAKE_CONFIGURATION_TYPES}")

set(CMAKE_CONFIGURATION_TYPES=Debug;Release)
find_package(OpenSSL 1.1.0...<4.0.0 REQUIRED)
if(WIN32)
	include_directories(${OPENSSL_INCLUDE_DIR})
endif()

if(CMAKE_SYSTEM_NAME MATCHES "OpenBSD")
	add_definitions(-DHAVE_ATTRIBUTE__BOUNDED__)
	add_definitions(-DHAVE_ATTRIBUTE__DEAD__)
endif()

if(CMAKE_SYSTEM_NAME MATCHES "Linux")
	add_definitions(-D_DEFAULT_SOURCE)
	add_definitions(-D_BSD_SOURCE)
	add_definitions(-D_POSIX_SOURCE)
	add_definitions(-D_GNU_SOURCE)
	set(PLATFORM_LIBS ${PLATFORM_LIBS} pthread)
endif()

if(CMAKE_SYSTEM_NAME MATCHES "FreeBSD")
	set(PLATFORM_LIBS ${PLATFORM_LIBS} pthread)
endif()

if(WIN32)
	set(BUILD_NC false)
	if(MINGW)
		add_definitions(-D_GNU_SOURCE)
		add_definitions(-D_POSIX)
		add_definitions(-D_POSIX_SOURCE)
		add_definitions(-D__USE_MINGW_ANSI_STDIO)
	endif()
endif()

if(CMAKE_SYSTEM_NAME MATCHES "HP-UX")
	if(CMAKE_C_COMPILER MATCHES "gcc")
		set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fno-strict-aliasing")
		set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -mlp64")
	else()
		set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} +DD64 +Otype_safety=off")
	endif()
	set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -D_XOPEN_SOURCE=600 -D__STRICT_ALIGNMENT")
	set(PLATFORM_LIBS ${PLATFORM_LIBS} pthread)
endif()

if(CMAKE_SYSTEM_NAME MATCHES "SunOS")
	set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fno-strict-aliasing")
	set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -D__EXTENSIONS__")
	set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -D_XOPEN_SOURCE=600")
	set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -DBSD_COMP")
	set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fpic")
	set(PLATFORM_LIBS ${PLATFORM_LIBS} dl md nsl socket)
endif()

add_definitions(-DOPENSSL_NO_HW_PADLOCK)
add_definitions(-DENABLE_LIBTLS_ONLY)
add_definitions(-D__BEGIN_HIDDEN_DECLS=)
add_definitions(-D__END_HIDDEN_DECLS=)

if (CMAKE_COMPILER_IS_GNUCC OR CMAKE_C_COMPILER_ID MATCHES "Clang")
	add_compile_options(-Wno-pointer-sign)
endif()

if(WIN32)
	add_definitions(-D_CRT_SECURE_NO_WARNINGS)
	add_definitions(-D_CRT_DEPRECATED_NO_WARNINGS)
	add_definitions(-D_REENTRANT -D_POSIX_THREAD_SAFE_FUNCTIONS)
	add_definitions(-DNO_SYSLOG)
	add_definitions(-DWIN32_LEAN_AND_MEAN)
	if(NOT CMAKE_SYSTEM_NAME MATCHES "WindowsStore")
		add_definitions(-D_WIN32_WINNT=0x0600)
	endif()
	set(PLATFORM_LIBS ${PLATFORM_LIBS} ws2_32 ntdll bcrypt)
endif()

if(MSVC)
	add_definitions(-Dinline=__inline)
	message(STATUS "Using [${CMAKE_C_COMPILER_ID}] compiler")

	include(TestBigEndian)
	TEST_BIG_ENDIAN(HAVE_BIG_ENDIAN)
	if(HAVE_BIG_ENDIAN)
		add_definitions(-DHAVE_BIG_ENDIAN)
	else()
		add_definitions(-DHAVE_LITTLE_ENDIAN)
	endif()

	if(CMAKE_C_COMPILER_ID MATCHES "MSVC" OR CMAKE_C_COMPILER_ID MATCHES "Clang")
		set(MSVC_DISABLED_WARNINGS_LIST
			"C4018" # 'expression' : signed/unsigned mismatch
			"C4057" # 'operator' : 'identifier1' indirection to
			        # slightly different base types from 'identifier2'
			"C4100" # 'identifier' : unreferenced formal parameter
			"C4127" # conditional expression is constant
			"C4132" # 'object' : const object should be initialized
			"C4146" # unary minus operator applied to unsigned type,
			        # result still unsigned
			"C4206" # nonstandard extension used : translation unit is empty
			"C4244" # 'argument' : conversion from 'type1' to 'type2',
			        # possible loss of data
			"C4245" # 'conversion' : conversion from 'type1' to 'type2',
			        # signed/unsigned mismatch
			"C4267" # 'var' : conversion from 'size_t' to 'type',
			        # possible loss of data
			"C4295" # 'array' : array is too small to include a terminating
			        # null character
			"C4389" # 'operator' : signed/unsigned mismatch
			"C4706" # assignment within conditional expression
			"C4996" # The POSIX name for this item is deprecated.
			        # Instead, use the ISO C and C++ conformant name
		)
	elseif(CMAKE_C_COMPILER_ID MATCHES "Intel")
		add_definitions(-D_CRT_SUPPRESS_RESTRICT)
		set(MSVC_DISABLED_WARNINGS_LIST
			"C111"  # Unreachable statement
			"C128"  # Unreachable loop
			"C167"  # Unexplict casting unsigned to signed
			"C186"  # Pointless comparison of unsigned int with zero
			"C188"  # Enumerated type mixed with another type
			"C344"  # Redeclared type
			"C556"  # Unexplict casting signed to unsigned
			"C869"  # Unreferenced parameters
			"C1786" # Deprecated functions
			"C2545" # Empty else statement
			"C2557" # Comparing signed to unsigned
			"C2722" # List init syntax is c++11 feature
			"C3280" # Declaration hides variable
		)
	endif()
	string(REPLACE "C" " -wd" MSVC_DISABLED_WARNINGS_STR
		${MSVC_DISABLED_WARNINGS_LIST})
	string(REGEX REPLACE "[/-]W[1234][ ]?" "" CMAKE_C_FLAGS ${CMAKE_C_FLAGS})
	set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -MP -W4 ${MSVC_DISABLED_WARNINGS_STR}")
else()
	set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall")
endif()

# XXX - needs _GNU_SOURCE on linux
check_function_exists(asprintf HAVE_ASPRINTF)
if(HAVE_ASPRINTF)
	add_definitions(-DHAVE_ASPRINTF)
endif()

check_symbol_exists(getdelim "stdio.h" HAVE_GETDELIM)
if(HAVE_GETDELIM)
	add_definitions(-DHAVE_GETDELIM)
endif()

check_symbol_exists(getline "stdio.h" HAVE_GETLINE)
if(HAVE_GETLINE)
	add_definitions(-DHAVE_GETLINE)
endif()

check_symbol_exists(getopt "unistd.h" HAVE_GETOPT)
if(HAVE_GETOPT)
	add_definitions(-DHAVE_GETOPT)
endif()

check_symbol_exists(reallocarray "stdlib.h" HAVE_REALLOCARRAY)
if(HAVE_REALLOCARRAY)
	add_definitions(-DHAVE_REALLOCARRAY)
endif()

# XXX strcasecmp() is in strings.h which isn't available everywhere
check_function_exists(strcasecmp HAVE_STRCASECMP)
if(HAVE_STRCASECMP)
	add_definitions(-DHAVE_STRCASECMP)
endif()

# Emscripten's strlcat and strlcpy triggers ASAN errors
if(NOT EMSCRIPTEN)
	check_symbol_exists(strlcat "string.h" HAVE_STRLCAT)
	if(HAVE_STRLCAT)
		add_definitions(-DHAVE_STRLCAT)
	endif()

	check_symbol_exists(strlcpy "string.h" HAVE_STRLCPY)
	if(HAVE_STRLCPY)
		add_definitions(-DHAVE_STRLCPY)
	endif()
endif()

check_symbol_exists(strndup "string.h" HAVE_STRNDUP)
if(HAVE_STRNDUP)
	add_definitions(-DHAVE_STRNDUP)
endif()

if(WIN32)
	set(HAVE_STRNLEN true)
	add_definitions(-DHAVE_STRNLEN)
else()
	check_symbol_exists(strnlen "string.h" HAVE_STRNLEN)
	if(HAVE_STRNLEN)
		add_definitions(-DHAVE_STRNLEN)
	endif()
endif()

check_symbol_exists(strsep "string.h" HAVE_STRSEP)
if(HAVE_STRSEP)
	add_definitions(-DHAVE_STRSEP)
endif()

check_symbol_exists(strtonum "stdlib.h" HAVE_STRTONUM)
if(HAVE_STRTONUM)
	add_definitions(-DHAVE_STRTONUM)
endif()

check_symbol_exists(arc4random_buf "stdlib.h" HAVE_ARC4RANDOM_BUF)
if(HAVE_ARC4RANDOM_BUF)
	add_definitions(-DHAVE_ARC4RANDOM_BUF)
endif()

check_symbol_exists(arc4random_uniform "stdlib.h" HAVE_ARC4RANDOM_UNIFORM)
if(HAVE_ARC4RANDOM_UNIFORM)
	add_definitions(-DHAVE_ARC4RANDOM_UNIFORM)
endif()

check_symbol_exists(explicit_bzero "string.h" HAVE_EXPLICIT_BZERO)
if(HAVE_EXPLICIT_BZERO)
	add_definitions(-DHAVE_EXPLICIT_BZERO)
endif()

check_symbol_exists(getauxval "sys/auxv.h" HAVE_GETAUXVAL)
if(HAVE_GETAUXVAL)
	add_definitions(-DHAVE_GETAUXVAL)
endif()

# XXX macos fails to find getentropy with check_symbol_exists()
check_function_exists(getentropy HAVE_GETENTROPY)
if(HAVE_GETENTROPY)
	add_definitions(-DHAVE_GETENTROPY)
endif()

check_symbol_exists(getpagesize "unistd.h" HAVE_GETPAGESIZE)
if(HAVE_GETPAGESIZE)
	add_definitions(-DHAVE_GETPAGESIZE)
endif()

check_symbol_exists(getprogname "stdlib.h" HAVE_GETPROGNAME)
if(HAVE_GETPROGNAME)
	add_definitions(-DHAVE_GETPROGNAME)
endif()

check_symbol_exists(syslog_r "syslog.h;stdarg.h" HAVE_SYSLOG_R)
if(HAVE_SYSLOG_R)
	add_definitions(-DHAVE_SYSLOG_R)
endif()

# XXX - needs _GNU_SOURCE on linux
check_function_exists(syslog HAVE_SYSLOG)
if(HAVE_SYSLOG)
	add_definitions(-DHAVE_SYSLOG)
endif()

check_symbol_exists(timespecsub sys/time.h HAVE_TIMESPECSUB)
if(HAVE_TIMESPECSUB)
	add_definitions(-DHAVE_TIMESPECSUB)
endif()

check_symbol_exists(timingsafe_bcmp "string.h" HAVE_TIMINGSAFE_BCMP)
if(HAVE_TIMINGSAFE_BCMP)
	add_definitions(-DHAVE_TIMINGSAFE_BCMP)
endif()

check_symbol_exists(timingsafe_memcmp "string.h" HAVE_TIMINGSAFE_MEMCMP)
if(HAVE_TIMINGSAFE_MEMCMP)
	add_definitions(-DHAVE_TIMINGSAFE_MEMCMP)
endif()

# XXX - needs _GNU_SOURCE on linux
check_function_exists(memmem HAVE_MEMMEM)
if(HAVE_MEMMEM)
	add_definitions(-DHAVE_MEMMEM)
endif()

check_include_files(endian.h HAVE_ENDIAN_H)
if(HAVE_ENDIAN_H)
	add_definitions(-DHAVE_ENDIAN_H)
endif()

check_include_files(machine/endian.h HAVE_MACHINE_ENDIAN_H)
if(HAVE_MACHINE_ENDIAN_H)
	add_definitions(-DHAVE_MACHINE_ENDIAN_H)
endif()

check_include_files(err.h HAVE_ERR_H)
if(HAVE_ERR_H)
	add_definitions(-DHAVE_ERR_H)
endif()

check_include_files("sys/types.h;arpa/inet.h;netinet/ip.h" HAVE_NETINET_IP_H)
if(HAVE_NETINET_IP_H)
	add_definitions(-DHAVE_NETINET_IP_H)
endif()

# This isn't ready for universal binaries yet, since we do conditional
# compilation based on the architecture, but this makes cross compiling for a
# single architecture work on macOS at least.
#
# Don't set CMAKE_OSX_ARCHITECTURES to more than a single value for now.
if(APPLE AND (NOT CMAKE_OSX_ARCHITECTURES STREQUAL ""))
	set(CMAKE_SYSTEM_PROCESSOR "${CMAKE_OSX_ARCHITECTURES}")
endif()

if(CMAKE_SYSTEM_PROCESSOR MATCHES "(aarch64|arm64|ARM64)")
	set(HOST_AARCH64 true)
elseif(CMAKE_SYSTEM_PROCESSOR MATCHES "arm")
	set(HOST_ARM true)
elseif(CMAKE_SYSTEM_NAME STREQUAL "SunOS" AND CMAKE_SYSTEM_PROCESSOR MATCHES "i386")
	set(HOST_X86_64 true)
elseif(CMAKE_SYSTEM_PROCESSOR MATCHES "(x86_64|amd64|AMD64)")
	set(HOST_X86_64 true)
elseif(CMAKE_SYSTEM_PROCESSOR MATCHES "(i[3-6]86|[xX]86)")
	set(HOST_I386 true)
elseif(CMAKE_SYSTEM_PROCESSOR MATCHES "loongarch64")
	set(HOST_LOONGARCH64 true)
elseif(CMAKE_SYSTEM_PROCESSOR MATCHES "mips64")
	set(HOST_MIPS64 true)
elseif(CMAKE_SYSTEM_PROCESSOR MATCHES "mips")
	set(HOST_MIPS true)
elseif(CMAKE_SYSTEM_PROCESSOR MATCHES "powerpc")
	set(HOST_POWERPC true)
elseif(CMAKE_SYSTEM_PROCESSOR MATCHES "ppc64")
	set(HOST_POWERPC64 true)
elseif(CMAKE_SYSTEM_PROCESSOR MATCHES "riscv64")
	set(HOST_RISCV64 true)
elseif(CMAKE_SYSTEM_PROCESSOR MATCHES "sparc64")
	set(HOST_SPARC64 true)
endif()

if(CMAKE_SYSTEM_NAME MATCHES "Linux")
	# Check if we need -lrt to get clock_gettime on Linux
	check_library_exists(rt clock_gettime "time.h" HAVE_CLOCK_GETTIME)
	if (HAVE_CLOCK_GETTIME)
		set(PLATFORM_LIBS ${PLATFORM_LIBS} rt)
	endif()
else()
	# Otherwise, simply check if it exists
	check_function_exists(clock_gettime HAVE_CLOCK_GETTIME)
endif()
if(HAVE_CLOCK_GETTIME)
	add_definitions(-DHAVE_CLOCK_GETTIME)
endif()

check_type_size(time_t SIZEOF_TIME_T)
if(SIZEOF_TIME_T STREQUAL "4")
	set(SMALL_TIME_T true)
	add_definitions(-DSMALL_TIME_T)
	message(WARNING " ** Warning, this system is unable to represent times past 2038\n"
	                " ** It will behave incorrectly when handling valid RFC5280 dates")
endif()

file(COPY ${CMAKE_CURRENT_SOURCE_DIR}/src/tls.sym
	DESTINATION ${CMAKE_CURRENT_BINARY_DIR})

file(COPY ${CMAKE_CURRENT_SOURCE_DIR}/cert.pem
	DESTINATION ${CMAKE_CURRENT_BINARY_DIR})

if(WIN32)
	set(CONINFO ${CMAKE_CURRENT_SOURCE_DIR}/src/tls_conninfo.c)
	set(VERIFY ${CMAKE_CURRENT_SOURCE_DIR}/src/tls_verify.c)
else()
	set(CONINFO ${CMAKE_CURRENT_SOURCE_DIR}/src/tls_conninfo_ex.c)
	set(VERIFY ${CMAKE_CURRENT_SOURCE_DIR}/src/tls_verify_ex.c)
endif()

set(
	TLS_SRC
	${CMAKE_CURRENT_SOURCE_DIR}/src/a_time_posix.c
	${CMAKE_CURRENT_SOURCE_DIR}/src/tls.c
	${CMAKE_CURRENT_SOURCE_DIR}/src/tls_bio_cb.c
	${CMAKE_CURRENT_SOURCE_DIR}/src/tls_client.c
	${CMAKE_CURRENT_SOURCE_DIR}/src/tls_config.c
	${CONINFO}
	${CMAKE_CURRENT_SOURCE_DIR}/src/tls_keypair.c
	${CMAKE_CURRENT_SOURCE_DIR}/src/tls_server.c
	${CMAKE_CURRENT_SOURCE_DIR}/src/tls_signer.c
	${CMAKE_CURRENT_SOURCE_DIR}/src/tls_ocsp.c
	${CMAKE_CURRENT_SOURCE_DIR}/src/tls_peer.c
	${CMAKE_CURRENT_SOURCE_DIR}/src/tls_util.c
	${VERIFY}
)

if(WIN32)
	set(
		TLS_SRC
		${TLS_SRC}
	)

	set(COMPAT_SRC ${COMPAT_SRC} compat/ftruncate.c)
	set(COMPAT_SRC ${COMPAT_SRC} compat/pread.c)
	set(COMPAT_SRC ${COMPAT_SRC} compat/pwrite.c)
endif()

if(WIN32)
	set(COMPAT_SRC ${COMPAT_SRC} compat/posix_win.c)
endif()

if(NOT HAVE_ASPRINTF)
	set(COMPAT_SRC ${COMPAT_SRC} compat/bsd-asprintf.c)
endif()

if(NOT HAVE_FREEZERO)
	set(COMPAT_SRC ${COMPAT_SRC} compat/freezero.c)
endif()

if(NOT HAVE_GETDELIM)
	set(COMPAT_SRC ${COMPAT_SRC} compat/getdelim.c)
endif()

if(NOT HAVE_GETLINE)
	set(COMPAT_SRC ${COMPAT_SRC} compat/getline.c)
endif()

if(NOT HAVE_GETOPT)
	set(COMPAT_SRC ${COMPAT_SRC} compat/getopt_long.c)
endif()

if(NOT HAVE_GETPAGESIZE)
	set(COMPAT_SRC ${COMPAT_SRC} compat/getpagesize.c)
endif()

if(NOT HAVE_GETPROGNAME)
	if(WIN32)
		set(COMPAT_SRC ${COMPAT_SRC} compat/getprogname_windows.c)
	elseif(CMAKE_SYSTEM_NAME MATCHES "Linux")
		set(COMPAT_SRC ${COMPAT_SRC} compat/getprogname_linux.c)
	else()
		set(COMPAT_SRC ${COMPAT_SRC} compat/getprogname_unimpl.c)
	endif()
endif()

if(NOT HAVE_REALLOCARRAY)
	set(COMPAT_SRC ${COMPAT_SRC} compat/reallocarray.c)
endif()

if(NOT HAVE_RECALLOCARRAY)
	set(COMPAT_SRC ${COMPAT_SRC} compat/recallocarray.c)
endif()

if(NOT HAVE_STRCASECMP)
	set(COMPAT_SRC ${COMPAT_SRC} compat/strcasecmp.c)
endif()

if(NOT HAVE_STRLCAT)
	set(COMPAT_SRC ${COMPAT_SRC} compat/strlcat.c)
endif()

if(NOT HAVE_STRLCPY)
	set(COMPAT_SRC ${COMPAT_SRC} compat/strlcpy.c)
endif()

if(NOT HAVE_STRNDUP)
	set(COMPAT_SRC ${COMPAT_SRC} compat/strndup.c)
	if(NOT HAVE_STRNLEN)
		set(COMPAT_SRC ${COMPAT_SRC} compat/strnlen.c)
	endif()
endif()

if(NOT HAVE_STRSEP)
	set(COMPAT_SRC ${COMPAT_SRC} compat/strsep.c)
endif()

if(NOT HAVE_STRTONUM)
	set(COMPAT_SRC ${COMPAT_SRC} compat/strtonum.c)
endif()

if(NOT HAVE_SYSLOG_R)
	set(COMPAT_SRC ${COMPAT_SRC} compat/syslog_r.c)
endif()

if(NOT HAVE_EXPLICIT_BZERO)
	if(WIN32)
		set(COMPAT_SRC ${COMPAT_SRC} compat/explicit_bzero_win.c)
	else()
		set(COMPAT_SRC ${COMPAT_SRC} compat/explicit_bzero.c)
		set_source_files_properties(compat/explicit_bzero.c PROPERTIES COMPILE_FLAGS -O0)
	endif()
endif()

if(NOT HAVE_ARC4RANDOM_BUF)
	set(COMPAT_SRC ${COMPAT_SRC} compat/arc4random.c)
	set(COMPAT_SRC ${COMPAT_SRC} compat/arc4random_uniform.c)

	if(NOT HAVE_GETENTROPY)
		if(WIN32)
			set(COMPAT_SRC ${COMPAT_SRC} compat/getentropy_win.c)
		elseif(CMAKE_SYSTEM_NAME MATCHES "AIX")
			set(COMPAT_SRC ${COMPAT_SRC} compat/getentropy_aix.c)
		elseif(CMAKE_SYSTEM_NAME MATCHES "FreeBSD")
			set(COMPAT_SRC ${COMPAT_SRC} compat/getentropy_freebsd.c)
		elseif(CMAKE_SYSTEM_NAME MATCHES "HP-UX")
			set(COMPAT_SRC ${COMPAT_SRC} compat/getentropy_hpux.c)
		elseif(CMAKE_SYSTEM_NAME MATCHES "Linux")
			set(COMPAT_SRC ${COMPAT_SRC} compat/getentropy_linux.c)
		elseif(CMAKE_SYSTEM_NAME MATCHES "NetBSD")
			set(COMPAT_SRC ${COMPAT_SRC} compat/getentropy_netbsd.c)
		elseif(CMAKE_SYSTEM_NAME MATCHES "Darwin")
			set(COMPAT_SRC ${COMPAT_SRC} compat/getentropy_osx.c)
		elseif(CMAKE_SYSTEM_NAME MATCHES "SunOS")
			set(COMPAT_SRC ${COMPAT_SRC} compat/getentropy_solaris.c)
		endif()
	endif()
endif()

if(NOT HAVE_TIMINGSAFE_BCMP)
	set(COMPAT_SRC ${COMPAT_SRC} compat/timingsafe_bcmp.c)
endif()

if(NOT HAVE_TIMINGSAFE_MEMCMP)
	set(COMPAT_SRC ${COMPAT_SRC} compat/timingsafe_memcmp.c)
endif()

add_library(${PROJECT_NAME} ${TLS_SRC} ${COMPAT_SRC} ${CMAKE_CURRENT_SOURCE_DIR}/src/empty.c)
add_library(OPENTLS::TLS ALIAS ${PROJECT_NAME})

target_include_directories(${PROJECT_NAME} PUBLIC ${OPENSSL_INCLUDE_DIR})

target_include_directories(${PROJECT_NAME}
 PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/src ${CMAKE_CURRENT_SOURCE_DIR}/include/compat)

target_link_libraries(${PROJECT_NAME} PUBLIC ${PLATFORM_LIBS})
target_link_libraries(${PROJECT_NAME} PUBLIC OpenSSL::SSL)
target_link_libraries(${PROJECT_NAME} PUBLIC OpenSSL::Crypto)

target_include_directories(${PROJECT_NAME}
    PRIVATE $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
	$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>)

export_symbol(${PROJECT_NAME} ${CMAKE_CURRENT_BINARY_DIR}/tls.sym)

execute_process(
    COMMAND openssl version -d
    OUTPUT_VARIABLE openssl_dir_log
	OUTPUT_STRIP_TRAILING_WHITESPACE
)
string(REPLACE "OPENSSLDIR: " "" openssl_dir ${openssl_dir_log})
string(REPLACE "\"" "" openssl_dir_log ${openssl_dir})
message("OPENSSLDIR=${openssl_dir_log}")

set(OPENSSLDIR ${openssl_dir_log} CACHE PATH "Set the default openssl directory" FORCE)
add_definitions(-DTLS_DEFAULT_CA_FILE=\"${OPENSSLDIR}/cert.pem\")

set_target_properties(${PROJECT_NAME} PROPERTIES
	OUTPUT_NAME ${PROJECT_NAME}
	ARCHIVE_OUTPUT_NAME ${PROJECT_NAME}
	EXPORT_NAME ${PROJECT_NAME}
	VERSION ${TLS_VERSION}
	SOVERSION ${TLS_MAJOR_VERSION}
)

if(NOT CMAKE_VERSION VERSION_LESS 3.27.0)
	set_target_properties(${PROJECT_NAME} PROPERTIES DLL_NAME_WITH_SOVERSION TRUE)
endif()

if(NOT MSVC)
	add_subdirectory(man)
endif()

if(CMAKE_CURRENT_SOURCE_DIR STREQUAL CMAKE_SOURCE_DIR)
    option(BUILD_EXAMPLES "whether or not examples should be built" ON)
    option(BUILD_TESTS "whether or not tests should be built" ON)

    if(BUILD_TESTS)
        enable_testing()
        add_subdirectory(tests)
    endif()
endif()

set(_fmt TGZ)
if(WIN32)
  set(_fmt ZIP)
endif()

set(CPACK_GENERATOR ${_fmt})
set(CPACK_ARCHIVE_COMPONENT_INSTALL ON)
set(CPACK_DEB_COMPONENT_INSTALL ON)
set(CPACK_RPM_COMPONENT_INSTALL ON)
set(CPACK_NUGET_COMPONENT_INSTALL ON)
set(CPACK_WIX_COMPONENT_INSTALL ON)
set(CPACK_NSIS_MODIFY_PATH ON)
set(CPACK_COMPONENTS_ALL_IN_ONE_PACKAGE 1)
set(CPACK_VERBATIM_VARIABLES YES)

set(CPACK_PACKAGE_VENDOR "https://github.com/zelang-dev/opentls")
set(CPACK_PACKAGE_VERSION 4.1.0)

set(CMAKE_INSTALL_CONFIG_NAME ${CMAKE_BUILD_TYPE})
set(INCLUDE_INSTALL_DIR ${CMAKE_INSTALL_INCLUDEDIR}/${PROJECT_NAME}
    CACHE PATH "Location of header files" )

set(SYSCONFIG_INSTALL_DIR ${CMAKE_INSTALL_SYSCONFDIR}/${PROJECT_NAME}
    CACHE PATH "Location of configuration files" )

configure_package_config_file(OpenTLSConfig.cmake.in
  	${CMAKE_CURRENT_BINARY_DIR}/opentlsConfig.cmake
	INSTALL_DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}
	PATH_VARS INCLUDE_INSTALL_DIR SYSCONFIG_INSTALL_DIR)

write_basic_package_version_file(
  ${CMAKE_CURRENT_BINARY_DIR}/opentlsConfigVersion.cmake
  VERSION ${PROJECT_VERSION}
  COMPATIBILITY SameMajorVersion )

set(CPACK_PACKAGE_DIRECTORY "${CMAKE_ARCHIVE_OUTPUT_DIRECTORY}/Package")
set(CPACK_PACKAGE_FILE_NAME ${CPACK_PACKAGE_NAME})
set(CPACK_PACKAGE_INSTALL_DIRECTORY ${PROJECT_NAME})

set(CPACK_PACKAGE_CONTACT "lstubbs@zelang.dev")
set(CPACK_DEBIAN_PACKAGE_MAINTAINER "Lawrence Stubbs <${CPACK_PACKAGE_CONTACT}>")
set(CPACK_DEBIAN_FILE_NAME DEB-DEFAULT)
set(CPACK_COMPONENTS_GROUPING ALL_COMPONENTS_IN_ONE)
SET(CPACK_COMPONENT_LIBRARIES_DISPLAY_NAME "libtls for OpenSSL")
SET(CPACK_COMPONENT_LIBRARIES_DESCRIPTION "A new TLS library, designed to make it easier to write foolproof applications.")

set(CPACK_RESOURCE_FILE_LICENSE ${CMAKE_CURRENT_SOURCE_DIR}/LICENSE.md)
set(CPACK_RESOURCE_FILE_README ${CMAKE_CURRENT_SOURCE_DIR}/README.md)

set(CPACK_PACKAGE_VENDOR "https://github.com/zelang-dev")
set(CPACK_PACKAGE_VERSION ${PROJECT_VERSION})
set(CPACK_PACKAGE_DESCRIPTION ${PROJECT_DESCRIPTION})

set(CPACK_RPM_PACKAGE_LICENSE "MIT")
set(CPACK_RPM_PACKAGE_URL "https://zelang-dev.github.io/opentls/")
set(CPACK_RPM_PACKAGE_ARCHITECTURE "noarch")

install(FILES ${CMAKE_CURRENT_BINARY_DIR}/opentlsConfig.cmake
	${CMAKE_CURRENT_BINARY_DIR}/opentlsConfigVersion.cmake
	DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}" )

install(
	TARGETS ${PROJECT_NAME}
	EXPORT "${PROJECT_NAME}Targets"
	ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
	LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
	PUBLIC_HEADER DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
	INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
)

install(
	EXPORT "${PROJECT_NAME}Targets"
	FILE "${PROJECT_NAME}Targets.cmake"
	NAMESPACE OPENTLS::
	DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}"
)

if(OPENSSLDIR STREQUAL "")
	if(WIN32)
		set(OPENSSLDIR "C:/Windows/opemtls/ssl")
	else()
		set(OPENSSLDIR "${CMAKE_INSTALL_SYSCONFDIR}/ssl")
	endif()

	set(CONF_DIR "${CMAKE_INSTALL_SYSCONFDIR}/ssl")
else()
	set(CONF_DIR "${OPENSSLDIR}")
endif()

install(TARGETS ${PROJECT_NAME} DESTINATION lib)
install(FILES include/tls.h DESTINATION include)
install(FILES cert.pem DESTINATION ${CONF_DIR})
include(CPack)

if(NOT CMAKE_CURRENT_SOURCE_DIR STREQUAL CMAKE_SOURCE_DIR)
	file(COPY cert.pem DESTINATION ${CMAKE_SOURCE_DIR})
endif()