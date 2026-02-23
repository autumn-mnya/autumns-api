cmake_minimum_required(VERSION 3.16)
project(autpi LANGUAGES C CXX)

set(CMAKE_C_STANDARD 99)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(SRC_PATH ${CMAKE_SOURCE_DIR}/src)
set(COMMON_PATH ${CMAKE_SOURCE_DIR}/../common)

file(GLOB_RECURSE SRC_FILES CONFIGURE_DEPENDS
    ${SRC_PATH}/*.cpp
)

file(GLOB_RECURSE COMMON_FILES CONFIGURE_DEPENDS
    ${COMMON_PATH}/*.cpp
    ${COMMON_PATH}/*.c
)

add_subdirectory(external/lua)

add_library(autpi SHARED
    ${SRC_FILES}
    ${COMMON_FILES}
)

target_include_directories(autpi PRIVATE
    ${SRC_PATH}
    ${COMMON_PATH}
)
target_link_libraries(autpi PRIVATE lua_static)

if(MINGW)
    target_compile_options(autpi PRIVATE -static -static-libgcc -static-libstdc++)
    target_link_options(autpi PRIVATE -static -static-libgcc -static-libstdc++)
endif()

set_target_properties(autpi PROPERTIES
    OUTPUT_NAME "autpi"
    PREFIX ""
    RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin
)