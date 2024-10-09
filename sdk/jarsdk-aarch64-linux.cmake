if(DEFINED ENV{SDK_ROOT})
    set(SDK_ROOT "$ENV{SDK_ROOT}")
else()
    set(SDK_ROOT "${CMAKE_CURRENT_LIST_DIR}/aarch64")
endif()

set(TARGET_SYSROOT "${SDK_ROOT}/sysroots/cortexa7t2hf-neon-vfpv4-jarvis-linux-gnueabi")
set(NATIVE_SYSROOT "${SDK_ROOT}/sysroots/x86_64-jarsdk-linux")

set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSROOT ${TARGET_SYSROOT})

set(CMAKE_FIND_ROOT_PATH ${TARGET_SYSROOT})
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

set(NATIVE_PREFIX "${NATIVE_SYSROOT}/usr/bin/arm-jarvis-linux/arm-jarvis-linux-")

set(CMAKE_C_COMPILER
    ${NATIVE_PREFIX}gcc
    CACHE PATH ""
)
set(CMAKE_CXX_COMPILER
    ${NATIVE_PREFIX}g++
    CACHE PATH ""
)
set(CMAKE_LINKER
    ${NATIVE_PREFIX}ld
    CACHE PATH ""
)
set(CMAKE_STRIP
    ${NATIVE_PREFIX}strip
    CACHE PATH ""
)
set(CMAKE_AR
    ${NATIVE_PREFIX}gcc-ar
    CACHE PATH ""
)
set(CMAKE_NM
    ${NATIVE_PREFIX}gcc-nm
    CACHE PATH ""
)
set(CMAKE_OBJCOPY
    ${NATIVE_PREFIX}objcopy
    CACHE PATH ""
)
set(CMAKE_OBJDUMP
    ${NATIVE_PREFIX}objdump
    CACHE PATH ""
)
set(CMAKE_RANLIB
    ${NATIVE_PREFIX}ranlib
    CACHE PATH ""
)

set(CMAKE_C_FLAGS_INIT
    "-mthumb -mfpu=neon-vfpv4 -mfloat-abi=hard -mcpu=cortex-a7 -fstack-protector-strong  -O2 -D_FORTIFY_SOURCE=2 -Wformat -Wformat-security -Werror=format-security -D_TIME_BITS=64 -D_FILE_OFFSET_BITS=64"
    CACHE STRING "" FORCE
)
set(CMAKE_CXX_FLAGS_INIT
    "-mthumb -mfpu=neon-vfpv4 -mfloat-abi=hard -mcpu=cortex-a7 -fstack-protector-strong  -O2 -D_FORTIFY_SOURCE=2 -Wformat -Wformat-security -Werror=format-security -D_TIME_BITS=64 -D_FILE_OFFSET_BITS=64"
    CACHE STRING "" FORCE
)

set(ENV{PKG_CONFIG_SYSROOT_DIR} "${TARGET_SYSROOT}")
set(ENV{PKG_CONFIG_PATH}
    "${TARGET_SYSROOT}/usr/lib/pkgconfig:${TARGET_SYSROOT}/usr/share/pkgconfig"
)
