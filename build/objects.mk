# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

outdir := out/target

$(module)_gen_files := $(LOCAL_GEN_FILES)
$(module)_gen_c_files := $(filter %.c, $($(module)_gen_files))
$(module)_gen_h_files := $(filter %.h, $($(module)_gen_files))
$(module)_c_files := $(filter %.c, $(LOCAL_SRC_FILES))
$(module)_cxx_files := $(filter %.cpp, $(LOCAL_SRC_FILES))
$(module)_s_files := $(filter %.s, $(LOCAL_SRC_FILES))

$(module)_o_files :=					\
	$($(module)_c_files:%.c=$(outdir)/%.o)		\
	$($(module)_cxx_files:%.cpp=$(outdir)/%.o)	\
	$($(module)_s_files:%.s=$(outdir)/%.o)

clean_targets := $(clean_targets) $($(module)_o_files)

$(module)_cflags   := $(sys_cflags) $(LOCAL_CFLAGS)
$(module)_cppflags := $(sys_cppflags) $(LOCAL_CPPFLAGS) $(LOCAL_C_INCLUDES:%=-I%)

$(module)_ldflags  := $(sys_ldflags) $(LOCAL_LDFLAGS)
$(module)_ldlibs   := $(sys_ldlibs) $(LOCAL_LDLIBS)

