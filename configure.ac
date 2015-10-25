#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_PREREQ([2.61])
AC_INIT(efup, 0.1, https://github.com/chombourger/efup)
AC_CONFIG_MACRO_DIR([m4])
AC_CONFIG_HEADERS([	\
	external/freetype/builds/unix/ftconfig.h:external/freetype/builds/unix/ftconfig.in \
	external/jpeg/jconfig.h:external/jpeg/jconfig.cfg \
	external/png/config.h:external/png/config.h.in \
	external/directfb/config.h:external/directfb/config.h.in \
	external/e2fsprogs/lib/config.h:external/e2fsprogs/lib/config.h.in \
	external/e2fsprogs/lib/dirpaths.h:external/e2fsprogs/lib/dirpaths.h.in \
	external/util-linux/config.h:external/util-linux/config.h.in \
])

# Default to empty prefix (binaries going to /sbin and /lib)
AC_PREFIX_DEFAULT()

AC_ARG_ENABLE(directfb,
	AC_HELP_STRING(
		[--enable-directfb],
		[enable DirectFB backend @<:@default=no@:>@]
	),
	[],
	[enable_directfb=no]
)

AC_ARG_ENABLE(freetype,
	AC_HELP_STRING(
		[--enable-freetype],
		[enable FreeType2 font provider @<:@default=yes@:>@]
	),
	[],
	[enable_freetype=yes]
)

AC_ARG_ENABLE(jpeg,
	AC_HELP_STRING(
		[--enable-jpeg],
		[build JPEG image provider, @<:@default=no@:>@]
	),
	[],
	[enable_jpeg=no]
)

AC_ARG_ENABLE(png,
	AC_HELP_STRING(
		[--enable-png],
		[build PNG image provider, @<:@default=yes@:>@]
	),
	[],
	[enable_png=yes]
)

# Checks for programs.
AC_PROG_AWK
AC_PROG_CC
AC_PROG_CPP
AC_PROG_CXX
AC_DEFUN([AC_PROG_STRIP], [AC_CHECK_TOOL(STRIP, strip, :)])
AC_PROG_STRIP
AC_PROG_INSTALL
AC_PROG_LN_S
AC_PROG_MAKE_SET
AC_PROG_MKDIR_P
AC_PROG_PERL

AC_CANONICAL_HOST
AC_SUBST(HOST_CPU,$host_cpu)
AC_SUBST(HOST_OS,$host_os)

case x"$target" in
  xNONE | x)
    target_or_host="$host";;
  *)
    target_or_host="$target";;
esac

# Check target architecture
have_x86=no
have_x86_64=no
have_arm=no
have_mips=no
have_ppc=no
have_sh=no
have_sh3=no
have_sh4=no

case "$target_or_host" in
  i*86-*-*)
    have_x86=yes
    AC_DEFINE(ARCH_X86,1,[Define to 1 if you are compiling for ix86.])
    ;;

  x86_64-*)
    have_x86=yes
    have_x86_64=yes
    AC_DEFINE(ARCH_X86_64,1,[Define to 1 if you are compiling for AMD64.])
    ;;

  *arm*)
    have_arm=yes
	AC_DEFINE(ARCH_ARM,1,[Define to 1 if you are compiling for ARM.])
    if test -n "`echo $CFLAGS | grep 'march=armv7\-a'`"; then
      AC_DEFINE(ARCH_ARMv7,1,[Define to 1 if you are compiling for ARMv7.])
    fi
    ;;

  *mips*)
    have_mips=yes
    AC_DEFINE(ARCH_MIPS,1,[Define to 1 if you are compiling for MIPS.])
    ;;

  ppc-*-linux* | powerpc-*)
    have_ppc=yes
    AC_DEFINE(ARCH_PPC,1,[Define to 1 if you are compiling for PowerPC.])
    ;;

  sh3-*)
    have_sh=yes
    have_sh3=yes
    AC_DEFINE(ARCH_SH,1,[Define to 1 if you are compiling for SuperH.])
    AC_DEFINE(ARCH_SH3,1,[Define to 1 if you are compiling for SH3.])
    ;;

  sh4-* | sh-*)
    have_sh=yes
    have_sh4=yes
    AC_DEFINE(ARCH_SH,1,[Define to 1 if you are compiling for SuperH.])
    AC_DEFINE(ARCH_SH4,1,[Define to 1 if you are compiling for SH4.])
    ;;

  *)
    ;;
