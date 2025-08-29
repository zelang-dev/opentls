include_directories(
	.
	../include
	${CMAKE_BINARY_DIR}/include
	../include/compat
)

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
		add_test(NAME ${TEST_NAME} COMMAND ${ARGN})
	endif()
endfunction()

# tlstest
# Emscripten does not support socketpair syscall.
if(NOT (CMAKE_SYSTEM_NAME MATCHES "WindowsStore" OR EMSCRIPTEN))
	set(TLSTEST_SRC tlstest.c)
	add_executable(tlstest ${TLSTEST_SRC})
	target_link_libraries(tlstest ${PROJECT_NAME})
	if(NOT WIN32)
		add_test(NAME tlstest COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/tlstest.sh)
	else()
		add_test(NAME tlstest COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/tlstest.bat $<TARGET_FILE:tlstest>)
	endif()
endif()

add_executable(example example.c)
target_link_libraries(example ${PROJECT_NAME})