# -------------------------- Configuration compile options -------------------------
set(LOG_INTERNAL ON)

if (UNIX)
    # Architecures this parameter works on Mac and Linux only
    # On windows use Settings > Build, Execution, Deployment > Toolchain:
    # - 32 for 32-bit target
    # - 64 for 64-bit target
    # - arm for arm64 macos silicon
    set(ARCHITECTURE_OUT arm)

    if (${CMAKE_HOST_SYSTEM_PROCESSOR} MATCHES "arm64")
        if (${ARCHITECTURE_OUT} MATCHES 32)
            message(FATAL_ERROR "Architecture is not supported by the host")
        endif ()
    endif ()

    if (NOT ${CMAKE_SIZEOF_VOID_P} EQUAL "8")
        if (NOT ${ARCHITECTURE_OUT} MATCHES 32)
            message(FATAL_ERROR "Architecture is not supported by the host")
        endif ()
    endif ()
endif ()
# ----------------------------------------------------------------------------------


set(OUT_MAIN_DIR_RELEASE bin)
set(OUT_MAIN_DIR_DEBUG bin_dbg)

if (CMAKE_BUILD_TYPE STREQUAL "Debug")
    set(OUT_MAIN_DIR ${OUT_MAIN_DIR_DEBUG})
else ()
    set(OUT_MAIN_DIR ${OUT_MAIN_DIR_RELEASE})
endif ()

set(MAIN_DIR ${OUT_MAIN_DIR})
set(BIN_DIR bin)

set(CLIENT_TEST test_agent)

set(UP_ONE_LEVEL_CMAKE ..)
#------------------------------------------------------------------------------------

# --------------------------- FOLDER PRUBLIC ----------------------------------------
set(PUB_FOLDER ${MAIN_DIR})

set(TEST_AGENT ${UP_ONE_LEVEL_CMAKE}/${BIN_DIR}/${CLIENT_TEST})

set(AGENT_FOLDER ${UP_ONE_LEVEL_CMAKE}/${BIN_DIR})

set(SHARED_LIB_FOLDER ${UP_ONE_LEVEL_CMAKE}/${BIN_DIR}/lib)
set(TEST_SHARED_LIB_FOLDER ${SHARED_LIB_FOLDER}/${CLIENT_TEST})

set(STATIC_LIB_FOLDER ${UP_ONE_LEVEL_CMAKE}/${BIN_DIR}/lib_static)
set(TEST_STATIC_LIB_FOLDER ${STATIC_LIB_FOLDER}/${CLIENT_TEST})

# ---------------------------------- VERSION ----------------------------------------
set(VERSION_AGENT v1.0.0)
file(WRITE "${VERSION_AGENT}.version" "")

# ---------------------------------- WINDOWS ----------------------------------------
if (WIN32)
    if (CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
        set(OS_FOLDER "Windows")
        message(STATUS "Compilation via Windows Visual Studio")
        set(CMAKE_C_COMPILER cl)
        set(CMAKE_CXX_COMPILER cl)
        set(WIN_DLL_EXPORT -DDLL_EXPORT=1)
        set(WIN_DLL_IMPORT -DDLL_IMPORT=1)
        set(lib_lightmat liblm)
        add_definitions(/EHsc /MT)
        set(CompilerFlags
                CMAKE_CXX_FLAGS
                CMAKE_CXX_FLAGS_DEBUG
                CMAKE_CXX_FLAGS_RELEASE
                CMAKE_C_FLAGS
                CMAKE_C_FLAGS_DEBUG
                CMAKE_C_FLAGS_RELEASE
                )
        foreach (CompilerFlag ${CompilerFlags})
            string(REPLACE "/MD" "/MT" ${CompilerFlag} "${${CompilerFlag}}")
            string(REPLACE "/MDd" "/MTd" ${CompilerFlag} "${${CompilerFlag}}")
        endforeach ()

        if (${CMAKE_SIZEOF_VOID_P} EQUAL "8")
            message(STATUS "Compiling for Windows 64 bits")
            set(ARCHITECTURE_OUT 64)
        endif ()
        if (${CMAKE_SIZEOF_VOID_P} EQUAL "4")
            message(STATUS "Compiling for Windows 32 bits")
            set(ARCHITECTURE_OUT 32)
        endif ()
    else ()
        set(OS_FOLDER "WinMinGW")
        message(STATUS "Compilation via Windows MingGW")
        set(CMAKE_C_COMPILER clang)
        set(CMAKE_CXX_COMPILER clang++)
        set(lib_lightmat lm)
        set(lib_ws32 ws2_32)
        set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} ${ARCHFLAG}")
        set(CMAKE_MODULE_LINKER_FLAGS "${CMAKE_MODULE_LINKER_FLAGS} ${ARCHFLAG}")
        set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${ARCHFLAG}")
        set(ARCHITECTURE_OUT 64)
        add_definitions(-O2 ${ARCHFLAG})
    endif ()
endif ()
#------------------------------------------------------------------------------------

# ----------------------------------- APPLE -----------------------------------------
if (APPLE)
    set(OS_FOLDER "Darwin")
    message(STATUS "Compilation via MacOS")
    set(CMAKE_C_COMPILER /usr/bin/clang)
    set(CMAKE_CXX_COMPILER /usr/bin/clang++)
    set(lib_lightmat lm)
    set(name_libnet mxnet)
    set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} ${ARCHFLAG}")
    set(CMAKE_MODULE_LINKER_FLAGS "${CMAKE_MODULE_LINKER_FLAGS} ${ARCHFLAG}")
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${ARCHFLAG}")
endif ()
#------------------------------------------------------------------------------------

# ----------------------------------- LINUX -----------------------------------------
if (UNIX AND NOT APPLE)
    set(OS_FOLDER "Linux")
    message(STATUS "Compilation via Linux")
    set(CMAKE_C_COMPILER /usr/bin/clang)
    set(CMAKE_CXX_COMPILER /usr/bin/clang++)
    set(lib_lightmat lm)
    set(name_libnet mxnet)
    if (${ARCHITECTURE_OUT} MATCHES 32)
        message(STATUS "Compiling for Linux 32 bits")
        set(ARCHFLAG -m32)
    endif ()
    if (${ARCHITECTURE_OUT} MATCHES 64)
        message(STATUS "Compiling for Linux 64 bits")
        set(ARCHFLAG -m64)
    endif ()
    set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} ${ARCHFLAG}")
    set(CMAKE_MODULE_LINKER_FLAGS "${CMAKE_MODULE_LINKER_FLAGS} ${ARCHFLAG}")
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${ARCHFLAG}")
    add_definitions(-O2 ${ARCHFLAG})
endif ()
#------------------------------------------------------------------------------------

if (${ARCHITECTURE_OUT} MATCHES 32)
    set(PROJECT_ARCHITECTURE "x86")
endif ()
if (${ARCHITECTURE_OUT} MATCHES 64)
    set(PROJECT_ARCHITECTURE "x64")
endif ()
if (${ARCHITECTURE_OUT} MATCHES arm)
    set(PROJECT_ARCHITECTURE "arm64")
endif ()

if (LOG_INTERNAL)
    add_definitions(-DLOG_INTERNAL)
    set(
            src_loginternal
            log/logvars.cc
            log/mathcode_log.cc
    )
endif ()

if (CMAKE_BUILD_TYPE STREQUAL "Debug")
    add_definitions(-DDEBUG)
    set(OS_TYPE_FOLDER ${OS_FOLDER}_debug)
else ()
    set(OS_TYPE_FOLDER ${OS_FOLDER})
endif ()
