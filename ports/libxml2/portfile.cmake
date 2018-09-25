include(vcpkg_common_functions)
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/libxml2-2.9.8)
vcpkg_download_distfile(ARCHIVE
    URLS "ftp://xmlsoft.org/libxml2/libxml2-2.9.8.tar.gz" "http://xmlsoft.org/sources/libxml2-2.9.8.tar.gz"
    FILENAME "libxml2-2.9.8.tar.gz"
    SHA512 28903282c7672206effa1362fd564cbe4cf5be44264b083a7d14e383f73bccd1b81bcafb5f4f2f56f5e7e05914c660e27668c9ce91b1b9f256ef5358d55ba917   
)
vcpkg_extract_source_archive(${ARCHIVE})

file(COPY ${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt DESTINATION ${SOURCE_PATH})

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS -DPORT_DIR=${CMAKE_CURRENT_LIST_DIR}
    OPTIONS_DEBUG -DINSTALL_HEADERS=OFF
)

vcpkg_install_cmake()

# Handle copyright
file(COPY ${CMAKE_CURRENT_LIST_DIR}/usage ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/libxml2)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/libxml2/COPYING ${CURRENT_PACKAGES_DIR}/share/libxml2/copyright)

vcpkg_copy_pdbs()

if(VCPKG_LIBRARY_LINKAGE STREQUAL "static")
    file(COPY ${CMAKE_CURRENT_LIST_DIR}/vcpkg-cmake-wrapper.cmake DESTINATION ${CURRENT_PACKAGES_DIR}/share/libxml2)
endif()
