# Originally written by Nathan Brink <ohnobinki@ohnopublishing.net>
# This is to assist with cross-compilation of win32 stuff (like sdl-image) into /usr/mingw32

PKG_CONFIG_SYSROOT_DIR="${ROOT}"
PKG_CONFIG_LIBDIR="${ROOT}/usr/lib/pkgconfig"
export PKG_CONFIG_SYSROOT_DIR
export PKG_CONFIG_LIBDIR
