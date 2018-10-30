## # vcpkg_determine_compiler_and_linker
##
function(vcpkg_determine_compiler_and_linker)
    set(DUMMY_DIR ${VCPKG_ROOT_DIR}/scripts/dummy/)
    set(COMPILER_INFO_FILE ${VCPKG_ROOT_DIR}/scripts/dummy/compiler_linker_info.txt)
    file(REMOVE_RECURSE ${DUMMY_DIR}/build)

    if(EXISTS ${COMPILER_INFO_FILE})
        FILE(READ ${COMPILER_INFO_FILE} COMPILER_INFO)
        STRING(REGEX MATCH "${VCPKG_PLATFORM_TOOLSET}" TEST1 ${COMPILER_INFO}) 
        if(${VCPKG_VISUAL_STUDIO_PATH})
            STRING(REGEX MATCH "${VCPKG_VISUAL_STUDIO_PATH}" TEST2 ${COMPILER_INFO}) 
        else()
            set(TEST2 "TRUE")
        endif()
        STRING(REGEX MATCH "${TARGET_TRIPLET}" TEST3 ${COMPILER_INFO}) 
        STRING(REGEX MATCH "${VCPKG_CMAKE_VS_GENERATOR}" TEST4 ${COMPILER_INFO})
    endif()

    if(NOT TEST1 AND NOT TEST2 AND NOT TEST3 AND NOT TEST4)
        vcpkg_execute_required_process(COMMAND  cmake -G ${VCPKG_CMAKE_VS_GENERATOR} -T ${VCPKG_PLATFORM_TOOLSET} -S ./ -B build/
                                    -DVCPKG_CMAKE_VS_GENERATOR=${VCPKG_CMAKE_VS_GENERATOR}
                                    -DVCPKG_PLATFORM_TOOLSET=${VCPKG_PLATFORM_TOOLSET}
                                    -DVCPKG_VISUAL_STUDIO_PATH=${VCPKG_VISUAL_STUDIO_PATH}
                                    -DTARGET_TRIPLET=${TARGET_TRIPLET}
                                    WORKING_DIRECTORY ${DUMMY_DIR}
                                    LOGNAME compiler_discovery.log) 
        FILE(READ ${COMPILER_INFO_FILE} COMPILER_INFO)
    endif()

    STRING(REGEX MATCH "VCPKG_C_COMPILER=([A-Z]:[A-Za-z0-9_ |\\|\.|-]+)" VCPKG_C_COMPILER ${COMPILER_INFO}) 
    STRING(REGEX MATCH "VCPKG_CXX_COMPILER=([A-Z]:[A-Za-z0-9_ |\\|\.|-]+)" VCPKG_CXX_COMPILER ${COMPILER_INFO}) 
    STRING(REGEX MATCH "VCPKG_LINKER=([A-Z]:[A-Za-z0-9_ |\\|\.|-]+)" VCPKG_LINKER ${COMPILER_INFO}) 
    STRING(REPLACE "VCPKG_C_COMPILER=" "" VCPKG_C_COMPILER ${VCPKG_C_COMPILER}) 
    STRING(REPLACE "VCPKG_CXX_COMPILER=" "" VCPKG_CXX_COMPILER ${VCPKG_CXX_COMPILER}) 
    STRING(REPLACE "VCPKG_LINKER=" "" VCPKG_LINKER ${VCPKG_LINKER}) 

    #message(STATUS "Using C Compiler:${VCPKG_C_COMPILER}")
    #message(STATUS "Using CXX Compiler:${VCPKG_CXX_COMPILER}")
    #message(STATUS "Using Linker:${VCPKG_LINKER}")

    set(VCPKG_C_COMPILER ${VCPKG_C_COMPILER} PARENT_SCOPE)
    set(VCPKG_CXX_COMPILER ${VCPKG_CXX_COMPILER} PARENT_SCOPE)
    set(VCPKG_LINKER ${VCPKG_LINKER} PARENT_SCOPE) #//ERROR: Could not find proper second linker member
endfunction()

