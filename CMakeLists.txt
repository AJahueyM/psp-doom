cmake_minimum_required(VERSION 3.5)
project(psp_doom)

set(CMAKE_CXX_STANDARD_REQUIRED 23)

file(GLOB_RECURSE DOOM_SRC src/**/*.c src/*.c)
add_executable(${PROJECT_NAME} ${DOOM_SRC})
include(FindPkgConfig)

pkg_search_module(SDL2 REQUIRED sdl2)
pkg_search_module(SDL2_MIXER REQUIRED SDL2_mixer)

target_link_libraries(${PROJECT_NAME} ${SDL2_LIBRARIES} ${SDL2_MIXER_LIBRARIES} png z)
target_include_directories(${PROJECT_NAME} PRIVATE ${SDL2_INCLUDE_DIRS} ${SDL2_MIXER_INCLUDE_DIRS} src/opl src/textscreen src/pcsound src)
target_compile_options(${PROJECT_NAME} PRIVATE -Wno-incompatible-pointer-types)

# Create an EBOOT.PBP file
create_pbp_file(
    TARGET ${PROJECT_NAME}
    ICON_PATH NULL
    BACKGROUND_PATH NULL
    PREVIEW_PATH NULL
    TITLE ${PROJECT_NAME}
    VERSION 01.00
)