esac

# See if we need a separate native compiler.
if test $cross_compiling = no; then
  BUILD_CC="$CC"
  AC_SUBST(BUILD_CC)
else
  AC_CHECK_PROGS(BUILD_CC, gcc cc)
fi

# Check for LUA
AC_SUBST([LUA_VERSION],5.2)
AX_LUA_HEADERS(true,true)
AX_LUA_LIBS(true,true)

# Check for NSPR & NSS
AM_PATH_NSPR
AM_PATH_NSS

if test x$enable_directfb = xyes; then
   check_directfb=yes
   if test x$enable_png = xyes; then
      check_png=yes
   fi
   if test x$enable_freetype = xyes; then
      check_freetype=yes
   fi
   if test x$enable_jpeg = xyes; then
      check_jpeg=yes
   fi
fi

# Check for DirectFB
USE_DIRECTFB=
if test x$check_directfb = xyes; then
   DFB_CFLAGS=`pkg-config directfb --cflags 2>/dev/null`
   DFB_LIBS=`pkg-config directfb --libs 2>/dev/null`
   USE_DIRECTFB=yes
fi

# Check for FreeType
USE_FREETYPE=
if test x$check_freetype = xyes; then
   FT_CFLAGS=`pkg-config freetype2 --cflags 2>/dev/null`
   FT_LIBS=`pkg-config freetype2 --libs 2>/dev/null`
   USE_FREETYPE=yes
fi

# Check for JPEG
USE_JPEG=
if test x$check_jpeg = xyes; then
   AC_CHECK_LIB(jpeg, jpeg_destroy_decompress,
      jpeg_ok=yes,
      jpeg_ok=no)
   if test "$jpeg_ok" = yes; then
      AC_CHECK_HEADER(jpeglib.h,
         jpeg_ok=yes,
         jpeg_ok=no)
      if test "$jpeg_ok" = yes; then
         LIBJPEG='-ljpeg'
      fi
   fi
   USE_JPEG=yes
fi

# Check for PNG
USE_PNG=
if test x$check_png = xyes; then
   PNG_CFLAGS=`pkg-config libpng --cflags 2>/dev/null`
   PNG_LIBS=`pkg-config libpng --libs 2>/dev/null`
   USE_PNG=yes
fi

AC_SUBST(DFB_CFLAGS)
AC_SUBST(DFB_LIBS)
AC_SUBST(USE_DIRECTFB,$USE_DIRECTFB)

AC_SUBST(FT_CFLAGS)
AC_SUBST(FT_LIBS)
AC_SUBST(USE_FREETYPE,$USE_FREETYPE)

AC_SUBST(LIBPNG)
AC_SUBST(LIBPNG_CFLAGS)
AC_SUBST(LIBPNG_LIBS)
AC_SUBST(USE_PNG,$USE_PNG)

AC_SUBST(LIBJPEG,$LIBJPEG)
AC_SUBST(USE_JPEG,$USE_JPEG)
AM_CONDITIONAL(JPEG_PROVIDER, test "$USE_JPEG" = "yes")
AC_SUBST(JPEG_PROVIDER)

