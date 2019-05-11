cmake_minimum_required(VERSION 2.6.1)
project(AIPROJECT)

set(CMAKE_C_STANDARD 99)

# Setting outup dirs
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

# SCS-Lib
file(GLOB LIB_SOURCES src/lib/c/SCS-Lib/*.c)
file(GLOB LIB_HEADERS src/lib/c/SCS-Lib/*.h)


add_library(SCS-Lib ${LIB_SOURCES} ${LIB_HEADERS})

# Executables
add_executable(joueur src/main/c/joueur.c src/main/c/JoueurEngine.h src/main/c/JoueurEngine.c src/protocol/c/protocolYokai.h src/protocol/c/YokaiJavaEngineProtocol.h src/protocol/c/YokaiJavaEngineProtocol.c)
add_executable(serveurArbitre build/bin/yokai-fPIC.o src/main/c/serveurArbitre.c src/main/c/serveurArbitre.h Ref/validation.h Ref/protocolYokai.h)

## Linking executables and libs
target_link_libraries(joueur SCS-Lib)
target_link_libraries(serveurArbitre SCS-Lib)