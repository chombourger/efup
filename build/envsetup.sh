#!/bin/bash

set_efup_env() {
   if [ -d build -a -f build/envsetup.sh ]
   then
      EFUP_DIR=${PWD}
      export EFUP_DIR
      unset EFUP_CONFIGS
      unset EFUP_VARIANTS
      return 0
   else
      echo "error: source build/envsetup.sh from the toplevel directory!" 2>&1
      return 1
   fi
}

add_efup_config() {
   local new_config=${1}
   local c
   for c in ${EFUP_CONFIGS[@]}; do
      if [ "${new_config}" = "${c}" ] ; then
         return
      fi
   done
   EFUP_CONFIGS=(${EFUP_CONFIGS[@]} ${new_config})
}

add_efup_configs() {
   local c
   for c in ${EFUP_DIR}/configs/*/settings.inc; do
      test ! -f ${c} && continue
      c=`dirname ${c}`
      c=`basename ${c}`
      add_efup_config ${c}
   done
}

is_efup_config() {
   local config=${1}
   local c
   for c in ${EFUP_CONFIGS[@]}; do
      if [ "${config}" = "${c}" ] ; then
         return 0
      fi
   done
   return 1
}

reset_efup_config() {
   unset TOOLCHAIN_GIT_SUBMODULE
   unset TOOLCHAIN_PATH
   unset HOST
   unset SYSROOT
   unset UBOOT_GIT_SUBMODULE
   unset UBOOT_PATH
   unset UBOOT_CONFIG
   unset LINUX_GIT_SUBMODULE
   unset LINUX_PATH
   unset LINUX_CONFIG
   unset LINUX_MAKE_GOALS
}

print_efup_config() {
   echo
   test -n "${HOST}" && \
      echo "HOST=${HOST}"
   test -n "${TOOLCHAIN_PATH}" && \
      echo "TOOLCHAIN_PATH=${TOOLCHAIN_PATH}"
   test -n "${SYSROOT}" && \
      echo "SYSROOT=${SYSROOT}"
   test -n "${UBOOT_PATH}" && \
      echo "UBOOT_PATH=${UBOOT_PATH}"
   test -n "${UBOOT_CONFIG}" && \
      echo "UBOOT_CONFIG=${UBOOT_CONFIG}"
   test -n "${LINUX_PATH}" && \
      echo "LINUX_PATH=${LINUX_PATH}"
   test -n "${LINUX_CONFIG}" && \
      echo "LINUX_CONFIG=${LINUX_CONFIG}"
   echo
}

load_efup_config() {
   local config=${1}

   reset_efup_config
   if source ${EFUP_DIR}/configs/${config}/settings.inc; then
      if [ -n "${EXTERNAL_TOOLCHAIN}" -a -z "${TOOLCHAIN_PATH}" ]; then
         TOOLCHAIN_PATH=${EXTERNAL_TOOLCHAIN}
         export PATH=${TOOLCHAIN_PATH}/bin:${PATH}
      fi
      if [ -n "${TOOLCHAIN_GIT_SUBMODULE}" -a -z "${TOOLCHAIN_PATH}" ]; then
         TOOLCHAIN_PATH=${TOOLCHAIN_GIT_SUBMODULE}
         export PATH=${PWD}/${TOOLCHAIN_PATH}/bin:${PATH}
      fi
      if [ -n "${UBOOT_GIT_SUBMODULE}" -a -z "${UBOOT_PATH}" ]; then
         UBOOT_PATH=${UBOOT_GIT_SUBMODULE}
      fi
      if [ -n "${LINUX_GIT_SUBMODULE}" -a -z "${LINUX_PATH}" ]; then
         LINUX_PATH=${LINUX_GIT_SUBMODULE}
      fi
      export SYSROOT
      export PKG_CONFIG_DIR=
      export PKG_CONFIG_LIBDIR=${SYSROOT}/usr/lib/pkgconfig:${SYSROOT}/usr/share/pkgconfig
      export PKG_CONFIG_SYSROOT_DIR=${SYSROOT}
      return 0
   else
      return 1
   fi
}

add_efup_variant() {
   local new_variant=${1}
   local v
   for v in ${EFUP_VARIANTS[@]}; do
      if [ "${new_variant}" = "${v}" ] ; then
         return
      fi
   done
   EFUP_VARIANTS=(${EFUP_VARIANTS[@]} ${new_variant})
}

print_lunch_menu() {
   local i=1
   local c
   echo
   echo "Lunch menu... pick one of these:"
   for c in ${EFUP_CONFIGS[@]}
   do
      echo "     ${i}. ${c}"
      i=$((${i}+1))
   done
   echo
}

print_cooked_menu() {
   local i=1
   local v
   echo
   echo "How would you like it cooked:"
   for v in ${EFUP_VARIANTS[@]}
   do
      echo "     ${i}. ${v}"
      i=$((${i}+1))
   done
   echo
}

lunch() {
   local config target variant
   local c v

   unset EFUP_CONFIG
   unset EFUP_VARIANT

   if [ -n "${1}" ]; then
      target=${1}
   else
      print_lunch_menu
      echo -n "Your choice: "
      read c
      if (echo -n ${c} | grep -q -e "^[0-9][0-9]*$"); then
         config=${EFUP_CONFIGS[$((${c}-1))]}
         print_cooked_menu
         echo -n "Your choice: "
         read v
         if (echo -n ${v} | grep -q -e "^[0-9][0-9]*$"); then
            variant=${EFUP_VARIANTS[$((${v}-1))]}
            target=${config}-${variant}
         else
            echo "error: invalid choice!" 2>&1
            return 1
         fi
      else
         echo "error: invalid choice!" 2>&1
         return 1
      fi
   fi

   for v in ${EFUP_VARIANTS[@]}; do
      if [[ "${target}" == *-${v} ]]; then
         config=${target/%-${v}/}
         variant=${v}
      fi
   done

   if is_efup_config "${config}"; then
      EFUP_CONFIG=${config}
      EFUP_VARIANT=${variant}
      if load_efup_config ${config}; then
         print_efup_config
         export EFUP_CONFIG
         export EFUP_VARIANT
      else
         EFUP_CONFIG=
         EFUP_VARIANT=
         echo "error: error loading configuration \"${config}\"" 2>&1
         return 1
      fi
   else
      echo "error: \"${config}\" is not a valid efup configuration!" 2>&1
      return 1
   fi
}

configure() {
   local prod_config_args="--disable-debug --disable-debug-support"
   local eng_config_args="--enable-debug --disable-debug-support"
   local debug_config_args="--enable-debug --enable-debug-support"
   local config=${EFUP_CONFIG}
   local variant=${EFUP_VARIANT}
   local config_args

   if [ -n "${config}" -a -n "${variant}" ]; then
      config_args=$(eval echo \$${variant}_config_args)
      if [ -n "${HOST}" ]; then
         config_args="${config_args} --host=${HOST}"
      fi
      if [ ! -f ${EFUP_DIR}/configure ]; then
         if ! ( cd ${EFUP_DIR} && ./autogen.sh ); then
             echo "error: failed to generate \"configure\" file!" 2>&1
             return 1
         fi
      fi
      ${EFUP_DIR}/configure ${config_args} ${*}
   else
      echo "error: run \"lunch\" before configure!" 2>&1
      return 1
   fi
}

fetch-dependencies() {
   local ret

   if [ -n "${TOOLCHAIN_GIT_SUBMODULE}" ]; then
      git submodule init ${TOOLCHAIN_GIT_SUBMODULE} && \
      git submodule update ${TOOLCHAIN_GIT_SUBMODULE}
      ret=${?}
   else
      ret=0
   fi

   test ${ret} -eq 0 || return ${ret}

   if [ -n "${UBOOT_GIT_SUBMODULE}" ]; then
      git submodule init ${UBOOT_GIT_SUBMODULE} && \
      git submodule update ${UBOOT_GIT_SUBMODULE}
      ret=${?}
   else
      ret=0
   fi

   test ${ret} -eq 0 || return ${ret}

   if [ -n "${LINUX_GIT_SUBMODULE}" ]; then
      git submodule init ${LINUX_GIT_SUBMODULE} && \
      git submodule update ${LINUX_GIT_SUBMODULE}
      ret=${?}
   else
      ret=0
   fi

   return ${ret}
}

set_efup_env           && \
add_efup_variant prod  && \
add_efup_variant eng   && \
add_efup_variant debug && \
add_efup_configs