# Checks for header files.
AC_HEADER_STDC
AC_CHECK_HEADERS([		\
	errno.h			\
	malloc.h		\
	mntent.h		\
	paths.h			\
	signal.h		\
	stdarg.h		\
	stddef.h		\
	stdlib.h		\
	string.h		\
	linux/compiler.h	\
	linux/falloc.h		\
	linux/fd.h		\
	linux/major.h		\
	linux/loop.h		\
	linux/unistd.h		\
	unistd.h		\
	sys/disk.h		\
	sys/disklabel.h		\
	sys/file.h		\
	sys/ioctl.h		\
	sys/mman.h		\
	sys/mount.h		\
	sys/mkdev.h		\
	sys/param.h		\
	sys/prctl.h		\
	sys/resource.h		\
	sys/select.h		\
	sys/socket.h		\
	sys/sockio.h		\
	sys/stat.h		\
	sys/syscall.h		\
	sys/sysmacros.h		\
	sys/time.h		\
	sys/types.h		\
	sys/un.h		\
	sys/wait.h		\
])

AC_CHECK_HEADERS(linux/compiler.h linux/unistd.h asm/page.h signal.h)

# Checks for typedefs, structures, and compiler characteristics.
AC_C_CONST
AC_TYPE_SIZE_T
AC_STRUCT_TM
AC_C_RESTRICT
AC_HEADER_STDBOOL
AC_TYPE_SIZE_T
AC_CHECK_SIZEOF(int)
AC_CHECK_SIZEOF(long)
AC_CHECK_SIZEOF(long long)
AC_C_BIGENDIAN

# Checks for library functions.
AC_FUNC_STRTOD
AC_CHECK_FUNCS([	\
	fsync		\
	getmntent	\
	getmntinfo	\
	llseek		\
	lseek64		\
	memalign	\
	mempcpy		\
	mmap		\
	munmap		\
	nanosleep	\
	setmntent	\
	strcasecmp	\
	sysconf		\
	usleep		\
])
AC_CHECK_FUNCS([memset], , AC_MSG_ERROR(memset not found in libc))
AC_CHECK_FUNCS([pow], , AC_CHECK_LIB(m, pow, , AC_MSG_ERROR(cannot find pow)) )
AC_ARG_WITH(zlib-prefix,
   AS_HELP_STRING([[[--with-zlib-prefix]]],
      [prefix that may have been used in installed zlib]),
      [ZPREFIX=${withval}],
      [ZPREFIX='z_'])
AC_CHECK_LIB(z, zlibVersion, ,
    AC_CHECK_LIB(z, ${ZPREFIX}zlibVersion,[ZLIB=yes],[ZLIB=]))
AC_SUBST(ZLIB_CFLAGS)
AC_SUBST(ZLIB_LIBS)
AC_SUBST(USE_ZLIB,yes)

# Threads
THREADFLAGS="-D_REENTRANT"

if test "$need_libc_r" = "yes"; then
  AC_CHECK_LIB(c_r, pthread_attr_init, ,
    AC_MSG_ERROR([
*** DirectFB requires phtreads in libc_r.]))
  THREADLIB="-lc_r"
else
  AC_CHECK_LIB(pthread, pthread_attr_init, ,
    AC_MSG_ERROR([
*** DirectFB requires libpthread.]))
  THREADLIB="-lpthread"
fi

