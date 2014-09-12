dnl Copyright 2003 by Martin Kammerhofer <mkamm@gmx.net>
dnl AC_PROG_PERL([minimum-version])
AC_DEFUN([AC_PROG_PERL],
[AC_REQUIRE([AC_SYS_INTERPRETER])
AC_PATH_PROG(PERL, perl, /usr/bin/perl)
AC_ARG_VAR(PERL, [Path to Perl executable])
AC_MSG_CHECKING(for working Perl)
if "$PERL" -we '1' 2>&5; then
	AC_MSG_RESULT(yes)
else
	AC_MSG_RESULT(no)
	AC_MSG_ERROR([[
***
*** No Perl executable found in PATH!
***
]])
fi
if test -n '$1'; then
  AC_MSG_CHECKING([for Perl version >= $1])
  if "$PERL" -we 'require $1; 1' 2>&5; then
	AC_MSG_RESULT(yes)
  else
	AC_MSG_RESULT(no)
	AC_MSG_ERROR([[
***
*** No suitable Perl found in PATH!
*** Maybe prepend Perl's directory?
*** You may also set environment variable PERL.
***
]])
  fi
fi
])

