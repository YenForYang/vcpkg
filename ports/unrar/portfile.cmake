include(vcpkg_common_functions)
set(UNRAR_VERSION "5.6.6")
set(UNRAR_SHA512 1e1e9dc2ed104ab7819d11ad2249780a4320cb30f3c427ea1669c3769fa3a8369841711a2d46d918049659bc67b2cd7dc7560a12127d810a57614293c24fe25a)
set(UNRAR_FILENAME unrarsrc-${UNRAR_VERSION}.tar.gz)
set(UNRAR_URL http://www.rarlab.com/rar/${UNRAR_FILENAME})
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/unrar)

if (VCPKG_LIBRARY_LINKAGE STREQUAL "static")
    message(STATUS "Unrar buildsystem doesn't support static building. Building dynamic instead.")
    set(VCPKG_LIBRARY_LINKAGE dynamic)
endif()

#SRC
vcpkg_download_distfile(ARCHIVE
    URLS ${UNRAR_URL}
    FILENAME ${UNRAR_FILENAME}
    SHA512 ${UNRAR_SHA512}
)
vcpkg_extract_source_archive(${ARCHIVE})

vcpkg_build_msbuild(
    PROJECT_PATH "${SOURCE_PATH}/UnRARDll.vcxproj"
    OPTIONS_DEBUG /p:OutDir=../../${TARGET_TRIPLET}-dbg/
    OPTIONS_RELEASE /p:OutDir=../../${TARGET_TRIPLET}-rel/
    OPTIONS /VERBOSITY:Diagnostic /DETAILEDSUMMARY
)

#INCLUDE (named dll.hpp in source, and unrar.h in all rarlabs distributions)
file(INSTALL ${SOURCE_PATH}/dll.hpp DESTINATION ${CURRENT_PACKAGES_DIR}/include RENAME unrar.h)

#DLL & LIB
file(INSTALL ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel/unrar.dll  DESTINATION ${CURRENT_PACKAGES_DIR}/bin)
file(INSTALL ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel/unrar.lib  DESTINATION ${CURRENT_PACKAGES_DIR}/lib)
file(INSTALL ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg/unrar.dll  DESTINATION ${CURRENT_PACKAGES_DIR}/debug/bin)
file(INSTALL ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg/unrar.lib  DESTINATION ${CURRENT_PACKAGES_DIR}/debug/lib)

vcpkg_copy_pdbs()

#COPYRIGHT
file(INSTALL ${SOURCE_PATH}/LICENSE.txt DESTINATION ${CURRENT_PACKAGES_DIR}/share/unrar RENAME copyright)
