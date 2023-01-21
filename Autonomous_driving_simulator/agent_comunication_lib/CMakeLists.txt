cmake_minimum_required(VERSION 3.5)
project(comunication_lib)

set(CMAKE_CXX_STANDARD 11)

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
        add_custom_target(
                interfaces
                COMMAND nmake -f make.win
                WORKING_DIRECTORY ../interfaces/src
        )
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
            add_custom_target(matlab_sfunctions)
            add_custom_command(TARGET matlab_sfunctions
                    POST_BUILD
                    COMMAND matlab -nodisplay -nosplash -nodesktop -r "run('../interfaces/src/matlab_coder.m');quit"
                    )
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
    set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} ${ARCHFLAG}")
    set(CMAKE_MODULE_LINKER_FLAGS "${CMAKE_MODULE_LINKER_FLAGS} ${ARCHFLAG}")
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${ARCHFLAG}")

    if (${ARCHITECTURE_OUT} MATCHES 32)
        set(CMAKE_OSX_ARCHITECTURES i386)
    endif ()
    if (${ARCHITECTURE_OUT} MATCHES 64)
        message(STATUS "Compiling for MacOS x86_64")
        set(CMAKE_OSX_ARCHITECTURES x86_64)
    endif ()
    if (${ARCHITECTURE_OUT} MATCHES arm)
        message(STATUS "Compiling for MacOS amr64")
        set(CMAKE_OSX_ARCHITECTURES arm64)
    endif ()
    add_custom_target(
            interfaces
            COMMAND make
            WORKING_DIRECTORY ../interfaces/src
    )

endif ()
#------------------------------------------------------------------------------------

# ----------------------------------- LINUX -----------------------------------------
if (UNIX AND NOT APPLE)
    set(OS_FOLDER "Linux")
    message(STATUS "Compilation via Linux")
    set(CMAKE_C_COMPILER /usr/bin/clang)
    set(CMAKE_CXX_COMPILER /usr/bin/clang++)
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
    add_custom_target(
            interfaces
            COMMAND make
            WORKING_DIRECTORY ../interfaces/src
    )
    add_definitions(-O2 ${ARCHFLAG})
endif ()
#------------------------------------------------------------------------------------

include_directories(
        interfaces/out/c++_interfaces
        interfaces/out/struct_printer_functions

        test_server_agent/matlab
        test_server_agent/matlab/codegen/lib/primitives

        lib
        log
)

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


if (EXISTS ../interfaces/out/)
    # ------------------------------- basic agent ------------------------------------
    add_executable(agent_server_test
            log/screen_print.c

            lib/agent_lib.c
            lib/udp_functions.c

            test_server_agent/fake_agent_comunication_test.cc
            )


    target_link_libraries(agent_server_test ${lib_ws32})

    target_compile_options(agent_server_test
            PUBLIC -DNOT_INLINED -DSERVER
            )

    set_target_properties(agent_server_test PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${AGENT_FOLDER})
    # ------------------------------------------------------------------------------------


    # ---------------------------- static agent public lib ---------------------------
    add_library(agent_lib_static STATIC

            lib/agent_lib.cc

            log/screen_print.c

            lib/udp_functions.c

            )

    target_compile_options(agent_lib_static
            PUBLIC -DNOT_INLINED -DREMOTELIB
            )

    target_link_libraries(agent_lib_static ${lib_ws32})

    set_target_properties(agent_lib_static PROPERTIES OUTPUT_NAME "agent_lib")
    set_target_properties(agent_lib_static PROPERTIES ARCHIVE_OUTPUT_DIRECTORY ${STATIC_LIB_FOLDER})
    # ----------------------------------- test -------------------------------------------
    add_executable(agent_static_test
            test_client_env/fake_env_for_agent_test.cc
            log/screen_print.c
            )

    target_link_libraries(agent_static_test agent_lib_static ${lib_ws32})

    target_compile_options(agent_static_test
            PUBLIC
            )

    set_target_properties(agent_static_test PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${TEST_STATIC_LIB_FOLDER})
    # ---------------------------- agent public lib -----------------------------------

    # ---------------------------- dynamic agent public lib ---------------------------
    add_library(agent_lib_shared SHARED

            lib/agent_lib.cc

            log/screen_print.c

            lib/udp_functions.c

            )

    target_compile_options(agent_lib_shared
            PUBLIC ${WIN_DLL_EXPORT} -DNOT_INLINED -DREMOTELIB
            )

    target_link_libraries(agent_lib_shared ${lib_ws32})

    set_target_properties(agent_lib_shared PROPERTIES OUTPUT_NAME "agent_lib")
    set_target_properties(agent_lib_shared PROPERTIES LIBRARY_OUTPUT_DIRECTORY ${SHARED_LIB_FOLDER})
    #Windows FIX
    set_target_properties(agent_lib_shared PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${SHARED_LIB_FOLDER})
    #Windows FIX
    # ----------------------------------- test -------------------------------------------
    add_executable(agent_shared_test
            test_client_env/fake_env_for_agent_test.cc
            log/screen_print.c
            )


    target_link_libraries(agent_shared_test agent_lib_shared ${lib_ws32})

    target_compile_options(agent_shared_test
            PUBLIC ${WIN_DLL_IMPORT}
            )

    set_target_properties(agent_shared_test PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${TEST_SHARED_LIB_FOLDER})
    # ---------------------------- agent public lib -----------------------------------


    # ----------------------------------- all test ---------------------------------------
    add_custom_target(all_targets)
    add_dependencies(all_targets
            agent_server_test agent_static_test
            agent_lib_shared agent_shared_test
            )

    add_custom_command(
            TARGET all_targets
            POST_BUILD

            COMMAND ${CMAKE_COMMAND} -E touch ../${VERSION_AGENT}.version
    )
    # ------------------------------------------------------------------------------------

endif ()
