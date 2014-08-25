/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include <efup/verifier.h>

#include <cert.h>
#include <cms.h>
#include <errno.h>
#include <nspr.h>
#include <nss.h>
#include <stdio.h>

/** Usage to be provided during the verification process. */
#define NSS_CERT_USAGE certUsageObjectSigner

#define NSS_ARENA_SIZE 4096

/** Memory pool for NSS. */
static PLArenaPool *arenap = NULL;

/** The NSS Decoder context. */
static NSSCMSDecoderContext *contextp = NULL;

static void
content_cb (void *arg, const char *buf, unsigned long len) {
    /* nop */
}

int
verifier_init(const char *path) {
    SECStatus sts;
    int result;

    /* Initialize NSPR and NSS */
    PR_Init(PR_SYSTEM_THREAD, PR_PRIORITY_NORMAL, 1);
    sts = NSS_InitReadWrite(path);
    if (sts == SECSuccess) {
        /* Create pool arena. */
        arenap = PORT_NewArena(NSS_ARENA_SIZE);
        if (arenap != NULL) {
            result = 0;
        }
        else {
            (void) NSS_Shutdown();
            result = ENOMEM;
        }
    }
    else result = EBADFD;

    return result;
}

int
verifier_prepare(void) {
    int result;

    if (arenap != NULL) {
        contextp = NSS_CMSDecoder_Start(arenap, content_cb, NULL, 0, 0, 0, 0);
        if (contextp != NULL) {
            result = 0;
        }
        else result = ENOMEM;
    }
    else result = EPROTO;

    return result;
}

int
verifier_feed(void *buf, size_t size) {
    SECStatus status;
    int result;

    if (contextp != NULL) {
        status = NSS_CMSDecoder_Update(contextp, buf, size);
        result = (status == SECSuccess) ? 0 : EIO;
    }
    else result = EPROTO;

    return result;
}

/**
  * Verify the nth signature of the signed message.
  *
  * @param decoder the decoder descriptor.
  * @param p_signed_data pointer to the signed data descriptor.
  * @param signer index of the signer to be checked.
  *
  * @return P7V_OK on success, an error code otherwise.
  *
  */
static int
verify_signer (NSSCMSSignedData *datap, unsigned int signer) {
   SECStatus status;
   int result;

   /* Get verification status. */
   status = NSS_CMSSignedData_VerifySignerInfo(datap, signer, CERT_GetDefaultCertDB(), NSS_CERT_USAGE);
   result = (status == SECSuccess) ? 0 : EIO;

   return result; 
}

/**
  * Verify the signatures found in the signed message.
  *
  * @param datap pointer to the signed data descriptor.
  *
  * @return zero on success, an error code otherwise.
  *
  */
static int
verify_signers(NSSCMSSignedData *datap) {
   unsigned int signers, signer;
   SECStatus status;
   int result;

   status = NSS_CMSSignedData_ImportCerts(datap, CERT_GetDefaultCertDB(), NSS_CERT_USAGE, PR_TRUE);
   if (status == SECSuccess) {
      signers = NSS_CMSSignedData_SignerInfoCount(datap);
      for (signer=0; signer<signers; signer++) {
         result = verify_signer(datap, signer);
         if (result != 0) break;
      }
   }
   else result = EIO;

   return result;
}


/**
  * Check the message integrity and in particular certificates of the signer(s).
  *
  * @param messagep pointer to the message to be checked.
  *
  * @return zero on success, an error code otherwise.
  *
  */
static int
check_message (NSSCMSMessage *messagep) {
    unsigned int level_count, i;
    NSSCMSSignedData *datap;
    NSSCMSContentInfo *infop;
    SECOidTag type;
    int result;

   if (NSS_CMSMessage_IsSigned(messagep)) {
      level_count = NSS_CMSMessage_ContentLevelCount(messagep);
      for (i = 0; i < level_count; i++) {

         infop = NSS_CMSMessage_ContentLevel(messagep, i);
         type  = NSS_CMSContentInfo_GetContentTypeTag(infop);

         if (type == SEC_OID_PKCS7_SIGNED_DATA) {
            datap = (NSSCMSSignedData *) NSS_CMSContentInfo_GetContent(infop);
            result = verify_signers(datap);
            if (result != 0) break;
         }
      }
   }
   return result; 
}

int
verifier_finish(void) {
    NSSCMSMessage *messagep;
    int result;

    if (contextp != NULL) {
        messagep = NSS_CMSDecoder_Finish(contextp);
        if (messagep != NULL) {
            result = check_message(messagep);
            NSS_CMSMessage_Destroy(messagep);
        }
        else result = EINVAL;
    }
    else result = EPROTO;

    return result;
}

void
verifier_destroy(void) {
    if (arenap) { 
        PORT_FreeArena(arenap, PR_FALSE);
        arenap = NULL;
    }

    (void) NSS_Shutdown();
}

