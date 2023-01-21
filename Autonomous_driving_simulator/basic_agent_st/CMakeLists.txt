cmake_minimum_required(VERSION 3.5)
project(basic_agent_ST)

set(CMAKE_CXX_STANDARD 11)

include(lib/basic.cmake)

include_directories(
        matlab/codegen/lib/primitives/
        matlab/
        lib
        log
        Clothoids/lib/include
        Clothoids/lib3rd/include
)

link_directories(
        lib
)

# ------------------------------- basic agent ------------------------------------
add_executable(basic_agent
        matlab/codegen/lib/primitives/rt_nonfinite.cpp
        matlab/codegen/lib/primitives/primitives.cpp
        log/screen_print.c
        log/logvars.cc
        strarting_point.cc
)


target_link_libraries(basic_agent agent_lib ${lib_ws32})
target_link_libraries(basic_agent libClothoids_linux.so ${lib_ws32})
target_link_libraries(basic_agent libquarticRootsFlocke_linux.so ${lib_ws32})
target_link_libraries(basic_agent libUtils_linux.so ${lib_ws32})

target_compile_options(basic_agent
        PUBLIC -DNOT_INLINED -DSERVER
        )

set_target_properties(basic_agent PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${AGENT_FOLDER})
# ------------------------------------------------------------------------------------