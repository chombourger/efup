##############################################################################
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
##############################################################################

ifndef WITH_SYSTEM_E2FSPROGS

include $(CLEAR_VARS)
LOCAL_MODULE := mke2fs

S = $(LOCAL_PATH)/external/e2fsprogs

LOCAL_C_INCLUDES +=				\
	$(outdir)/external/e2fsprogs/lib	\
	.					\
	include					\
	$(outdir)/external/e2fsprogs/e2fsck	\
	external/e2fsprogs/e2fsck		\
	$(S)/lib

LOCAL_GEN_FILES +=						\
	out/target/external/e2fsprogs/lib/ext2fs/ext2_err.h	\
	out/target/external/e2fsprogs/e2fsck/prof_err.h		\
	out/target/external/e2fsprogs/misc/default_profile.c

LOCAL_SRC_FILES += 						\
	$(S)/lib/e2p/parse_num.c				\
	$(S)/lib/et/com_err.c					\
	$(S)/lib/et/error_message.c				\
	$(S)/lib/et/et_name.c					\
	$(S)/lib/e2p/feature.c					\
	$(S)/lib/e2p/hashstr.c					\
	$(S)/lib/e2p/mntopts.c					\
	$(S)/lib/e2p/ostype.c					\
	$(S)/lib/e2p/uuid.c					\
	$(S)/lib/ext2fs/alloc.c					\
	$(S)/lib/ext2fs/alloc_sb.c				\
	$(S)/lib/ext2fs/alloc_stats.c				\
	$(S)/lib/ext2fs/alloc_tables.c				\
	$(S)/lib/ext2fs/badblocks.c				\
	$(S)/lib/ext2fs/bb_inode.c				\
	$(S)/lib/ext2fs/bitmaps.c				\
	$(S)/lib/ext2fs/bitops.c				\
	$(S)/lib/ext2fs/blkmap64_ba.c				\
	$(S)/lib/ext2fs/blkmap64_rb.c				\
	$(S)/lib/ext2fs/blknum.c				\
	$(S)/lib/ext2fs/block.c					\
	$(S)/lib/ext2fs/bmap.c					\
	$(S)/lib/ext2fs/closefs.c				\
	$(S)/lib/ext2fs/crc16.c					\
	$(S)/lib/ext2fs/csum.c					\
	$(S)/lib/ext2fs/dblist.c				\
	$(S)/lib/ext2fs/dir_iterate.c				\
	$(S)/lib/ext2fs/dirblock.c				\
	$(S)/lib/ext2fs/expanddir.c				\
	$(S)/lib/ext2fs/extent.c				\
	$(S)/lib/ext2fs/fileio.c				\
	$(S)/lib/ext2fs/freefs.c				\
	$(S)/lib/ext2fs/gen_bitmap.c				\
	$(S)/lib/ext2fs/gen_bitmap64.c				\
	$(S)/lib/ext2fs/getsectsize.c				\
	$(S)/lib/ext2fs/getsize.c				\
	$(S)/lib/ext2fs/i_block.c				\
	$(S)/lib/ext2fs/ind_block.c				\
	$(S)/lib/ext2fs/initialize.c				\
	$(S)/lib/ext2fs/inline.c				\
	$(S)/lib/ext2fs/inode.c					\
	$(S)/lib/ext2fs/io_manager.c				\
	$(S)/lib/ext2fs/ismounted.c				\
	$(S)/lib/ext2fs/link.c					\
	$(S)/lib/ext2fs/llseek.c				\
	$(S)/lib/ext2fs/lookup.c				\
	$(S)/lib/ext2fs/mkdir.c					\
	$(S)/lib/ext2fs/mkjournal.c				\
	$(S)/lib/ext2fs/mmp.c					\
	$(S)/lib/ext2fs/newdir.c				\
	$(S)/lib/ext2fs/openfs.c				\
	$(S)/lib/ext2fs/progress.c				\
	$(S)/lib/ext2fs/punch.c					\
	$(S)/lib/ext2fs/rbtree.c				\
	$(S)/lib/ext2fs/read_bb.c				\
	$(S)/lib/ext2fs/read_bb_file.c				\
	$(S)/lib/ext2fs/res_gdt.c				\
	$(S)/lib/ext2fs/rw_bitmaps.c				\
	$(S)/lib/ext2fs/tdb.c					\
	$(S)/lib/ext2fs/undo_io.c				\
	$(S)/lib/ext2fs/unix_io.c				\
	$(S)/lib/ext2fs/valid_blk.c				\
	$(S)/lib/quota/mkquota.c				\
	$(S)/lib/quota/quotaio.c				\
	$(S)/lib/quota/quotaio_tree.c				\
	$(S)/lib/quota/quotaio_v2.c				\
	$(S)/e2fsck/dict.c					\
	$(S)/e2fsck/profile.c					\
	$(S)/misc/mk_hugefiles.c				\
	$(S)/misc/mke2fs.c					\
	$(S)/misc/util.c					\
	out/target/external/e2fsprogs/lib/ext2fs/ext2_err.c	\
	out/target/external/e2fsprogs/e2fsck/prof_err.c		\
	out/target/external/e2fsprogs/misc/default_profile.c

