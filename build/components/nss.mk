##############################################################################
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
##############################################################################

ifndef MACHINE
ifeq ($(HOST_CPU),arm)
MACHINE:=arm
endif
ifeq ($(HOST_CPU),i686)
MACHINE:=x86
endif
ifeq ($(HOST_CPU),x86_64)
MACHINE:=x86_64
NSS_USE_64:=1
endif
endif

ifdef MACHINE
$(MACHINE):=1
else
$(error could not determine target machine (HOST_CPU=$(HOST_CPU))!)
endif

ifndef SYSTEM
ifeq ($(HOST_OS),linux-gnu)
SYSTEM:=Linux
endif
ifeq ($(HOST_OS),linux-gnueabi)
SYSTEM:=Linux
endif
ifeq ($(HOST_OS),linux-gnueabihf)
SYSTEM:=Linux
endif
endif

ifdef SYSTEM
$(SYSTEM):=1
else
$(error could not determine target system (HOST_OS=$(HOST_OS))!)
endif

###################################### NSPR ##################################

ifndef WITH_SYSTEM_NSPR

include $(CLEAR_VARS)
LOCAL_MODULE := nspr$(NSPR_SHLIB_VERSION)

NSPR = external/nspr/pr
NSPR_DS = external/nspr/lib/ds
NSPR_LIBC = external/nspr/lib/libc

LOCAL_C_INCLUDES += .
LOCAL_C_INCLUDES += include/nspr
LOCAL_C_INCLUDES += $(NSPR)/include
LOCAL_C_INCLUDES += $(NSPR)/include/private
LOCAL_C_INCLUDES += $(NSPR)/include/private
LOCAL_C_INCLUDES += $(NSPR_LIBC)/include

LOCAL_CFLAGS += -DLINUX=1
LOCAL_CFLAGS += -D_GNU_SOURCE=1
LOCAL_CFLAGS += -D_PR_PTHREADS

LOCAL_SRC_FILES += 					\
	$(NSPR)/src/io/prfdcach.c			\
	$(NSPR)/src/io/prmwait.c			\
	$(NSPR)/src/io/priometh.c			\
	$(NSPR)/src/io/pripv6.c				\
	$(NSPR)/src/io/prmapopt.c			\
	$(NSPR)/src/io/prlayer.c			\
	$(NSPR)/src/io/prlog.c				\
	$(NSPR)/src/io/prmmap.c				\
	$(NSPR)/src/io/prpolevt.c			\
	$(NSPR)/src/io/prprf.c				\
	$(NSPR)/src/io/prscanf.c			\
	$(NSPR)/src/io/prstdio.c			\
	$(NSPR)/src/linking/prlink.c			\
	$(NSPR)/src/malloc/prmalloc.c			\
	$(NSPR)/src/malloc/prmem.c			\
	$(NSPR)/src/md/prosdep.c			\
	$(NSPR)/src/memory/prshm.c			\
	$(NSPR)/src/memory/prshma.c			\
	$(NSPR)/src/memory/prseg.c			\
	$(NSPR)/src/misc/pralarm.c			\
	$(NSPR)/src/misc/pratom.c			\
	$(NSPR)/src/misc/prcountr.c			\
	$(NSPR)/src/misc/prdtoa.c			\
	$(NSPR)/src/misc/prenv.c			\
	$(NSPR)/src/misc/prerr.c			\
	$(NSPR)/src/misc/prerror.c			\
	$(NSPR)/src/misc/prerrortable.c			\
	$(NSPR)/src/misc/prinit.c			\
	$(NSPR)/src/misc/prinrval.c			\
	$(NSPR)/src/misc/pripc.c			\
	$(NSPR)/src/misc/prlog2.c			\
	$(NSPR)/src/misc/prlong.c			\
	$(NSPR)/src/misc/prnetdb.c			\
	$(NSPR)/src/misc/praton.c			\
	$(NSPR)/src/misc/prolock.c			\
	$(NSPR)/src/misc/prrng.c			\
	$(NSPR)/src/misc/prsystem.c			\
	$(NSPR)/src/misc/prthinfo.c			\
	$(NSPR)/src/misc/prtpool.c			\
	$(NSPR)/src/misc/prtrace.c			\
	$(NSPR)/src/misc/prtime.c			\
	$(NSPR)/src/threads/prcmon.c			\
	$(NSPR)/src/threads/prrwlock.c			\
	$(NSPR)/src/threads/prtpd.c			\
	$(NSPR)/src/pthreads/ptio.c			\
	$(NSPR)/src/pthreads/ptsynch.c			\
	$(NSPR)/src/pthreads/ptthread.c			\
	$(NSPR)/src/pthreads/ptmisc.c			\

LOCAL_SRC_FILES +=					\
	$(NSPR_DS)/plarena.c				\
        $(NSPR_DS)/plhash.c				\
        $(NSPR_DS)/plvrsion.c				\

LOCAL_SRC_FILES +=					\
	$(NSPR_LIBC)/src/base64.c			\
	$(NSPR_LIBC)/src/strcase.c			\
	$(NSPR_LIBC)/src/strcat.c			\
	$(NSPR_LIBC)/src/strcpy.c			\
	$(NSPR_LIBC)/src/strdup.c			\
	$(NSPR_LIBC)/src/strlen.c			\
	$(NSPR_LIBC)/src/strpbrk.c			\
	$(NSPR_LIBC)/src/strstr.c			\

