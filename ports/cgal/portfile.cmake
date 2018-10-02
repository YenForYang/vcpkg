include(vcpkg_common_functions)

set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/CGAL-4.13)
vcpkg_download_distfile(ARCHIVE
    URLS 
"https://github.com/CGAL/cgal/releases/download/releases%2FCGAL-4.13/CGAL-4.13.zip"
    FILENAME "CGAL-4.13.zip"
    SHA512 f6d3477cf049272984d8d6d283a8b21413d87066f6c2a4b481abae58e35d7890ed22e4f8093a7a6f42c0728a9a3b4272d1bfbb9b72fa2811767372bf9d483f05)
    
vcpkg_extract_source_archive(${ARCHIVE})

set(WITH_CGAL_Qt5  OFF)
if("qt" IN_LIST FEATURES)
  set(WITH_CGAL_Qt5 ON)
endif()

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        -DCGAL_INSTALL_CMAKE_DIR=share/cgal
        -DWITH_CGAL_Qt5==${WITH_CGAL_Qt5}
)

vcpkg_install_cmake()

vcpkg_fixup_cmake_targets()

vcpkg_copy_pdbs()

# Clean
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)

file(READ ${CURRENT_PACKAGES_DIR}/share/cgal/CGALConfig.cmake _contents)
string(REPLACE "CGAL_IGNORE_PRECONFIGURED_GMP" "1" _contents "${_contents}")
string(REPLACE "CGAL_IGNORE_PRECONFIGURED_MPFR" "1" _contents "${_contents}")
file(WRITE ${CURRENT_PACKAGES_DIR}/lib/cgal/CGALConfig.cmake "${_contents}")
file(COPY ${CURRENT_BUILDTREES_DIR}/src/CGAL-4.13/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/cgal)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/cgal/LICENSE ${CURRENT_PACKAGES_DIR}/share/cgal/copyright)
file(COPY ${SOURCE_PATH}/LICENSE.BSL DESTINATION ${CURRENT_PACKAGES_DIR}/share/cgal)
file(COPY ${SOURCE_PATH}/LICENSE.FREE_USE DESTINATION ${CURRENT_PACKAGES_DIR}/share/cgal)
file(COPY ${SOURCE_PATH}/LICENSE.GPL DESTINATION ${CURRENT_PACKAGES_DIR}/share/cgal)
file(COPY ${SOURCE_PATH}/LICENSE.LGPL DESTINATION ${CURRENT_PACKAGES_DIR}/share/cgal)

# Handle copyright of suitesparse and metis
#file(COPY ${SOURCE_PATH}/copyright DESTINATION ${CURRENT_PACKAGES_DIR}/share/cgal)
