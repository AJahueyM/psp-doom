cmake_minimum_required(VERSION 3.0)
project(psp_doom)

set(CMAKE_CXX_STANDARD_REQUIRED 23)

file(GLOB_RECURSE DOOM_SRC src/**/*.c src/*.c)
add_executable(${CMAKE_PROJECT_NAME} ${DOOM_SRC})

target_link_libraries(${CMAKE_PROJECT_NAME} SDL2_mixer SDL2 GL vorbisfile vorbis ogg pspaudio pspgu pspvfpu pspvram psphprm png z)

include_directories(${PSPPREFIX}/include/SDL2 src/opl src/textscreen src/pcsound src)

psp_eboot_build(${CMAKE_PROJECT_NAME})
psp_run_emulation(${CMAKE_PROJECT_NAME})