LOCAL_STATIC_LIBRARIES = blkid uuid

out/target/external/e2fsprogs/misc/default_profile.c:		\
	external/e2fsprogs/misc/mke2fs.conf.in			\
	external/e2fsprogs/misc/profile-to-c.awk
	$(MKDIR_P) $(dir $@)
	$(AWK) -f external/e2fsprogs/misc/profile-to-c.awk	\
		< external/e2fsprogs/misc/mke2fs.conf.in	\
		> $@

out/host/external/e2fsprogs/util/subst.o:		\
	external/e2fsprogs/util/subst.c

out/host/external/e2fsprogs/util/subst:			\
	out/host/external/e2fsprogs/util/subst.o
	$(MKDIR_P) $(dir $@)
	$(BUILD_CC) -o $@ $<

out/host/external/e2fsprogs/lib/et/compile_et:		\
	external/e2fsprogs/lib/et/compile_et.sh.in	\
	out/host/external/e2fsprogs/util/subst
	$(MKDIR_P) $(dir $@)
	out/host/external/e2fsprogs/util/subst -f external/e2fsprogs/util/subst.conf $< $@
	chmod +x $@

$(outdir)/external/e2fsprogs/lib/ext2fs/ext2_err.et:			\
	external/e2fsprogs/lib/ext2fs/ext2_err.et.in			\
	out/host/external/e2fsprogs/util/subst
	$(MKDIR_P) $(dir $@)
	out/host/external/e2fsprogs/util/subst -f external/e2fsprogs/util/subst.conf $< $@

$(outdir)/external/e2fsprogs/lib/ext2fs/ext2_err.c			\
$(outdir)/external/e2fsprogs/lib/ext2fs/ext2_err.h:			\
	$(outdir)/external/e2fsprogs/lib/ext2fs/ext2_err.et		\
	out/host/external/e2fsprogs/lib/et/compile_et
	@echo "GEN ext2_err.{c,h} ($(notdir $@))"
	$(MKDIR_P) $(dir $@)
	ET_DIR=external/e2fsprogs/lib/et					\
	out/host/external/e2fsprogs/lib/et/compile_et --build-tree $< &&	\
	mv -f ext2_err.c ext2_err.h $(dir $@)/

$(outdir)/external/e2fsprogs/e2fsck/prof_err.c					\
$(outdir)/external/e2fsprogs/e2fsck/prof_err.h:					\
	external/e2fsprogs/e2fsck/prof_err.et					\
	out/host/external/e2fsprogs/lib/et/compile_et
	@echo "GEN prof_err.{c,h} ($(notdir $@))"
	$(MKDIR_P) $(dir $@)
	ET_DIR=external/e2fsprogs/lib/et					\
	out/host/external/e2fsprogs/lib/et/compile_et --build-tree $< &&	\
	mv -f prof_err.c prof_err.h $(dir $@)/

include $(BUILD_EXECUTABLE)

endif # WITH_SYSTEM_E2FSPROGS

##############################################################################