# Linux 
ifdef Linux
LOCAL_SRC_FILES += 					\
	$(NSPR)/src/md/unix/linux.c			\
	$(NSPR)/src/md/unix/unix.c			\
	$(NSPR)/src/md/unix/unix_errors.c		\
	$(NSPR)/src/md/unix/uxproces.c			\
	$(NSPR)/src/md/unix/uxrng.c			\
	$(NSPR)/src/md/unix/uxshm.c			\
	$(NSPR)/src/md/unix/uxwrap.c			\

ifdef x86_64
LOCAL_SRC_FILES += 					\
	$(NSPR)/src/md/unix/os_Linux_x86_64.s
endif
endif # Linux

include $(BUILD_SHARED_LIBRARY)

endif # WITH_SYSTEM_NSPR


###################################### NSS ###################################

ifndef WITH_SYSTEM_NSS

include $(CLEAR_VARS)
LOCAL_MODULE := nss$(NSS_SHLIB_VERSION)

NSS := external/nss/lib

LOCAL_C_INCLUDES +=					\
	$(NSPR_C_INCLUDES)				\
	external/nss/lib/base				\
	external/nss/lib/certdb				\
	external/nss/lib/certhigh			\
	external/nss/lib/cryptohi			\
	external/nss/lib/dbm/include			\
	external/nss/lib/dev				\
	external/nss/lib/ssl				\
	external/nss/lib/freebl				\
	external/nss/lib/freebl/ecl			\
	external/nss/lib/freebl/mpi			\
	external/nss/lib/libpkix/include		\
	external/nss/lib/libpkix/pkix/certsel		\
	external/nss/lib/libpkix/pkix/checker		\
	external/nss/lib/libpkix/pkix/crlsel		\
	external/nss/lib/libpkix/pkix/params		\
	external/nss/lib/libpkix/pkix/results		\
	external/nss/lib/libpkix/pkix/store		\
	external/nss/lib/libpkix/pkix/top		\
	external/nss/lib/libpkix/pkix/util		\
	external/nss/lib/libpkix/pkix_pl_nss/module	\
	external/nss/lib/libpkix/pkix_pl_nss/pki	\
	external/nss/lib/libpkix/pkix_pl_nss/system	\
	external/nss/lib/nss				\
	external/nss/lib/pk11wrap			\
	external/nss/lib/pkcs7				\
	external/nss/lib/pki				\
	external/nss/lib/smime				\
	external/nss/lib/softoken			\
	external/nss/lib/util				\

LOCAL_CFLAGS += -Wall

LOCAL_CFLAGS += -DXP_UNIX
LOCAL_CFLAGS += -DLINUX_2_1
LOCAL_CFLAGS += -DSHLIB_PREFIX=\"$(SHLIB_PREFIX)\"
LOCAL_CFLAGS += -DSHLIB_SUFFIX=\"$(SHLIB_SUFFIX)\"

LOCAL_CFLAGS += -DSOFTOKEN_LIB_NAME=\"softtoken\"
LOCAL_CFLAGS += -DSOFTOKEN_SHLIB_VERSION=\"$(SOFTOKEN_SHLIB_VERSION)\"
LOCAL_CFLAGS += -DSHLIB_VERSION=\"$(SOFTOKEN_SHLIB_VERSION)\"

LOCAL_CFLAGS += $(NSS_USE_64:%=-DNSS_USE_64)
LOCAL_CFLAGS += -DUSE_UTIL_DIRECTLY
LOCAL_CFLAGS += -DMOZILLA_CLIENT
LOCAL_CFLAGS += -DNSS_PKIX_NO_LDAP

LOCAL_CFLAGS += $(NSPR_CFLAGS)
LOCAL_LDLIBS += $(NSPR_LIBS)

