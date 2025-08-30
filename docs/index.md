# Library Functions

## tls_init, tls_config_new, tls_config_free, tls_config_error

* [initialize TLS client and server API](tls_init.md)

## tls_accept_socket, tls_accept_fds, tls_accept_cbs

* [accept an incoming client connection in a TLS server](tls_accept_socket.md)

## tls_client, tls_server, tls_configure, tls_reset, tls_free

* [configure a TLS connection](tls_client.md)

## tls_config_ocsp_require_stapling

* [OCSP configuration for libtls](tls_config_ocsp_require_stapling.md)

## tls_config_set_protocols, tls_config_parse_protocols, tls_config_set_alpn, tls_config_set_ciphers, tls_config_set_dheparams, tls_config_set_ecdhecurves, tls_config_prefer_ciphers_client, tls_config_prefer_ciphers_server

* [TLS protocol and cipher selection](tls_config_set_protocols.md)

## tls_config_set_session_fd, tls_config_set_session_id, tls_config_set_session_lifetime, tls_config_add_ticket_key

* [configure resuming of TLS handshakes](tls_config_set_session_id.md)

## tls_config_verify, tls_config_insecure_noverifycert, tls_config_insecure_noverifyname, tls_config_insecure_noverifytime

* [insecure TLS configuration](tls_config_verify.md)

## tls_conn_version, tls_conn_cipher, tls_conn_cipher_strength, tls_conn_alpn_selected, tls_conn_servername, tls_conn_session_resumed, tls_peer_cert_provided, tls_peer_cert_contains_name, tls_peer_cert_chain_pem, tls_peer_cert_issuer, tls_peer_cert_subject, tls_peer_cert_common_name, tls_peer_cert_hash, tls_peer_cert_notbefore, tls_peer_cert_notafter

* [inspect an established TLS connection](tls_conn_version.md)

## tls_connect, tls_connect_fds, tls_connect_servername, tls_connect_socket, tls_connect_cbs

* [instruct a TLS client to establish a connection](tls_connect.md)

## tls_load_file, tls_unload_file, tls_config_set_ca_file, tls_config_set_ca_path, tls_config_set_ca_mem, tls_config_set_cert_file, tls_config_set_cert_mem, tls_config_set_crl_file, tls_config_set_crl_mem, tls_config_set_key_file, tls_config_set_key_mem, tls_config_set_ocsp_staple_mem, tls_config_set_ocsp_staple_file, tls_config_set_keypair_file, tls_config_set_keypair_mem, tls_config_set_keypair_ocsp_file, tls_config_set_keypair_ocsp_mem, tls_config_add_keypair_file, tls_config_add_keypair_ocsp_mem, tls_config_add_keypair_ocsp_file, tls_config_add_keypair_mem, tls_config_clear_keys, tls_config_set_verify_depth, tls_config_verify_client, tls_config_verify_client_optional, tls_default_ca_cert_file

* [TLS certificate and key configuration](tls_load_file.md)

## tls_ocsp_process_response, tls_peer_ocsp_url, tls_peer_ocsp_response_status, tls_peer_ocsp_cert_status, tls_peer_ocsp_crl_reason, tls_peer_ocsp_result, tls_peer_ocsp_revocation_time, tls_peer_ocsp_this_update, tls_peer_ocsp_next_update

* [inspect an OCSP response](tls_ocsp_process_response.md)

## tls_read, tls_write, tls_handshake, tls_error, tls_close

* [use a TLS connection](tls_read.html)