AC_CHECK_DECLS(PTHREAD_MUTEX_RECURSIVE,,
  AC_MSG_WARN([
*** PTHREAD_MUTEX_RECURSIVE is not defined! Dead locks might occur!]), [
#define _GNU_SOURCE
#include <pthread.h>])

AC_CHECK_DECLS(PTHREAD_RECURSIVE_MUTEX_INITIALIZER_NP,,
  AC_MSG_WARN([
*** PTHREAD_RECURSIVE_MUTEX_INITIALIZER_NP is not defined! Dead locks might occur!]), [
#define _GNU_SOURCE
#include <pthread.h>])

AC_SUBST(THREADFLAGS)
AC_SUBST(THREADLIB)

CPPFLAGS="$THREADFLAGS $CPPFLAGS"

# RT Library
RTLIB=""
if test "$need_librt" = "yes"; then
  AC_CHECK_LIB(rt, clock_gettime, ,
    AC_MSG_ERROR([
*** DirectFB requires librt.]))
  RTLIB="-lrt"
fi

AC_SUBST(RTLIB)

# Dynamic Linker
DYNLIB=""
if test "$need_libdl" = "yes"; then
  if test "$enable_shared" = "yes"; then
    AC_CHECK_LIB(dl, dlopen, ,
      AC_MSG_ERROR([
*** DirectFB requires libdl.]))
    DYNLIB="-ldl"
  fi
fi

AC_SUBST(DYNLIB)

# DirectFB version
DIRECTFB_MAJOR_VERSION=1
DIRECTFB_MINOR_VERSION=6
DIRECTFB_MICRO_VERSION=3
DIRECTFB_INTERFACE_AGE=0
DIRECTFB_BINARY_AGE=3
DIRECTFB_VERSION=$DIRECTFB_MAJOR_VERSION.$DIRECTFB_MINOR_VERSION.$DIRECTFB_MICRO_VERSION

AC_SUBST(DIRECTFB_MAJOR_VERSION)
AC_SUBST(DIRECTFB_MINOR_VERSION)
AC_SUBST(DIRECTFB_MICRO_VERSION)
AC_SUBST(DIRECTFB_INTERFACE_AGE)
AC_SUBST(DIRECTFB_BINARY_AGE)
AC_SUBST(DIRECTFB_VERSION)

AC_DEFINE_UNQUOTED(DIRECTFB_VERSION,"$DIRECTFB_VERSION",[The DirectFB version])

# How big of a buffer fluxed code uses for static args (times two with return)
AC_ARG_WITH(args-size,
            AC_HELP_STRING([--with-args-size=SIZE],
                           [allow static args up to SIZE bytes @<:@default=1024@:>@]),
            [], [with_args_size=no])
test x"$with_args_size" = x"no" && with_args_size=1024
FLUXED_ARGS_BYTES=$with_args_size
AC_SUBST(FLUXED_ARGS_BYTES)

# How big of a buffer fusion uses to read messages from the fusion device
AC_ARG_WITH(message-size,
            AC_HELP_STRING([--with-message-size=SIZE],
                           [allow fusion messages up to SIZE bytes @<:@default=1024@:>@]),
            [], [with_message_size=no])
test x"$with_message_size" = x"no" && with_message_size=16384
FUSION_MESSAGE_SIZE=$with_message_size
AC_SUBST(FUSION_MESSAGE_SIZE)

AC_ARG_ENABLE([directfb], AS_HELP_STRING([--enable-directfb], [Enable DirectFB]))

AC_ARG_ENABLE(debug,
              AC_HELP_STRING([--enable-debug],
                             [enable debugging @<:@default=no@:>@]),
              [], [enable_debug=no])
if test "$enable_debug" = "yes"; then
    CFLAGS="-g3 -O0 -fno-inline -Wno-inline $CFLAGS"
    DIRECT_BUILD_DEBUG=1
else
    DIRECT_BUILD_DEBUG=0
fi
AM_CONDITIONAL(ENABLE_DEBUG, test "$enable_debug" = "yes")

AC_SUBST(DIRECT_BUILD_DEBUG)

AC_ARG_ENABLE(debug-support,
              AC_HELP_STRING([--enable-debug-support],
                             [enable debugging support @<:@default=yes@:>@]),
              [], [enable_debug_support=yes])
if test "$enable_debug_support" = "yes" || test "$enable_debug" = "yes"; then
    enable_debug_support=yes
    if test "$enable_debug" = "no"; then
        CFLAGS="-g2 $CFLAGS"
    fi
    CFLAGS="-O2 $CFLAGS"
    DIRECT_BUILD_DEBUGS=1
else
    CFLAGS="-Os -g0 -ffunction-sections -fdata-sections -Wl,--gc-sections -Wl,-O1 $CFLAGS"
    DIRECT_BUILD_DEBUGS=0
fi
AM_CONDITIONAL(ENABLE_DEBUGS, test "$enable_debug_support" = "yes")

AC_SUBST(DIRECT_BUILD_DEBUGS)

AC_ARG_ENABLE(trace,
              AC_HELP_STRING([--enable-trace],
                             [enable call tracing @<:@default=no@:>@]),
              [], [enable_trace=no])
if test "$enable_trace" = "yes"; then
    DFB_INTERNAL_CFLAGS="$DFB_INTERNAL_CFLAGS -finstrument-functions"
    DIRECT_BUILD_TRACE=1
else
    DIRECT_BUILD_TRACE=0
fi
AM_CONDITIONAL(ENABLE_TRACE, test "$enable_trace" = "yes")

AC_SUBST(DIRECT_BUILD_TRACE)


AC_ARG_ENABLE(text,
              AC_HELP_STRING([--enable-text],
                             [enable text output @<:@default=yes@:>@]),
              [], [enable_text=yes])
if test "$enable_text" = "no"; then
    DIRECT_BUILD_TEXT=0
else
    DIRECT_BUILD_TEXT=1
fi

AC_SUBST(DIRECT_BUILD_TEXT)

AC_ARG_ENABLE(gettid,
              AC_HELP_STRING([--enable-gettid],
                             [enable usage of gettid() @<:@default=yes@:>@]),
              [], [enable_gettid=yes])
if test "$enable_gettid" = "no"; then
    DIRECT_BUILD_GETTID=0
else
    DIRECT_BUILD_GETTID=1
fi

AC_SUBST(DIRECT_BUILD_GETTID)

AC_ARG_ENABLE(network,
              AC_HELP_STRING([--enable-network],
                             [enable network support @<:@default=yes@:>@]),
              [], [enable_network=yes])
if test "$enable_network" = "no"; then
    DIRECT_BUILD_NETWORK=0
else
    DIRECT_BUILD_NETWORK=1
fi

AC_SUBST(DIRECT_BUILD_NETWORK)

AC_CHECK_HEADER(stdbool.h, DIRECT_BUILD_STDBOOL=1, DIRECT_BUILD_STDBOOL=0)

AC_SUBST(DIRECT_BUILD_STDBOOL)


AC_ARG_ENABLE(dynload,
              AC_HELP_STRING([--enable-dynload],
                             [enable dynload support @<:@default=yes@:>@]),
              [], [enable_dynload=yes])
if test "$enable_dynload" = "no"; then
    DIRECT_BUILD_DYNLOAD=0
else
    DIRECT_BUILD_DYNLOAD=1
fi

AC_SUBST(DIRECT_BUILD_DYNLOAD)

AC_ARG_ENABLE(multicore,
              AC_HELP_STRING([--enable-multicore],
                             [enable multicore support @<:@default=yes@:>@]),
              [],[enable_multicore=yes])
if test "$enable_multicore" = "no"; then
    DIRECT_BUILD_MULTICORE=0
else
    DIRECT_BUILD_MULTICORE=1
fi

AC_SUBST(DIRECT_BUILD_MULTICORE)

DIRECT_BUILD_OSTYPE=DIRECT_OS_LINUX_GNU_LIBC
AC_SUBST(DIRECT_BUILD_OSTYPE)

FUSION_BUILD_MULTI=0
FUSION_BUILD_KERNEL=0

AC_SUBST(FUSION_BUILD_MULTI)
AC_SUBST(FUSION_BUILD_KERNEL)

DIRECTFB_BUILD_ONE=0
AC_SUBST(DIRECTFB_BUILD_ONE)

DIRECTFB_BUILD_VOODOO=0
AC_SUBST(DIRECTFB_BUILD_VOODOO)

DIRECTFB_BUILD_PURE_VOODOO=0
AC_SUBST(DIRECTFB_BUILD_PURE_VOODOO)

### e2fsprogs
E2FSPROGS_VERSION="1.43.12"
AC_SUBST(E2FSPROGS_VERSION)
AC_CHECK_SIZEOF(short)
AC_CHECK_SIZEOF(int)
AC_CHECK_SIZEOF(long)
AC_CHECK_SIZEOF(long long)
AC_CHECK_SIZEOF(off_t)
SIZEOF_SHORT=$ac_cv_sizeof_short
SIZEOF_INT=$ac_cv_sizeof_int
SIZEOF_LONG=$ac_cv_sizeof_long
SIZEOF_LONG_LONG=$ac_cv_sizeof_long_long
SIZEOF_OFF_T=$ac_cv_sizeof_off_t
AC_SUBST(SIZEOF_SHORT)
AC_SUBST(SIZEOF_INT)
AC_SUBST(SIZEOF_LONG)
AC_SUBST(SIZEOF_LONG_LONG)
AC_SUBST(SIZEOF_OFF_T)
AC_C_BIGENDIAN
if test $cross_compiling = no; then
  BUILD_CC="$BUILD_CC" CPP="$CPP" /bin/sh external/e2fsprogs/config/parse-types.sh
else
  CROSS_COMPILE="1" BUILD_CC="$BUILD_CC" CPP="$CPP" /bin/sh external/e2fsprogs/config/parse-types.sh
fi
mv asm_types.h external/e2fsprogs/asm_types.h
ASM_TYPES_HEADER=external/e2fsprogs/asm_types.h
AC_SUBST_FILE(ASM_TYPES_HEADER)
dnl
dnl Save the configuration #defines needed for the public ext2fs.h
dnl header file
dnl
echo "/* These defines are needed for the public ext2fs.h header file */" \
     > public_config.h
if grep HAVE_SYS_TYPES_H confdefs.h > tmp_config.$$; then
  uniq tmp_config.$$ >> public_config.h
else
  echo "#undef HAVE_SYS_TYPES_H" >> public_config.h
fi
if grep WORDS_BIGENDIAN confdefs.h > tmp_config.$$; then
  uniq tmp_config.$$ >> public_config.h
else
  echo "#undef WORDS_BIGENDIAN" >> public_config.h
fi
rm -f tmp_config.$$
PUBLIC_CONFIG_HEADER=./public_config.h
AC_SUBST_FILE(PUBLIC_CONFIG_HEADER)
mv public_config.h external/e2fsprogs/public_config.h
AC_CHECK_DECL(llseek,[AC_DEFINE(HAVE_LLSEEK_PROTOTYPE, 1,
			[Define to 1 if llseek declared in unistd.h])],,
	      [#include <unistd.h>])
AC_CHECK_DECL(lseek64,[AC_DEFINE(HAVE_LSEEK64_PROTOTYPE, 1,
			[Define to 1 if lseek64 declared in unistd.h])],,
		[#define _LARGEFILE_SOURCE
		 #define _LARGEFILE64_SOURCE
		 #include <unistd.h>])

### util-linux
LIBBLKID_VERSION="2.27"
AC_DEFINE_UNQUOTED([LIBBLKID_VERSION], ["$LIBBLKID_VERSION"], [libblkid version string])
AC_SUBST([LIBBLKID_VERSION])

LIBBLKID_DATE="07-Sep-2015"
AC_SUBST([LIBBLKID_DATE])
AC_DEFINE_UNQUOTED([LIBBLKID_DATE], ["$LIBBLKID_DATE"], [libblkid date string])

AC_CHECK_FUNCS([openat fstatat unlinkat], [have_openat=yes], [have_openat=no])

AC_CONFIG_FILES([ 										\
  external/directfb/include/directfb_build.h:external/directfb/include/directfb_build.h.in	\
  external/directfb/include/directfb_version.h:external/directfb/include/directfb_version.h.in	\
  external/directfb/lib/direct/build.h:external/directfb/lib/direct/build.h.in			\
  external/directfb/lib/fusion/build.h:external/directfb/lib/fusion/build.h.in			\
  external/e2fsprogs/lib/ext2fs/ext2_types.h:external/e2fsprogs/lib/ext2fs/ext2_types.h.in	\
  external/e2fsprogs/util/subst.conf:external/e2fsprogs/util/subst.conf.in			\
  external/zlib/zconf.h:external/zlib/zconf.h.in						\
  settings.mk:settings.in	\
])

AC_OUTPUT([			\
  Makefile			\
])