LOCAL_SRC_FILES +=					\
	$(NSS)/base/arena.c				\
	$(NSS)/base/error.c				\
	$(NSS)/base/errorval.c				\
	$(NSS)/base/hashops.c				\
	$(NSS)/base/libc.c				\
	$(NSS)/base/tracker.c				\
	$(NSS)/base/item.c				\
	$(NSS)/base/utf8.c				\
	$(NSS)/base/list.c				\
	$(NSS)/base/hash.c				\
	$(NSS)/dev/devslot.c				\
	$(NSS)/dev/devtoken.c				\
	$(NSS)/dev/devutil.c				\
	$(NSS)/dev/ckhelper.c				\
	$(NSS)/pki/asymmkey.c				\
	$(NSS)/pki/certificate.c			\
	$(NSS)/pki/cryptocontext.c			\
	$(NSS)/pki/symmkey.c				\
	$(NSS)/pki/trustdomain.c			\
	$(NSS)/pki/tdcache.c				\
	$(NSS)/pki/certdecode.c				\
	$(NSS)/pki/pkistore.c				\
	$(NSS)/pki/pkibase.c				\
	$(NSS)/pki/pki3hack.c				\
	$(NSS)/libpkix/pkix/certsel/pkix_certselector.c	\
	$(NSS)/libpkix/pkix/certsel/pkix_comcertselparams.c	\
	$(NSS)/libpkix/pkix/checker/pkix_basicconstraintschecker.c	\
	$(NSS)/libpkix/pkix/checker/pkix_certchainchecker.c		\
	$(NSS)/libpkix/pkix/checker/pkix_crlchecker.c			\
	$(NSS)/libpkix/pkix/checker/pkix_ekuchecker.c			\
	$(NSS)/libpkix/pkix/checker/pkix_expirationchecker.c		\
	$(NSS)/libpkix/pkix/checker/pkix_namechainingchecker.c		\
	$(NSS)/libpkix/pkix/checker/pkix_nameconstraintschecker.c	\
	$(NSS)/libpkix/pkix/checker/pkix_ocspchecker.c			\
	$(NSS)/libpkix/pkix/checker/pkix_revocationmethod.c		\
	$(NSS)/libpkix/pkix/checker/pkix_revocationchecker.c		\
	$(NSS)/libpkix/pkix/checker/pkix_policychecker.c		\
	$(NSS)/libpkix/pkix/checker/pkix_signaturechecker.c		\
	$(NSS)/libpkix/pkix/checker/pkix_targetcertchecker.c		\
	$(NSS)/libpkix/pkix/crlsel/pkix_crlselector.c			\
	$(NSS)/libpkix/pkix/crlsel/pkix_comcrlselparams.c		\
	$(NSS)/libpkix/pkix/params/pkix_trustanchor.c			\
	$(NSS)/libpkix/pkix/params/pkix_procparams.c			\
	$(NSS)/libpkix/pkix/params/pkix_valparams.c			\
	$(NSS)/libpkix/pkix/params/pkix_resourcelimits.c		\
	$(NSS)/libpkix/pkix/results/pkix_buildresult.c			\
	$(NSS)/libpkix/pkix/results/pkix_policynode.c			\
	$(NSS)/libpkix/pkix/results/pkix_valresult.c			\
	$(NSS)/libpkix/pkix/results/pkix_verifynode.c			\
	$(NSS)/libpkix/pkix/store/pkix_store.c				\
	$(NSS)/libpkix/pkix/top/pkix_validate.c				\
	$(NSS)/libpkix/pkix/top/pkix_lifecycle.c			\
	$(NSS)/libpkix/pkix/top/pkix_build.c				\
	$(NSS)/libpkix/pkix/util/pkix_tools.c				\
	$(NSS)/libpkix/pkix/util/pkix_error.c				\
	$(NSS)/libpkix/pkix/util/pkix_logger.c				\
	$(NSS)/libpkix/pkix/util/pkix_list.c				\
	$(NSS)/libpkix/pkix/util/pkix_errpaths.c			\
	$(NSS)/libpkix/pkix_pl_nss/module/pkix_pl_aiamgr.c		\
	$(NSS)/libpkix/pkix_pl_nss/module/pkix_pl_colcertstore.c	\
	$(NSS)/libpkix/pkix_pl_nss/module/pkix_pl_httpcertstore.c	\
	$(NSS)/libpkix/pkix_pl_nss/module/pkix_pl_httpdefaultclient.c	\
	$(NSS)/libpkix/pkix_pl_nss/module/pkix_pl_nsscontext.c		\
	$(NSS)/libpkix/pkix_pl_nss/module/pkix_pl_pk11certstore.c	\
	$(NSS)/libpkix/pkix_pl_nss/module/pkix_pl_socket.c		\
	$(NSS)/libpkix/pkix_pl_nss/pki/pkix_pl_basicconstraints.c	\
	$(NSS)/libpkix/pkix_pl_nss/pki/pkix_pl_cert.c			\
	$(NSS)/libpkix/pkix_pl_nss/pki/pkix_pl_certpolicyinfo.c		\
	$(NSS)/libpkix/pkix_pl_nss/pki/pkix_pl_certpolicymap.c		\
	$(NSS)/libpkix/pkix_pl_nss/pki/pkix_pl_certpolicyqualifier.c	\
	$(NSS)/libpkix/pkix_pl_nss/pki/pkix_pl_crl.c			\
	$(NSS)/libpkix/pkix_pl_nss/pki/pkix_pl_crldp.c			\
	$(NSS)/libpkix/pkix_pl_nss/pki/pkix_pl_crlentry.c		\
	$(NSS)/libpkix/pkix_pl_nss/pki/pkix_pl_date.c			\
	$(NSS)/libpkix/pkix_pl_nss/pki/pkix_pl_generalname.c		\
	$(NSS)/libpkix/pkix_pl_nss/pki/pkix_pl_infoaccess.c		\
	$(NSS)/libpkix/pkix_pl_nss/pki/pkix_pl_nameconstraints.c	\
	$(NSS)/libpkix/pkix_pl_nss/pki/pkix_pl_ocsprequest.c		\
	$(NSS)/libpkix/pkix_pl_nss/pki/pkix_pl_ocspresponse.c		\
	$(NSS)/libpkix/pkix_pl_nss/pki/pkix_pl_publickey.c		\
	$(NSS)/libpkix/pkix_pl_nss/pki/pkix_pl_x500name.c		\
	$(NSS)/libpkix/pkix_pl_nss/pki/pkix_pl_ocspcertid.c		\
	$(NSS)/libpkix/pkix_pl_nss/system/pkix_pl_bigint.c		\
	$(NSS)/libpkix/pkix_pl_nss/system/pkix_pl_bytearray.c		\
	$(NSS)/libpkix/pkix_pl_nss/system/pkix_pl_common.c		\
	$(NSS)/libpkix/pkix_pl_nss/system/pkix_pl_error.c		\
	$(NSS)/libpkix/pkix_pl_nss/system/pkix_pl_hashtable.c		\
	$(NSS)/libpkix/pkix_pl_nss/system/pkix_pl_lifecycle.c		\
	$(NSS)/libpkix/pkix_pl_nss/system/pkix_pl_mem.c			\
	$(NSS)/libpkix/pkix_pl_nss/system/pkix_pl_monitorlock.c		\
	$(NSS)/libpkix/pkix_pl_nss/system/pkix_pl_mutex.c		\
	$(NSS)/libpkix/pkix_pl_nss/system/pkix_pl_object.c		\
	$(NSS)/libpkix/pkix_pl_nss/system/pkix_pl_oid.c			\
	$(NSS)/libpkix/pkix_pl_nss/system/pkix_pl_primhash.c		\
	$(NSS)/libpkix/pkix_pl_nss/system/pkix_pl_rwlock.c		\
	$(NSS)/libpkix/pkix_pl_nss/system/pkix_pl_string.c		\
	$(NSS)/certdb/alg1485.c						\
	$(NSS)/certdb/certdb.c						\
	$(NSS)/certdb/certv3.c						\
	$(NSS)/certdb/certxutl.c					\
	$(NSS)/certdb/crl.c						\
	$(NSS)/certdb/genname.c						\
	$(NSS)/certdb/stanpcertdb.c					\
	$(NSS)/certdb/polcyxtn.c					\
	$(NSS)/certdb/secname.c						\
	$(NSS)/certdb/xauthkid.c					\
	$(NSS)/certdb/xbsconst.c					\
	$(NSS)/certdb/xconst.c						\
	$(NSS)/certhigh/certhtml.c					\
	$(NSS)/certhigh/certreq.c					\
	$(NSS)/certhigh/crlv2.c						\
	$(NSS)/certhigh/ocsp.c						\
	$(NSS)/certhigh/ocspsig.c					\
	$(NSS)/certhigh/certhigh.c					\
	$(NSS)/certhigh/certvfy.c					\
	$(NSS)/certhigh/certvfypkix.c					\
	$(NSS)/certhigh/certvfypkixprint.c				\
	$(NSS)/certhigh/xcrldist.c					\
	$(NSS)/pk11wrap/dev3hack.c					\
	$(NSS)/pk11wrap/pk11akey.c					\
	$(NSS)/pk11wrap/pk11auth.c					\
	$(NSS)/pk11wrap/pk11cert.c					\
	$(NSS)/pk11wrap/pk11cxt.c					\
	$(NSS)/pk11wrap/pk11err.c 					\
	$(NSS)/pk11wrap/pk11kea.c					\
	$(NSS)/pk11wrap/pk11list.c					\
	$(NSS)/pk11wrap/pk11load.c					\
	$(NSS)/pk11wrap/pk11mech.c					\
	$(NSS)/pk11wrap/pk11merge.c					\
	$(NSS)/pk11wrap/pk11nobj.c					\
	$(NSS)/pk11wrap/pk11obj.c					\
	$(NSS)/pk11wrap/pk11pars.c					\
	$(NSS)/pk11wrap/pk11pbe.c					\
	$(NSS)/pk11wrap/pk11pk12.c					\
	$(NSS)/pk11wrap/pk11pqg.c					\
	$(NSS)/pk11wrap/pk11sdr.c					\
	$(NSS)/pk11wrap/pk11skey.c					\
	$(NSS)/pk11wrap/pk11slot.c					\
	$(NSS)/pk11wrap/pk11util.c					\
	$(NSS)/cryptohi/sechash.c					\
	$(NSS)/cryptohi/seckey.c					\
	$(NSS)/cryptohi/secsign.c					\
	$(NSS)/cryptohi/secvfy.c					\
	$(NSS)/cryptohi/dsautil.c					\
	$(NSS)/nss/nssinit.c						\
	$(NSS)/nss/nssver.c						\
	$(NSS)/nss/utilwrap.c						\
	$(NSS)/pkcs12/p12local.c					\
        $(NSS)/pkcs12/p12creat.c					\
        $(NSS)/pkcs12/p12dec.c						\
        $(NSS)/pkcs12/p12plcy.c						\
        $(NSS)/pkcs12/p12tmpl.c						\
        $(NSS)/pkcs12/p12e.c						\
        $(NSS)/pkcs12/p12d.c						\
	$(NSS)/pkcs7/certread.c						\
	$(NSS)/pkcs7/p7common.c						\
	$(NSS)/pkcs7/p7create.c						\
	$(NSS)/pkcs7/p7decode.c						\
	$(NSS)/pkcs7/p7encode.c						\
	$(NSS)/pkcs7/p7local.c						\
	$(NSS)/pkcs7/secmime.c						\
	$(NSS)/smime/cmsarray.c						\
	$(NSS)/smime/cmsasn1.c						\
	$(NSS)/smime/cmsattr.c						\
	$(NSS)/smime/cmscinfo.c						\
	$(NSS)/smime/cmscipher.c					\
	$(NSS)/smime/cmsdecode.c					\
	$(NSS)/smime/cmsdigdata.c					\
	$(NSS)/smime/cmsdigest.c					\
	$(NSS)/smime/cmsencdata.c					\
	$(NSS)/smime/cmsencode.c					\
	$(NSS)/smime/cmsenvdata.c					\
	$(NSS)/smime/cmsmessage.c					\
	$(NSS)/smime/cmspubkey.c					\
	$(NSS)/smime/cmsrecinfo.c					\
	$(NSS)/smime/cmsreclist.c					\
	$(NSS)/smime/cmssigdata.c					\
	$(NSS)/smime/cmssiginfo.c					\
	$(NSS)/smime/cmsudf.c						\
	$(NSS)/smime/cmsutil.c						\
	$(NSS)/smime/smimemessage.c					\
	$(NSS)/smime/smimeutil.c \
	$(NSS)/smime/smimever.c \
	$(NSS)/crmf/crmfenc.c \
	$(NSS)/crmf/crmftmpl.c      \
	$(NSS)/crmf/crmfreq.c       \
	$(NSS)/crmf/crmfpop.c       \
	$(NSS)/crmf/crmfdec.c       \
	$(NSS)/crmf/crmfget.c       \
	$(NSS)/crmf/crmfcont.c      \
	$(NSS)/crmf/cmmfasn1.c      \
	$(NSS)/crmf/cmmfresp.c      \
	$(NSS)/crmf/cmmfrec.c       \
	$(NSS)/crmf/cmmfchal.c      \
	$(NSS)/crmf/servget.c       \
	$(NSS)/crmf/encutil.c       \
	$(NSS)/crmf/respcli.c       \
	$(NSS)/crmf/respcmn.c       \
	$(NSS)/crmf/challcli.c      \
	$(NSS)/crmf/asn1cmn.c       \
	$(NSS)/jar/jarver.c \
	$(NSS)/jar/jarsign.c \
	$(NSS)/jar/jar.c \
	$(NSS)/jar/jar-ds.c \
	$(NSS)/jar/jarfile.c \
	$(NSS)/jar/jarint.c \
	$(NSS)/ckfw/crypto.c   \
	$(NSS)/ckfw/find.c     \
	$(NSS)/ckfw/hash.c     \
	$(NSS)/ckfw/instance.c \
	$(NSS)/ckfw/mutex.c    \
	$(NSS)/ckfw/object.c   \
	$(NSS)/ckfw/session.c  \
	$(NSS)/ckfw/sessobj.c  \
	$(NSS)/ckfw/slot.c     \
	$(NSS)/ckfw/token.c    \
	$(NSS)/ckfw/wrap.c     \
	$(NSS)/ckfw/mechanism.c \
	$(NSS)/sysinit/nsssysinit.c	\

