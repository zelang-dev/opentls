
# **openTLS** - libtls for OpenSSL

## DESCRIPTION

**openTLS** is a fork of [https://causal.agency/libretls/](https://causal.agency/libretls/), which is a port of **libtls** from LibreSSL to OpenSSL. [libtls](https://man.openbsd.org/tls_init.3) is "a new TLS library, designed to make it easier to write foolproof applications".

**libtls** provides an excellent new API, but LibreSSL can be difficult to install on systems which already use OpenSSL. **openTLS** aims to make the **libtls** API more easily and widely available.

## Tutorials

See [Writing TLS secured client and server programs using the libtls API](https://github.com/bob-beck/libtls/blob/master/TUTORIAL.md) and [libtls: Rethinking the TLS/SSL API](https://www.youtube.com/watch?v=Wd_dyRbE4AA).

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

The build system uses **cmake**, that produces **static** libraries by default.

**Linux**

```shell
mkdir build
cd build
cmake .. -D CMAKE_BUILD_TYPE=Debug/Release -D BUILD_TESTS=ON # use to build files in tests folder
cmake --build .
```

**Windows**

```shell
mkdir build
cd build
cmake .. -D BUILD_EXAMPLES=ON -D BUILD_TESTS=ON # use to build files in tests folder
cmake --build . --config Debug/Release
```

**As cmake project dependency**

Add to **CMakeLists.txt**

```c
find_package(opentls QUIET)
if(NOT opentls_FOUND)
    FetchContent_Declare(opentls
        URL https://github.com/zelang-dev/openTLS/archive/refs/tags/4.1.3.zip
        URL_MD5 c3bcb8f797babc7381af30ac354ee735
    )
    FetchContent_MakeAvailable(opentls)
endif()

target_include_directories(your_project PUBLIC $<BUILD_INTERFACE:${OPENSSL_INCLUDE_DIR}
 $<INSTALL_INTERFACE:${OPENSSL_INCLUDE_DIR})
target_include_directories(your_project PUBLIC ${OPENTLS_INCLUDE_DIR}
 $<INSTALL_INTERFACE:${OPENTLS_INCLUDE_DIR})

target_link_libraries(your_project PUBLIC ${OPENSSL_SSL_LIBRARY})
target_link_libraries(your_project PUBLIC ${OPENSSL_CRYPTO_LIBRARY})
target_link_libraries(your_project PUBLIC opentls)
```
