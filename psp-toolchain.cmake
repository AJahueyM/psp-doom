set(CMAKE_SYSTEM_NAME psp)
set(CMAKE_SYSTEM_PROCESSOR mips32)
set(CMAKE_TRY_COMPILE_TARGET_TYPE "STATIC_LIBRARY")

execute_process(COMMAND psp-config -d OUTPUT_VARIABLE PSPDEV OUTPUT_STRIP_TRAILING_WHITESPACE)
execute_process(COMMAND psp-config -p OUTPUT_VARIABLE PSPSDK OUTPUT_STRIP_TRAILING_WHITESPACE)
execute_process(COMMAND psp-config -P OUTPUT_VARIABLE PSPPREFIX OUTPUT_STRIP_TRAILING_WHITESPACE)



set(CMAKE_C_FLAGS_INIT "-Wl,-zmax-page-size=128 -O0 -g3 -Wall -D_PSP_FW_VERSION=150 -L${PSPSDK}/lib -L${PSPSDK}")
set(CMAKE_CXX_FLAGS_INIT ${CMAKE_C_FLAGS_INIT})

set(CMAKE_ASM_COMPILER ${PSPDEV}/bin/psp-as)
set(CMAKE_C_COMPILER ${PSPDEV}/bin/psp-gcc)
set(CMAKE_CXX_COMPILER ${PSPDEV}/bin/psp-g++)

set(CMAKE_C_STANDARD_INCLUDE_DIRECTORIES ${PSPSDK}/include)
set(CMAKE_CXX_STANDARD_INCLUDE_DIRECTORIES ${PSPSDK}/include)

set(CMAKE_C_STANDARD_LIBRARIES "-lpspdebug -lpspdisplay -lpspge -lpspctrl -lpspsdk -lpspnet -lpspnet_apctl")
set(CMAKE_CXX_STANDARD_LIBRARIES ${CMAKE_C_STANDARD_LIBRARIES})
add_definitions(-DPSP)

function(psp_eboot_build TARGET_NAME)
    # TODO: Implement all the functionality of the Makefile given in the SDK (Change Icon, name, etc, etc)
    add_custom_command(
            TARGET ${TARGET_NAME}
            POST_BUILD
            COMMAND mkdir -p EBOOT.PBP && cd EBOOT.PBP && psp-fixup-imports ../${TARGET_NAME} &&
            mksfo 'XMB_TITLE' PARAM.SFO &&
            psp-strip ../${TARGET_NAME} -o strip_eboot.elf &&
            pack-pbp EBOOT.PBP PARAM.SFO NULL NULL NULL NULL NULL strip_eboot.elf NULL
    )

endfunction()

function(psp_run_emulation ${TARGET_NAME})
    add_custom_target(
            run_emulation
            COMMAND ./$ENV{PPSSPP}/PPSSPP ${CMAKE_BUILD_RPATH}/EBOOT.PBP/EBOOT.PBP
            COMMENT "Run emulation of built PSP program"
            DEPENDS ${TARGET_NAME}
    )
endfunction()