ifndef NSS_USE_SYSTEM_SQLITE

LOCAL_C_INCLUDES += external/nss/lib/sqlite

LOCAL_SRC_FILES +=					\
	$(NSS)/sqlite/sqlite3.c				\

endif # NSS_USE_SYSTEM_SQLITE

LOCAL_SHARED_LIBRARIES += 			\
	nssutil$(NSSUTIL_SHLIB_VERSION)		\
	$(NSPR_SHARED_LIBRARIES)		\

include $(BUILD_SHARED_LIBRARY)

################################## NSSUTIL ##################################

include $(CLEAR_VARS)

LOCAL_MODULE := nssutil$(NSSUTIL_SHLIB_VERSION)

LOCAL_CFLAGS += -DUSE_UTIL_DIRECTLY $(NSPR_CFLAGS)
LOCAL_LDLIBS += $(NSPR_LIBS)

LOCAL_C_INCLUDES :=					\
	$(NSPR_C_INCLUDES)				\

LOCAL_SRC_FILES :=					\
	$(NSS)/util/quickder.c				\
	$(NSS)/util/secdig.c				\
	$(NSS)/util/derdec.c				\
	$(NSS)/util/derenc.c				\
	$(NSS)/util/dersubr.c				\
	$(NSS)/util/dertime.c				\
	$(NSS)/util/errstrs.c				\
	$(NSS)/util/nssb64d.c				\
	$(NSS)/util/nssb64e.c				\
	$(NSS)/util/nssrwlk.c				\
	$(NSS)/util/nssilock.c				\
	$(NSS)/util/oidstring.c				\
	$(NSS)/util/portreg.c				\
	$(NSS)/util/secalgid.c				\
	$(NSS)/util/secasn1d.c				\
	$(NSS)/util/secasn1e.c				\
	$(NSS)/util/secasn1u.c				\
	$(NSS)/util/secitem.c				\
	$(NSS)/util/secload.c				\
	$(NSS)/util/secoid.c				\
	$(NSS)/util/sectime.c				\
	$(NSS)/util/secport.c				\
	$(NSS)/util/templates.c				\
	$(NSS)/util/utf8.c				\
	$(NSS)/util/utilmod.c				\
	$(NSS)/util/utilpars.c				\

