cmake_minimum_required(VERSION 3.16)
project(autpi LANGUAGES C CXX)

option(MODCS_LUAJIT "Use LuaJIT for ModCS Lua API instead of Lua 5.4.6 (Default ON)" ON)

set(CMAKE_C_STANDARD 99)
set(CMAKE_CXX_STANDARD 11)
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

add_subdirectory("external/yaml-cpp")

add_library(autpi SHARED
    ${SRC_FILES}
    ${COMMON_FILES}
)

target_include_directories(autpi PRIVATE
    ${SRC_PATH}
    ${COMMON_PATH}
)

if (MODCS_LUAJIT)
	set(LUAJIT_DIR ${CMAKE_CURRENT_SOURCE_DIR}/external/luajit)
	set(CMAKE_POLICY_DEFAULT_CMP0077 NEW)
	add_subdirectory("external/luajit-cmake")
	target_link_libraries(autpi PRIVATE luajit::lib luajit::header)
else()
    add_subdirectory(external/lua)
    target_link_libraries(autpi PRIVATE lua_static)
endif()

target_link_libraries(autpi PRIVATE yaml-cpp::yaml-cpp)

if(MINGW)
    target_compile_options(autpi PRIVATE -static -static-libgcc -static-libstdc++)
    target_link_options(autpi PRIVATE -static -static-libgcc -static-libstdc++)
endif()

set_target_properties(autpi PROPERTIES
    OUTPUT_NAME "autpi"
    PREFIX ""
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/CaveStory/mods/autpi"
    RUNTIME_OUTPUT_DIRECTORY_DEBUG "${CMAKE_CURRENT_SOURCE_DIR}/CaveStory/mods/autpi"
    RUNTIME_OUTPUT_DIRECTORY_RELEASE "${CMAKE_CURRENT_SOURCE_DIR}/CaveStory/mods/autpi"
    RUNTIME_OUTPUT_DIRECTORY_RELWITHDEBINFO "${CMAKE_CURRENT_SOURCE_DIR}/CaveStory/mods/autpi"
)
