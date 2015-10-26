#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_PREREQ([2.61])
AC_INIT(efup, 0.1, https://github.com/chombourger/efup)
AC_CONFIG_MACRO_DIR([m4])
AC_CONFIG_HEADERS([	\
	external/curl/include/curl/curlbuild.h:external/curl/include/curl/curlbuild.h.in \
	external/curl/lib/curl_config.h:external/curl/lib/curl_config.h.in \
	external/directfb/config.h:external/directfb/config.h.in \
	external/e2fsprogs/lib/config.h:external/e2fsprogs/lib/config.h.in \
	external/e2fsprogs/lib/dirpaths.h:external/e2fsprogs/lib/dirpaths.h.in \
	external/freetype/builds/unix/ftconfig.h:external/freetype/builds/unix/ftconfig.in \
	external/jpeg/jconfig.h:external/jpeg/jconfig.cfg \
	external/libarchive/config.h:external/libarchive/config.h.in \
	external/opkg/config.h:external/opkg/config.h.in \
	external/png/config.h:external/png/config.h.in \
	external/util-linux/config.h:external/util-linux/config.h.in \
])

# Default to empty prefix (binaries going to /sbin and /lib)
AC_PREFIX_DEFAULT()

AC_ARG_ENABLE(opkg,
	AC_HELP_STRING(
		[--enable-opkg],
		[enable support for opkg @<:@default=no@:>@]
	),
	[],
	[enable_opkg=no]
)

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

check_nspr=yes
check_nss=yes

if test x$enable_opkg = xyes; then
   check_opkg=yes
   check_curl=yes
   check_archive=yes
   check_nspr=yes
   check_nss=yes
fi

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

# Check for OPKG
USE_OPKG=
if test x$check_opkg = xyes; then
   if test $cross_compiling = no; then
      true
   else
      true
   fi
   USE_OPKG=yes
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

# Check for archive
USE_ARCHIVE=
if test x$check_archive = xyes; then
   ARCHIVE_CFLAGS=`pkg-config libarchive --cflags 2>/dev/null`
   ARCHIVE_LIBS=`pkg-config libarchive --libs 2>/dev/null`
   USE_ARCHIVE=yes
fi

# Check for NSPR
USE_NSPR=
if test x$check_nspr = xyes; then
   NSPR_CFLAGS=`pkg-config nspr --cflags 2>/dev/null`
   NSPR_LIBS=`pkg-config nspr --libs 2>/dev/null`
   USE_NSPR=yes
fi

# Check for NSS
USE_NSS=
if test x$check_nss = xyes; then
   NSS_CFLAGS=`pkg-config nss --cflags 2>/dev/null`
   NSS_LIBS=`pkg-config nss --libs 2>/dev/null`
   USE_NSS=yes
fi

# Check for curl
USE_CURL=
if test x$check_curl = xyes; then
   CURL_CFLAGS=`pkg-config libcurl --cflags 2>/dev/null`
   CURL_LIBS=`pkg-config libcurl --libs 2>/dev/null`
   USE_CURL=yes
fi

AC_SUBST(USE_OPKG,$USE_OPKG)

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

AC_SUBST(ARCHIVE_CFLAGS)
AC_SUBST(ARCHIVE_LIBS)
AC_SUBST(USE_ARCHIVE,$USE_ARCHIVE)

AC_SUBST(NSPR_CFLAGS)
AC_SUBST(NSPR_LIBS)
AC_SUBST(USE_NSPR,$USE_NSPR)

AC_SUBST(NSS_CFLAGS)
AC_SUBST(NSS_LIBS)
AC_SUBST(USE_NSS,$USE_NSS)

AC_SUBST(CURL_CFLAGS)
AC_SUBST(CURL_LIBS)
AC_SUBST(USE_CURL,$USE_CURL)

# Checks for header files.
AC_HEADER_STDC
AC_CHECK_HEADERS([		\
	acl/libacl.h		\
	alloca.h		\
	arpa/inet.h		\
	arpa/tftp.h		\
	assert.h		\
	attr/xattr.h		\
	asm/page.h		\
	copyfile.h		\
	crypto.h		\
	ctype.h			\
	dirent.h		\
	dlfcn.h			\
	err.h			\
	errno.h			\
	ext2fs/ext2_fs.h	\
	fcntl.h			\
	grp.h			\
	inttypes.h		\
	io.h			\
	langinfo.h		\
	ldap_ssl.h		\
	ldapssl.h		\
	locale.h		\
	malloc.h		\
	mntent.h		\
	ndir.h			\
	net/if.h		\
	netdb.h			\
	netinet/in.h		\
	netinet/tcp.h		\
	paths.h			\
	pcreposix.h		\
	pthread.h		\
	poll.h			\
	pwd.h			\
	regex.h			\
	signal.h		\
	stdarg.h		\
	stddef.h		\
	stdint.h		\
	stdlib.h		\
	string.h		\
	libgen.h		\
	limits.h		\
	linux/compiler.h	\
	linux/falloc.h		\
	linux/fd.h		\
	linux/fiemap.h		\
	linux/fs.h		\
	linux/magic.h		\
	linux/major.h		\
	linux/loop.h		\
	linux/types.h		\
	linux/unistd.h		\
	md5.h			\
	rsa.h			\
	setjmp.h		\
	signal.h		\
	sgtty.h			\
	socket.h		\
	spawn.h			\
	sha.h			\
	sha256.h		\
	sha512.h		\
	ssl.h			\
	stdbool.h		\
	stdlib.h		\
	strops.h		\
	sys/acl.h		\
	sys/cdefs.h		\
	sys/disk.h		\
	sys/disklabel.h		\
	sys/dir.h		\
	sys/file.h		\
	sys/filio.h		\
	sys/ioctl.h		\
	sys/mman.h		\
	sys/mount.h		\
	sys/mkdev.h		\
	sys/ndir.h		\
	sys/param.h		\
	sys/poll.h		\
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
	sys/uio.h		\
	sys/un.h		\
	sys/utime.h		\
	sys/utsname.h		\
	sys/wait.h		\
	termio.h		\
	termios.h		\
	time.h			\
	tld.h			\
	unistd.h		\
	utime.h			\
	vfork.h			\
	wchar.h			\
	wctype.h		\
])

# Checks for typedefs, structures, and compiler characteristics.
AC_C_CONST
AC_TYPE_SIZE_T
AC_STRUCT_TM
AC_C_RESTRICT
AC_HEADER_STDBOOL
AC_TYPE_MODE_T
AC_TYPE_SIZE_T
AC_CHECK_SIZEOF(int)
AC_CHECK_SIZEOF(long)
AC_CHECK_SIZEOF(long long)
AC_C_BIGENDIAN
# AC_TYPE_OFF_T defaults to "long", which limits us to 4GB files on
# most systems... default to "long long" instead.
AC_CHECK_TYPE(off_t, [long long])
AC_CHECK_TYPE(id_t, [unsigned long])
AC_CHECK_TYPE(uintptr_t, [unsigned int])
# If you have uintmax_t, we assume printf supports %ju
# If you have unsigned long long, we assume printf supports %llu
# TODO: Check for %ju and %llu support directly.
AC_CHECK_TYPES([uintmax_t, unsigned long long])

# We use C99-style integer types
# Declare them if the local platform doesn't already do so.
AC_TYPE_INTMAX_T
AC_TYPE_UINTMAX_T
AC_TYPE_INT64_T
AC_TYPE_UINT64_T
AC_TYPE_INT32_T
AC_TYPE_UINT32_T
AC_TYPE_INT16_T
AC_TYPE_UINT16_T
AC_TYPE_UINT8_T

AC_CHECK_DECLS([SIZE_MAX, INT64_MAX, INT64_MIN, UINT64_MAX, UINT32_MAX])

AC_CHECK_DECL(
	[SSIZE_MAX],
	[AC_DEFINE(HAVE_DECL_SSIZE_MAX, 1, [Define to 1 if you have the declaration of `SSIZE_MAX', and to 0 if you don't.])],
	[],
	[#include <limits.h>]
)

AC_CHECK_DECL([EFTYPE],
                [AC_DEFINE(HAVE_EFTYPE, 1, [A possible errno value for invalid file format errors])],
                [],
                [#include <errno.h>])
AC_CHECK_DECL([EILSEQ],
                [AC_DEFINE(HAVE_EILSEQ, 1, [A possible errno value for invalid file format errors])],
                [],
                [#include <errno.h>])
AC_CHECK_TYPE([wchar_t],
                [AC_DEFINE_UNQUOTED(AS_TR_CPP(HAVE_[]wchar_t), 1, [Define to 1 if the system has the type `wchar_t'.])dnl
                AC_CHECK_SIZEOF([wchar_t])],
                [])

# Checks for library functions.
AC_FUNC_STRTOD
AC_CHECK_FUNCS([	\
	fcntl		\
	fdopen		\
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
	perror		\
	recv		\
	regcomp		\
	setmntent	\
	sigaction	\
	siginterrupt	\
	signal		\
	sigsetjmp	\
	strcasecmp	\
	strcspn		\
	stricmp		\
	strncasecmp	\
	strncmpi	\
	strstr		\
	strtok_r	\
	strtol		\
	strtoll		\
	strtoul		\
	sysconf		\
	sysinfo		\
	tld_strerror	\
	uname		\
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
AC_DEFINE(HAVE_LIBZ,1)
AC_DEFINE(HAVE_ZLIB_H,1)

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

### curl

AC_DEFINE_UNQUOTED(OS, "${host}", [cpu-machine-OS])
AC_DEFINE(CURL_DISABLE_LDAP,1)
AC_DEFINE(CURL_DISABLE_LDAPS,1)

dnl SED is mandatory for configure process and libtool.
dnl Set it now, allowing it to be changed later.
if test -z "$SED"; then
  dnl allow it to be overridden
  AC_PATH_PROG([SED], [sed], [not_found],
    [$PATH:/usr/bin:/usr/local/bin])
  if test -z "$SED" || test "$SED" = "not_found"; then
    AC_MSG_ERROR([sed not found in PATH. Cannot continue without sed.])
  fi
fi
AC_SUBST([SED])

AC_CHECK_SIZEOF(size_t)
AC_CHECK_SIZEOF(long)
AC_CHECK_SIZEOF(int)
AC_CHECK_SIZEOF(short)
CURL_CONFIGURE_LONG
AC_CHECK_SIZEOF(time_t)
AC_CHECK_SIZEOF(off_t)

CURL_CONFIGURE_CURL_OFF_T
CURL_CHECK_AIX_ALL_SOURCE
CURL_CONFIGURE_THREAD_SAFE
CURL_CONFIGURE_REENTRANT
CURL_CHECK_STRUCT_TIMEVAL
CURL_VERIFY_RUNTIMELIBS
AC_SYS_LARGEFILE

AC_CHECK_TYPE(long long,
   [AC_DEFINE(HAVE_LONGLONG, 1,
      [Define to 1 if the compiler supports the 'long long' data type.])]
   longlong="yes"
)

if test "xyes" = "x$longlong"; then
  AC_MSG_CHECKING([if numberLL works])
  AC_COMPILE_IFELSE([
    AC_LANG_PROGRAM([[
    ]],[[
      long long val = 1000LL;
    ]])
  ],[
    AC_MSG_RESULT([yes])
    AC_DEFINE(HAVE_LL, 1, [if your compiler supports LL])
  ],[
    AC_MSG_RESULT([no])
  ])
fi

# check for ssize_t
AC_CHECK_TYPE(ssize_t, ,
   AC_DEFINE(ssize_t, int, [the signed version of size_t]))

# check for bool type
AC_CHECK_TYPE([bool],[
  AC_DEFINE(HAVE_BOOL_T, 1,
    [Define to 1 if bool is an available type.])
], ,[
#ifdef HAVE_SYS_TYPES_H
#include <sys/types.h>
#endif
#ifdef HAVE_STDBOOL_H
#include <stdbool.h>
#endif
])

CURL_CONFIGURE_CURL_SOCKLEN_T

CURL_CONFIGURE_PULL_SYS_POLL

TYPE_IN_ADDR_T

TYPE_SOCKADDR_STORAGE

TYPE_SIG_ATOMIC_T

AC_TYPE_SIGNAL

CURL_CHECK_FUNC_SELECT

CURL_CHECK_FUNC_RECV
CURL_CHECK_FUNC_SEND
CURL_CHECK_MSG_NOSIGNAL

CURL_CHECK_FUNC_ALARM
CURL_CHECK_FUNC_BASENAME
CURL_CHECK_FUNC_CLOSESOCKET
CURL_CHECK_FUNC_CLOSESOCKET_CAMEL
CURL_CHECK_FUNC_CONNECT
CURL_CHECK_FUNC_FCNTL
CURL_CHECK_FUNC_FDOPEN
CURL_CHECK_FUNC_FREEADDRINFO
CURL_CHECK_FUNC_FREEIFADDRS
CURL_CHECK_FUNC_FSETXATTR
CURL_CHECK_FUNC_FTRUNCATE
CURL_CHECK_FUNC_GETADDRINFO
CURL_CHECK_FUNC_GAI_STRERROR
CURL_CHECK_FUNC_GETHOSTBYADDR
CURL_CHECK_FUNC_GETHOSTBYADDR_R
CURL_CHECK_FUNC_GETHOSTBYNAME
CURL_CHECK_FUNC_GETHOSTBYNAME_R
CURL_CHECK_FUNC_GETHOSTNAME
CURL_CHECK_FUNC_GETIFADDRS
CURL_CHECK_FUNC_GETSERVBYPORT_R
CURL_CHECK_FUNC_GMTIME_R
CURL_CHECK_FUNC_INET_NTOA_R
CURL_CHECK_FUNC_INET_NTOP
CURL_CHECK_FUNC_INET_PTON
CURL_CHECK_FUNC_IOCTL
CURL_CHECK_FUNC_IOCTLSOCKET
CURL_CHECK_FUNC_IOCTLSOCKET_CAMEL
CURL_CHECK_FUNC_LOCALTIME_R
CURL_CHECK_FUNC_MEMRCHR
CURL_CHECK_FUNC_POLL
CURL_CHECK_FUNC_SETSOCKOPT
CURL_CHECK_FUNC_SIGACTION
CURL_CHECK_FUNC_SIGINTERRUPT
CURL_CHECK_FUNC_SIGNAL
CURL_CHECK_FUNC_SIGSETJMP
CURL_CHECK_FUNC_SOCKET
CURL_CHECK_FUNC_SOCKETPAIR
CURL_CHECK_FUNC_STRCASECMP
CURL_CHECK_FUNC_STRCMPI
CURL_CHECK_FUNC_STRDUP
CURL_CHECK_FUNC_STRERROR_R
CURL_CHECK_FUNC_STRICMP
CURL_CHECK_FUNC_STRNCASECMP
CURL_CHECK_FUNC_STRNCMPI
CURL_CHECK_FUNC_STRNICMP
CURL_CHECK_FUNC_STRSTR
CURL_CHECK_FUNC_STRTOK_R
CURL_CHECK_FUNC_STRTOLL
CURL_CHECK_FUNC_WRITEV

### opkg

OPKG_VERSION=0.3.0
AC_SUBST(OPKG_VERSION)

### libarchive

m4_define([LIBARCHIVE_VERSION_S],[3.1.2])
m4_define([LIBARCHIVE_VERSION_N],[3001002])
m4_define([BSDTAR_VERSION_S],LIBARCHIVE_VERSION_S())
m4_define([BSDCPIO_VERSION_S],LIBARCHIVE_VERSION_S())

ARCHIVE_MINOR=$(( (LIBARCHIVE_VERSION_N() / 1000) % 1000 ))
ARCHIVE_INTERFACE=`echo $((13 + ${ARCHIVE_MINOR}))`
ARCHIVE_REVISION=$(( LIBARCHIVE_VERSION_N() % 1000 ))
ARCHIVE_LIBTOOL_VERSION=$ARCHIVE_INTERFACE:$ARCHIVE_REVISION:$ARCHIVE_MINOR
AC_DEFINE([LIBARCHIVE_VERSION_STRING],"LIBARCHIVE_VERSION_S()",
        [Version number of libarchive])
AC_DEFINE_UNQUOTED([LIBARCHIVE_VERSION_NUMBER],"LIBARCHIVE_VERSION_N()",
        [Version number of libarchive as a single integer])
AC_DEFINE([BSDCPIO_VERSION_STRING],"BSDCPIO_VERSION_S()",
        [Version number of bsdcpio])
AC_DEFINE([BSDTAR_VERSION_STRING],"BSDTAR_VERSION_S()",
        [Version number of bsdtar])

BSDCPIO_VERSION_STRING=BSDCPIO_VERSION_S()
BSDTAR_VERSION_STRING=BSDTAR_VERSION_S()
LIBARCHIVE_VERSION_STRING=LIBARCHIVE_VERSION_S()
LIBARCHIVE_VERSION_NUMBER=LIBARCHIVE_VERSION_N()

AC_SUBST(ARCHIVE_LIBTOOL_VERSION)
AC_SUBST(BSDCPIO_VERSION_STRING)
AC_SUBST(BSDTAR_VERSION_STRING)
AC_SUBST(LIBARCHIVE_VERSION_STRING)
AC_SUBST(LIBARCHIVE_VERSION_NUMBER)

# Check for tm_gmtoff in struct tm
AC_CHECK_MEMBERS([struct tm.tm_gmtoff, struct tm.__tm_gmtoff],,,
[
#include <time.h>
])

# Check for f_namemax in struct statfs
AC_CHECK_MEMBERS([struct statfs.f_namemax],,,
[
#include <sys/param.h>
#include <sys/mount.h>
])

# Check for f_iosize in struct statvfs
AC_CHECK_MEMBERS([struct statvfs.f_iosize],,,
[
#include <sys/statvfs.h>
])

# Check for birthtime in struct stat
AC_CHECK_MEMBERS([struct stat.st_birthtime])

# Check for high-resolution timestamps in struct stat
AC_CHECK_MEMBERS([struct stat.st_birthtimespec.tv_nsec])
AC_CHECK_MEMBERS([struct stat.st_mtimespec.tv_nsec])
AC_CHECK_MEMBERS([struct stat.st_mtim.tv_nsec])
AC_CHECK_MEMBERS([struct stat.st_mtime_n]) # AIX
AC_CHECK_MEMBERS([struct stat.st_umtime]) # Tru64
AC_CHECK_MEMBERS([struct stat.st_mtime_usec]) # Hurd
# Check for block size support in struct stat
AC_CHECK_MEMBERS([struct stat.st_blksize])
# Check for st_flags in struct stat (BSD fflags)
AC_CHECK_MEMBERS([struct stat.st_flags])

# Checks for library functions.
AC_PROG_GCC_TRADITIONAL
AC_HEADER_MAJOR
AC_FUNC_FSEEKO
AC_FUNC_MEMCMP
AC_FUNC_LSTAT
AC_FUNC_STAT
AC_FUNC_STRERROR_R
AC_FUNC_STRFTIME
AC_FUNC_VPRINTF
AC_CHECK_FUNCS([chflags chown chroot ctime_r dirfd])
AC_CHECK_FUNCS([fchdir fchflags fchmod fchown fcntl fdopendir fork])
AC_CHECK_FUNCS([fstat fstatat fstatfs fstatvfs ftruncate])
AC_CHECK_FUNCS([futimens futimes futimesat])
AC_CHECK_FUNCS([geteuid getpid getgrgid_r getgrnam_r])
AC_CHECK_FUNCS([getpwnam_r getpwuid_r getvfsbyname gmtime_r])
AC_CHECK_FUNCS([lchflags lchmod lchown link localtime_r lstat lutimes])
AC_CHECK_FUNCS([mbrtowc memmove memset])
AC_CHECK_FUNCS([mkdir mkfifo mknod mkstemp])
AC_CHECK_FUNCS([nl_langinfo openat pipe poll posix_spawnp readlink readlinkat])
AC_CHECK_FUNCS([select setenv setlocale sigaction statfs statvfs])
AC_CHECK_FUNCS([strchr strdup strerror strncpy_s strrchr symlink timegm])
AC_CHECK_FUNCS([tzset unsetenv utime utimensat utimes vfork])
AC_CHECK_FUNCS([wcrtomb wcscmp wcscpy wcslen wctomb wmemcmp wmemcpy])
AC_CHECK_FUNCS([_ctime64_s _fseeki64])
AC_CHECK_FUNCS([_get_timezone _localtime64_s _mkgmtime64])
# detects cygwin-1.7, as opposed to older versions
AC_CHECK_FUNCS([cygwin_conv_path])

# There are several variants of readdir_r around; we only
# accept the POSIX-compliant version.
AC_COMPILE_IFELSE(
	[AC_LANG_PROGRAM([[#include <dirent.h>]],
		[[DIR *dir; struct dirent e, *r;
			return(readdir_r(dir, &e, &r));]])],
		[AC_DEFINE(HAVE_READDIR_R,1,[Define to 1 if you have a POSIX compatible readdir_r])]
)

# Check for dirent.d_namlen field explicitly
# (This is a bit more straightforward than, if not quite as portable as,
# the recipe given by the autoconf maintainers.)
AC_CHECK_MEMBER(struct dirent.d_namlen,,,
[#if HAVE_DIRENT_H
#include <dirent.h>
#endif
])

# Check for Extended Attributes support
AC_ARG_ENABLE([xattr],
                AS_HELP_STRING([--disable-xattr],
                [Enable Extended Attributes support (default: check)]))

if test "x$enable_xattr" != "xno"; then
        AC_CHECK_HEADERS([attr/xattr.h])
        AC_CHECK_HEADERS([sys/xattr.h sys/ea.h])
        AC_CHECK_LIB(attr,setxattr)
        AC_CHECK_FUNCS([extattr_get_file extattr_list_file])
        AC_CHECK_FUNCS([extattr_set_fd extattr_set_file])
        AC_CHECK_FUNCS([fgetxattr flistxattr fsetxattr getxattr])
        AC_CHECK_FUNCS([lgetxattr listxattr llistxattr lsetxattr])
        AC_CHECK_FUNCS([fgetea flistea fsetea getea])
        AC_CHECK_FUNCS([lgetea listea llistea lsetea])
        AC_CHECK_DECLS([EXTATTR_NAMESPACE_USER], [], [], [#include <sys/types.h>
#include <sys/extattr.h>
])
fi

# Check for ACL support
#
# The ACL support in libarchive is written against the POSIX1e draft,
# which was never officially approved and varies quite a bit across
# platforms.  Worse, some systems have completely non-POSIX acl functions,
# which makes the following checks rather more complex than I would like.
#
AC_ARG_ENABLE([acl],
		AS_HELP_STRING([--disable-acl],
		[Enable ACL support (default: check)]))

if test "x$enable_acl" != "xno"; then
   AC_CHECK_HEADERS([sys/acl.h])
   AC_CHECK_LIB([acl],[acl_get_file])
   AC_CHECK_FUNCS([acl_create_entry acl_init acl_set_fd acl_set_fd_np acl_set_file])

   AC_CHECK_TYPES(acl_permset_t,,,
	[#if HAVE_SYS_TYPES_H
	#include <sys/types.h>
	#endif
	#if HAVE_SYS_ACL_H
	#include <sys/acl.h>
	#endif
	])

    # The "acl_get_perm()" function was omitted from the POSIX draft.
    # (It's a pretty obvious oversight; otherwise, there's no way to
    # test for specific permissions in a permset.)  Linux uses the obvious
    # name, FreeBSD adds _np to mark it as "non-Posix extension."
    # Test for both as a double-check that we really have POSIX-style ACL support.
    AC_CHECK_FUNCS(acl_get_perm_np acl_get_perm acl_get_link acl_get_link_np,,,
	[#if HAVE_SYS_TYPES_H
	#include <sys/types.h>
	#endif
	#if HAVE_SYS_ACL_H
	#include <sys/acl.h>
	#endif
	])

    # MacOS has an acl.h that isn't POSIX.  It can be detected by
    # checking for ACL_USER
    AC_CHECK_DECL([ACL_USER],
		[AC_DEFINE(HAVE_ACL_USER, 1, [True for systems with POSIX ACL support])],
		[],
		[#include <sys/acl.h>])
fi

# Additional requirements
AC_SYS_LARGEFILE

dnl NOTE: Crypto checks must run last.
AC_DEFUN([CRYPTO_CHECK], [
  if test "$found_$1" != yes; then
    saved_CPPFLAGS="$CPPFLAGS"
    CPPFLAGS="$CPPFLAGS -I. -I$srcdir -I$srcdir/external/libarchive/libarchive"
    touch "check_crypto_md.h"
    AC_MSG_CHECKING([support for ARCHIVE_CRYPTO_$1_$2])
    AC_LINK_IFELSE([AC_LANG_SOURCE([
#define ARCHIVE_$1_COMPILE_TEST
#define ARCHIVE_CRYPTO_$1_$2
#define PLATFORM_CONFIG_H "check_crypto_md.h"

$(cat "$srcdir/external/libarchive/libarchive/archive_crypto.c")

int
main(int argc, char **argv)
{
  archive_$3_ctx ctx;
  archive_$3_init(&ctx);
  archive_$3_update(&ctx, *argv, argc);
  archive_$3_final(&ctx, NULL);
  return 0;
}
])],
    [ AC_MSG_RESULT([yes])
      found_$1=yes
      found_$2=yes
      AC_DEFINE(ARCHIVE_CRYPTO_$1_$2, 1, [ $1 via ARCHIVE_CRYPTO_$1_$2 supported.])
    ],
    [ AC_MSG_RESULT([no])])
    CPPFLAGS="$saved_CPPFLAGS"
    rm "check_crypto_md.h"
  fi
])

AC_DEFUN([CRYPTO_CHECK_WIN], [
  if test "$found_$1" != yes; then
    AC_MSG_CHECKING([support for ARCHIVE_CRYPTO_$1_WIN])
    AC_LINK_IFELSE([AC_LANG_SOURCE([
#define ARCHIVE_$1_COMPILE_TEST
#include <windows.h>
#include <wincrypt.h>

int
main(int argc, char **argv)
{
	(void)argc;
	(void)argv;

	return ($2);
}
])],
    [ AC_MSG_RESULT([yes])
      found_$1=yes
      found_WIN=yes
      AC_DEFINE(ARCHIVE_CRYPTO_$1_WIN, 1, [ $1 via ARCHIVE_CRYPTO_$1_WIN supported.])
    ],
    [ AC_MSG_RESULT([no])])
  fi
])

case "$host_os" in
  *mingw* | *cygwin*)
	;;
  *)
	CRYPTO_CHECK(MD5, LIBC, md5)
	CRYPTO_CHECK(MD5, LIBSYSTEM, md5)
	CRYPTO_CHECK(RMD160, LIBC, rmd160)
	CRYPTO_CHECK(SHA1, LIBC, sha1)
	CRYPTO_CHECK(SHA1, LIBSYSTEM, sha1)
	CRYPTO_CHECK(SHA256, LIBC, sha256)
	CRYPTO_CHECK(SHA256, LIBC2, sha256)
	CRYPTO_CHECK(SHA256, LIBC3, sha256)
	CRYPTO_CHECK(SHA256, LIBSYSTEM, sha256)
	CRYPTO_CHECK(SHA384, LIBC, sha384)
	CRYPTO_CHECK(SHA384, LIBC2, sha384)
	CRYPTO_CHECK(SHA384, LIBC3, sha384)
	CRYPTO_CHECK(SHA384, LIBSYSTEM, sha384)
	CRYPTO_CHECK(SHA512, LIBC, sha512)
	CRYPTO_CHECK(SHA512, LIBC2, sha512)
	CRYPTO_CHECK(SHA512, LIBC3, sha512)
	CRYPTO_CHECK(SHA512, LIBSYSTEM, sha512)
	;;
esac

if test "x$with_nettle" != "xno"; then
    AC_CHECK_HEADERS([nettle/md5.h nettle/ripemd160.h nettle/sha.h])
    saved_LIBS=$LIBS
    AC_CHECK_LIB(nettle,main)
    CRYPTO_CHECK(MD5, NETTLE, md5)
    CRYPTO_CHECK(RMD160, NETTLE, rmd160)
    CRYPTO_CHECK(SHA1, NETTLE, sha1)
    CRYPTO_CHECK(SHA256, NETTLE, sha256)
    CRYPTO_CHECK(SHA384, NETTLE, sha384)
    CRYPTO_CHECK(SHA512, NETTLE, sha512)
    if test "x$found_NETTLE" != "xyes"; then
      LIBS=$saved_LIBS
    fi
fi
if test "x$with_openssl" != "xno"; then
    AC_CHECK_HEADERS([openssl/evp.h])
    saved_LIBS=$LIBS
    case "$host_os" in
      *mingw* | *cygwin*)
        case "$host_cpu" in
          x86_64)
            AC_CHECK_LIB(eay64,main)
            if test "x$ac_cv_lib_eay64_main" != "xyes"; then
              AC_CHECK_LIB(eay32,main)
            fi
            ;;
          *)
            AC_CHECK_LIB(eay32,main)
            ;;
        esac
        ;;
      *)
        AC_CHECK_LIB(crypto,main)
        ;;
    esac
    CRYPTO_CHECK(MD5, OPENSSL, md5)
    CRYPTO_CHECK(RMD160, OPENSSL, rmd160)
    CRYPTO_CHECK(SHA1, OPENSSL, sha1)
    CRYPTO_CHECK(SHA256, OPENSSL, sha256)
    CRYPTO_CHECK(SHA384, OPENSSL, sha384)
    CRYPTO_CHECK(SHA512, OPENSSL, sha512)
    if test "x$found_OPENSSL" != "xyes"; then
      LIBS=$saved_LIBS
    fi
fi

# Probe libmd AFTER OpenSSL/libcrypto.
# The two are incompatible and OpenSSL is more complete.
AC_CHECK_HEADERS([md5.h ripemd.h sha.h sha256.h sha512.h])
saved_LIBS=$LIBS
AC_CHECK_LIB(md,main)
CRYPTO_CHECK(MD5, LIBMD, md5)
CRYPTO_CHECK(RMD160, LIBMD, rmd160)
CRYPTO_CHECK(SHA1, LIBMD, sha1)
CRYPTO_CHECK(SHA256, LIBMD, sha256)
CRYPTO_CHECK(SHA512, LIBMD, sha512)
if test "x$found_LIBMD" != "xyes"; then
  LIBS=$saved_LIBS
fi

case "$host_os" in
  *mingw* | *cygwin*)
	CRYPTO_CHECK_WIN(MD5, CALG_MD5)
	CRYPTO_CHECK_WIN(SHA1, CALG_SHA1)
	CRYPTO_CHECK_WIN(SHA256, CALG_SHA_256)
	CRYPTO_CHECK_WIN(SHA384, CALG_SHA_384)
	CRYPTO_CHECK_WIN(SHA512, CALG_SHA_512)
	;;
esac

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