LOCAL_SHARED_LIBRARIES := 				\
	$(NSPR_SHARED_LIBRARIES)			\

include $(BUILD_SHARED_LIBRARY)

################################## SOFTOKEN #################################

include $(CLEAR_VARS)

LOCAL_MODULE := softokn$(SOFTOKEN_SHLIB_VERSION)

SOFTOKEN := external/nss/lib/softoken

LOCAL_C_INCLUDES :=				\
	$(NSPR_C_INCLUDES)			\
	external/nss/lib/freebl			\
	external/nss/lib/freebl/ecl		\
	external/nss/lib/util			\

ifndef NSS_USE_SYSTEM_SQLITE
LOCAL_C_INCLUDES += external/nss/lib/sqlite
endif

LOCAL_CFLAGS :=						\
	-DXP_UNIX					\
	-DLINUX						\
	-Dlinux						\
	-DSSL_DISABLE_DEPRECATED_CIPHER_SUITE_NAMES	\
	-DSOFTOKEN_LIB_NAME=\"$(LOCAL_MODULE)\"		\
	-DUSE_UTIL_DIRECTLY				\
	-DSHLIB_PREFIX=\"lib\"				\
	-DSHLIB_SUFFIX=\"so\"				\
	-DSHLIB_VERSION=\"3\"				\
	$(NSPR_CFLAGS)					\

