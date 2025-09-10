include_directories(
	.
	../include
	${CMAKE_BINARY_DIR}/include
	../include/compat
)

file(COPY ca-root-rsa.pem DESTINATION ${CMAKE_BINARY_DIR})
file(COPY server1-rsa-chain.pem DESTINATION ${CMAKE_BINARY_DIR})
file(COPY server1-rsa.pem DESTINATION ${CMAKE_BINARY_DIR})
add_definitions(-D_PATH_SSL_CA_FILE=\"${CMAKE_CURRENT_SOURCE_DIR}/../cert.pem\")

file(TO_NATIVE_PATH ${CMAKE_CURRENT_SOURCE_DIR} TEST_SOURCE_DIR)

function(prepare_emscripten_test_target TARGET_NAME)
	if(EMSCRIPTEN)
		set_target_properties(${TARGET_NAME} PROPERTIES LINK_FLAGS
			"-sALLOW_MEMORY_GROWTH --preload-file ${TEST_SOURCE_DIR} ")
	endif()
endfunction()

function(add_platform_test TEST_NAME)
	if (EMSCRIPTEN)
		add_test(NAME ${TEST_NAME} COMMAND node ${ARGN})
	else()
		add_test(NAME ${TEST_NAME} COMMAND ${ARGN}
		WORKING_DIRECTORY ${CMAKE_BINARY_DIR})
	endif()
endfunction()

# tlstest
# Emscripten does not support socketpair syscall.
if(NOT (CMAKE_SYSTEM_NAME MATCHES "WindowsStore" OR EMSCRIPTEN))
	set(TLSTEST_SRC tlstest.c)
	check_symbol_exists(pipe2 "fcntl.h;unistd.h" HAVE_PIPE2)
	if(HAVE_PIPE2)
		add_definitions(-DHAVE_PIPE2)
	else()
		set(TLSTEST_SRC ${TLSTEST_SRC} compat/pipe2.c)
	endif()

	add_executable(tlstest ${TLSTEST_SRC})
	target_link_libraries(tlstest ${PROJECT_NAME})
	if(NOT WIN32)
		add_test(NAME tlstest COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/tlstest.sh
		WORKING_DIRECTORY ${CMAKE_BINARY_DIR})
	else()
		add_test(NAME tlstest COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/tlstest.bat $<TARGET_FILE:tlstest>
		WORKING_DIRECTORY ${CMAKE_BINARY_DIR})
	endif()
	set_tests_properties(tlstest PROPERTIES ENVIRONMENT "srcdir=${CMAKE_CURRENT_SOURCE_DIR}")

	add_executable(configtest configtest.c)
	target_link_libraries(configtest ${PROJECT_NAME})
	add_platform_test(configtest configtest)

	add_executable(keypairtest keypairtest.c)
	target_link_libraries(keypairtest ${PROJECT_NAME})
	target_include_directories(keypairtest BEFORE PUBLIC ../src)
	prepare_emscripten_test_target(keypairtest)
	if(NOT WIN32)
		add_test(NAME keypairtest COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/keypairtest.sh
		WORKING_DIRECTORY ${CMAKE_BINARY_DIR})
	else()
		add_test(NAME keypairtest COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/keypairtest.bat $<TARGET_FILE:keypairtest>
		WORKING_DIRECTORY ${CMAKE_BINARY_DIR})
	endif()

	add_executable(verifytest verifytest.c)
	target_link_libraries(verifytest ${PROJECT_NAME})
	add_platform_test(verifytest verifytest)
endif()

add_executable(example example.c)
target_link_libraries(example ${PROJECT_NAME})