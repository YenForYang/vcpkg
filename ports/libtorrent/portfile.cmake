include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO arvidn/libtorrent
    REF libtorrent-1_1_9
    SHA512 8c313c757603a4b2035c69fbe745c1e3483359b7b21601f9353338acc00e15953b4414ea4adf93647e1f2f9e1da72df165cede9dbdcaf57c12833529a43b3fc7 # 1_1_9
    # SHA512 95479ff0cbce299edccaaeb435c31b07c05f45e319f3480645d2ae45a9bdc01866edb1329426c6835a7c0cba2d6347254f5f023009ff78405b813c131b78addb # 1_1_7
    # SHA512 0db79b60093fc771d3fb0a2df7d420ae874da0e5c0968e4cc28052c999ed259f339d4e8b271923a0dc71ec1433d50ad5b680d873ea3dbfa17e663e265c02975b # 1_1_8
    HEAD_REF master
)

vcpkg_apply_patches(
    SOURCE_PATH ${SOURCE_PATH}
    PATCHES
        ${CMAKE_CURRENT_LIST_DIR}/add-datetime-to-boost-libs.patch
        ${CMAKE_CURRENT_LIST_DIR}/boost-167.patch
)

string(COMPARE EQUAL "${VCPKG_LIBRARY_LINKAGE}" "dynamic" LIBTORRENT_SHARED)

file(READ "${SOURCE_PATH}/include/libtorrent/export.hpp" _contents)
string(REPLACE "<boost/config/select_compiler_config.hpp>" "<boost/config/detail/select_compiler_config.hpp>" _contents "${_contents}")
string(REPLACE "<boost/config/select_platform_config.hpp>" "<boost/config/detail/select_platform_config.hpp>" _contents "${_contents}")
file(WRITE "${SOURCE_PATH}/include/libtorrent/export.hpp" "${_contents}")

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA # Disable this option if project cannot be built with Ninja
    OPTIONS
        -Dshared=${LIBTORRENT_SHARED}
        -Ddeprecated-functions=off
)

vcpkg_install_cmake()

if (VCPKG_LIBRARY_LINKAGE STREQUAL "dynamic")
    # Put shared libraries into the proper directory
    file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/bin)
    file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/debug/bin)

    file(RENAME ${CURRENT_PACKAGES_DIR}/lib/torrent-rasterbar.dll ${CURRENT_PACKAGES_DIR}/bin/torrent-rasterbar.dll)
    file(RENAME ${CURRENT_PACKAGES_DIR}/debug/lib/torrent-rasterbar.dll ${CURRENT_PACKAGES_DIR}/debug/bin/torrent-rasterbar.dll)

    # Defines for shared lib
    file(READ ${CURRENT_PACKAGES_DIR}/include/libtorrent/export.hpp EXPORT_H)
    string(REPLACE "defined TORRENT_BUILDING_SHARED" "1" EXPORT_H "${EXPORT_H}")
    file(WRITE ${CURRENT_PACKAGES_DIR}/include/libtorrent/export.hpp "${EXPORT_H}")
endif()

# Handle copyright
file(COPY ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/libtorrent)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/libtorrent/LICENSE ${CURRENT_PACKAGES_DIR}/share/libtorrent/copyright)

# Do not duplicate include files
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)