LOCAL_LDLIBS += $(NSPR_LIBS)

LOCAL_SRC_FILES :=				\
	$(SOFTOKEN)/fipsaudt.c			\
	$(SOFTOKEN)/fipstest.c			\
	$(SOFTOKEN)/fipstokn.c			\
	$(SOFTOKEN)/lgglue.c			\
	$(SOFTOKEN)/lowkey.c			\
	$(SOFTOKEN)/lowpbe.c			\
	$(SOFTOKEN)/padbuf.c			\
	$(SOFTOKEN)/pkcs11.c			\
	$(SOFTOKEN)/pkcs11c.c			\
	$(SOFTOKEN)/pkcs11u.c			\
	$(SOFTOKEN)/sdb.c			\
	$(SOFTOKEN)/sftkdb.c			\
	$(SOFTOKEN)/sftkhmac.c			\
	$(SOFTOKEN)/sftkpars.c			\
	$(SOFTOKEN)/sftkpwd.c			\
	$(SOFTOKEN)/softkver.c			\
	$(SOFTOKEN)/tlsprf.c			\
	$(SOFTOKEN)/jpakesftk.c			\

LOCAL_STATIC_LIBRARIES +=			\
	freebl					\

LOCAL_SHARED_LIBRARIES +=			\
	nssutil$(NSSUTIL_SHLIB_VERSION)		\
	$(NSPR_SHARED_LIBRARIES)		\

include $(BUILD_SHARED_LIBRARY)

##################################### FREEBL #################################

FREEBL_C_INCLUDES :=					\
	$(NSPR_C_INCLUDES)				\
	external/nss/lib/freebl/ecl			\
	external/nss/lib/freebl/mpi			\
	external/nss/lib/softoken			\
	external/nss/lib/util				\

FREEBL_CFLAGS +=						\
	$(NSPR_CFLAGS)						\
	-fPIC							\
	-DRIJNDAEL_INCLUDE_TABLES				\
	-DMP_API_COMPATIBLE					\
	-DSHLIB_PREFIX=\"$(SHLIB_PREFIX)\"			\
	-DSHLIB_SUFFIX=\"$(SHLIB_SUFFIX)\"			\
	-DSOFTOKEN_SHLIB_VERSION=\"$(SOFTOKEN_SHLIB_VERSION)\"	\
	-DSHLIB_VERSION=\"$(FREEBL_SHLIB_VERSION)\"		\
	$(NSS_USE_64:%=-DNSS_USE_64)				\

FREEBL_LDLIBS += $(NSPR_LIBS)

FREEBL_SRC_FILES :=					\
	$(NSS)/freebl/freeblver.c			\
	$(NSS)/freebl/ldvector.c			\
	$(NSS)/freebl/sysrand.c				\
	$(NSS)/freebl/sha_fast.c			\
	$(NSS)/freebl/md2.c				\
	$(NSS)/freebl/md5.c				\
	$(NSS)/freebl/sha512.c				\
	$(NSS)/freebl/alghmac.c				\
	$(NSS)/freebl/rawhash.c				\
	$(NSS)/freebl/alg2268.c				\
	$(NSS)/freebl/arcfour.c				\
	$(NSS)/freebl/arcfive.c				\
	$(NSS)/freebl/desblapi.c			\
	$(NSS)/freebl/des.c				\
	$(NSS)/freebl/drbg.c				\
	$(NSS)/freebl/cts.c				\
	$(NSS)/freebl/ctr.c				\
	$(NSS)/freebl/gcm.c				\
	$(NSS)/freebl/hmacct.c				\
	$(NSS)/freebl/rijndael.c			\
	$(NSS)/freebl/aeskeywrap.c			\
	$(NSS)/freebl/camellia.c			\
	$(NSS)/freebl/dh.c				\
	$(NSS)/freebl/ec.c				\
	$(NSS)/freebl/ecdecode.c			\
	$(NSS)/freebl/pqg.c				\
	$(NSS)/freebl/dsa.c				\
	$(NSS)/freebl/rsa.c				\
	$(NSS)/freebl/rsapkcs.c				\
	$(NSS)/freebl/shvfy.c				\
	$(NSS)/freebl/tlsprfalg.c			\
	$(NSS)/freebl/seed.c				\
	$(NSS)/freebl/jpake.c				\
	$(NSS)/freebl/mpi/mpprime.c			\
	$(NSS)/freebl/mpi/mpmontg.c			\
	$(NSS)/freebl/mpi/mplogic.c			\
	$(NSS)/freebl/mpi/mpi.c				\
	$(NSS)/freebl/mpi/mp_gf2m.c			\
	$(NSS)/freebl/mpi/mpcpucache.c			\

