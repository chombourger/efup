#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_PREREQ([2.61])
AC_INIT(efup, 0.1, https://github.com/chombourger/efup)
AC_CONFIG_MACRO_DIR([m4])
# AC_CONFIG_SRCDIR([config.h.in])
AC_CONFIG_HEADERS([	\
	external/freetype/builds/unix/ftconfig.h:external/freetype/builds/unix/ftconfig.in \
])

# Checks for programs.
AC_PROG_AWK
AC_PROG_CC
AC_PROG_CPP
AC_PROG_INSTALL
AC_PROG_LN_S
AC_PROG_MAKE_SET
AC_PROG_MKDIR_P
AC_PROG_PERL

# Check for LUA
AC_SUBST([LUA_VERSION],5.2)
AX_LUA_HEADERS(true,true)
AX_LUA_LIBS(true,true)

# Check for NSPR & NSS
AM_PATH_NSPR
AM_PATH_NSS

# Checks for libraries.

# Checks for header files.
AC_CHECK_HEADERS([stdarg.h stddef.h stdlib.h string.h sys/time.h])

# Checks for typedefs, structures, and compiler characteristics.
AC_HEADER_STDBOOL
AC_TYPE_SIZE_T

AC_CANONICAL_HOST
AC_SUBST(HOST_CPU,$host_cpu)
AC_SUBST(HOST_OS,$host_os)

AC_CONFIG_FILES([Makefile])
AC_OUTPUT
