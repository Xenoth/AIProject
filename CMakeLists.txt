cmake_minimum_required(VERSION 3.7.2)
project(TP3)

set(CMAKE_C_STANDARD 99)

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

file(GLOB LIB_SOURCES src/lib/c/SCS-Lib/*.c)
file(GLOB LIB_HEADERS src/lib/c/SCS-Lib/*.h)

add_library(SCS-Lib ${LIB_SOURCES} ${LIB_HEADERS})

add_executable(client src/main/c/client.c)
add_executable(serveur src/main/c/server.c)

target_link_libraries(client SCS-Lib)
target_link_libraries(serveur SCS-Lib)