ifndef NSS_DISABLE_ECC

FREEBL_SRC_FILES +=					\
	$(NSS)/freebl/ecl/ecl.c				\
	$(NSS)/freebl/ecl/ecl_curve.c			\
	$(NSS)/freebl/ecl/ecl_mult.c			\
	$(NSS)/freebl/ecl/ecl_gf.c			\
	$(NSS)/freebl/ecl/ecp_aff.c			\
	$(NSS)/freebl/ecl/ecp_jac.c			\
	$(NSS)/freebl/ecl/ecp_mont.c			\
	$(NSS)/freebl/ecl/ec_naf.c			\
	$(NSS)/freebl/ecl/ecp_jm.c			\
	$(NSS)/freebl/ecl/ecp_256.c			\
	$(NSS)/freebl/ecl/ecp_384.c			\
	$(NSS)/freebl/ecl/ecp_521.c			\
	$(NSS)/freebl/ecl/ecp_256_32.c			\

ifdef NSS_ECC_MORE_THAN_SUITE_B

FREEBL_SRC_FILES +=					\
	$(NSS)/freebl/ecl/ec2_aff.c			\
	$(NSS)/freebl/ecl/ec2_mont.c			\
	$(NSS)/freebl/ecl/ec2_proj.c			\
	$(NSS)/freebl/ecl/ec2_163.c			\
	$(NSS)/freebl/ecl/ec2_193.c			\
	$(NSS)/freebl/ecl/ec2_233.c			\
	$(NSS)/freebl/ecl/ecp_192.c			\
	$(NSS)/freebl/ecl/ecp_224.c			\

endif # NSS_ECC_MORE_THAN_SUITE_B
endif # NSS_DISABLE_ECC

# Static library

include $(CLEAR_VARS)
LOCAL_MODULE     := freebl
LOCAL_C_INCLUDES := $(FREEBL_C_INCLUDES)
LOCAL_CFLAGS     := $(FREEBL_CFLAGS)
LOCAL_SRC_FILES  := $(NSS)/freebl/loader.c
LOCAL_SRC_FILES  += $(FREEBL_SRC_FILES)
include $(BUILD_STATIC_LIBRARY)

# Shared library

include $(CLEAR_VARS)
LOCAL_MODULE     := freebl$(FREEBL_SHLIB_VERSION)
LOCAL_C_INCLUDES := $(FREEBL_C_INCLUDES)
LOCAL_CFLAGS     := $(FREEBL_CFLAGS)
LOCAL_LDLIBS     := $(FREEBL_LDLIBS)
LOCAL_SRC_FILES  := $(FREEBL_SRC_FILES)
include $(BUILD_SHARED_LIBRARY)

################################### NSSDBM3 ##################################

include $(CLEAR_VARS)

LOCAL_MODULE := nssdbm$(NSSDBM_SHLIB_VERSION)

NSS_DBM := external/nss/lib/softoken/legacydb

LOCAL_C_INCLUDES +=					\
	$(NSPR_C_INCLUDES)				\
	external/nss/lib/dbm/include			\
	external/nss/lib/freebl				\
	external/nss/lib/freebl/ecl			\
	external/nss/lib/softoken			\
	external/nss/lib/util				\

LOCAL_CFLAGS +=						\
	$(NSPR_CFLAGS)					\
	-DSHLIB_PREFIX=\"$(SHLIB_PREFIX)\"		\
	-DSHLIB_SUFFIX=\"$(SHLIB_SUFFIX)\"		\

LOCAL_LDLIBS += $(NSPR_LIBS)

LOCAL_SRC_FILES +=					\
	$(NSS_DBM)/dbmshim.c				\
	$(NSS_DBM)/keydb.c				\
	$(NSS_DBM)/lgattr.c				\
	$(NSS_DBM)/lgcreate.c				\
	$(NSS_DBM)/lgdestroy.c				\
	$(NSS_DBM)/lgfind.c				\
	$(NSS_DBM)/lginit.c				\
	$(NSS_DBM)/lgutil.c				\
	$(NSS_DBM)/lowcert.c				\
	$(NSS_DBM)/lowkey.c				\
	$(NSS_DBM)/pcertdb.c				\
	$(NSS_DBM)/pk11db.c				\

ifndef NSS_DISABLE_DBM

LOCAL_CFLAGS += 					\
	-DMEMMOVE					\
	-D__DBINTERFACE_PRIVATE				\

LOCAL_SRC_FILES +=					\
	$(NSS)/dbm/src/db.c       			\
	$(NSS)/dbm/src/h_bigkey.c      			\
	$(NSS)/dbm/src/h_func.c      			\
	$(NSS)/dbm/src/h_log2.c      			\
	$(NSS)/dbm/src/h_page.c      			\
	$(NSS)/dbm/src/hash.c      			\
	$(NSS)/dbm/src/hash_buf.c      			\
	$(NSS)/dbm/src/mktemp.c      			\
	$(NSS)/dbm/src/dirent.c      			\

endif # NSS_DISABLE_DBM

LOCAL_STATIC_LIBRARIES += 				\
	freebl						\

LOCAL_SHARED_LIBRARIES +=				\
	nssutil$(NSSUTIL_SHLIB_VERSION)			\

include $(BUILD_SHARED_LIBRARY)

##################################### SSL ####################################

include $(CLEAR_VARS)

LOCAL_MODULE := ssl$(SSL_SHLIB_VERSION)

LOCAL_CFLAGS := $(NSPR_CFLAGS)

LOCAL_C_INCLUDES :=					\
	$(NSPR_C_INCLUDES)				\
	external/nss/lib/certdb				\
	external/nss/lib/certhigh			\
	external/nss/lib/cryptohi			\
	external/nss/lib/freebl				\
	external/nss/lib/freebl/ecl			\
	external/nss/lib/nss				\
	external/nss/lib/pk11wrap			\
	external/nss/lib/pkcs7				\
	external/nss/lib/smime				\
	external/nss/lib/util				\

LOCAL_SRC_FILES :=					\
	$(NSS)/ssl/derive.c				\
	$(NSS)/ssl/dtlscon.c				\
	$(NSS)/ssl/prelib.c				\
	$(NSS)/ssl/ssl3con.c				\
	$(NSS)/ssl/ssl3gthr.c				\
	$(NSS)/ssl/sslauth.c				\
	$(NSS)/ssl/sslcon.c				\
	$(NSS)/ssl/ssldef.c				\
	$(NSS)/ssl/sslenum.c				\
	$(NSS)/ssl/sslerr.c				\
	$(NSS)/ssl/sslerrstrs.c				\
	$(NSS)/ssl/sslinit.c				\
	$(NSS)/ssl/ssl3ext.c				\
	$(NSS)/ssl/sslgathr.c				\
	$(NSS)/ssl/sslmutex.c				\
	$(NSS)/ssl/sslnonce.c				\
	$(NSS)/ssl/sslreveal.c				\
	$(NSS)/ssl/sslsecur.c				\
	$(NSS)/ssl/sslsnce.c				\
	$(NSS)/ssl/sslsock.c				\
	$(NSS)/ssl/ssltrace.c				\
	$(NSS)/ssl/sslver.c				\
	$(NSS)/ssl/authcert.c				\
	$(NSS)/ssl/cmpcert.c				\
	$(NSS)/ssl/sslinfo.c				\
	$(NSS)/ssl/ssl3ecc.c				\
	$(NSS)/ssl/unix_err.c				\

LOCAL_LDLIBS += $(NSPR_LIBS)
LOCAL_SHARED_LIBRARIES += $(NSPR_SHARED_LIBRARIES)

include $(BUILD_SHARED_LIBRARY)

################################### NSSCKBI ##################################

include $(CLEAR_VARS)

LOCAL_MODULE := nssckbi

LOCAL_CFLAGS := $(NSPR_CFLAGS)

LOCAL_C_INCLUDES :=				\
	$(NSPR_C_INCLUDES)			\
	external/nss/lib/base			\
	external/nss/lib/ckfw/builtins		\
	external/nss/lib/ckfw			\
	external/nss/lib/util			\

LOCAL_SRC_FILES :=				\
	$(NSS)/ckfw/builtins/anchor.c		\
	$(NSS)/ckfw/builtins/constants.c	\
        $(NSS)/ckfw/builtins/bfind.c		\
        $(NSS)/ckfw/builtins/binst.c		\
        $(NSS)/ckfw/builtins/bobject.c		\
        $(NSS)/ckfw/builtins/bsession.c		\
        $(NSS)/ckfw/builtins/bslot.c		\
        $(NSS)/ckfw/builtins/btoken.c		\
        $(NSS)/ckfw/builtins/certdata.c		\
        $(NSS)/ckfw/builtins/ckbiver.c		\

LOCAL_LDLIBS += $(NSPR_LIBS)
LOCAL_SHARED_LIBRARIES += $(NSPR_SHARED_LIBRARIES)

NSS_CERTDATA_PERL = $(NSS)/ckfw/builtins/certdata.perl
NSS_CERTDATA_TXT  = $(NSS)/ckfw/builtins/certdata.txt

out/$(NSS)/ckfw/builtins/certdata.c:	\
	$(NSS_CERTDATA_PERL)		\
	$(NSS_CERTDATA_TXT)		\

	$(PERL) $(NSS_CERTDATA_PERL) < $(NSS_CERTDATA_TXT) > $@

include $(BUILD_SHARED_LIBRARY)

endif # WITH_SYSTEM_NSS

##############################################################################
