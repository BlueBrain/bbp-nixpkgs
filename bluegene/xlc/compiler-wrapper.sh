#!/bin/bash

if [[ -z $LANG || $LANG = C || $LANG = POSIX ]]; then
  LANG=en_US
fi
export LANG
export NLSPATH=@xlcPrefix@/msg/%L/%N:/opt/ibmcmp/vacpp/bg/12.1/msg/%L/%N
export LD_LIBRARY_PATH=@xlcPrefix@/lib:$LD_LIBRARY_PATH
export OS_RELEASE=`/usr/bin/head -1 /etc/redhat-release | sed -e "s/.*release[ \t]*\([0-9\.]*\).*/\1/g"`
export XLCMP_CFG=@xlcPrefix@/vac/bg/12.1/etc/vac.cfg.rhel${OS_RELEASE}.gcc447

# avoid to pass useles options to linker
# warnings when they are not needed.
dontLink=0
getVersion=0
nonFlagArgs=0

for i in "$@"; do
    if [ "$i" = -c ]; then
        dontLink=1
    elif [ "$i" = -S ]; then
        dontLink=1
    elif [ "$i" = -E ]; then
        dontLink=1
    elif [ "$i" = -E ]; then
        dontLink=1
    elif [ "$i" = -M ]; then
        dontLink=1
    elif [ "$i" = -MM ]; then
        dontLink=1
    elif [ "$i" = -x ]; then
        # At least for the cases c-header or c++-header we should set dontLink.
        # I expect no one use -x other than making precompiled headers.
        dontLink=1
    elif [ "${i:0:1}" != - ]; then
        nonFlagArgs=1
    fi
done

# If we pass a flag like -Wl, then gcc will call the linker unless it
# can figure out that it has to do something else (e.g., because of a
# "-c" flag).  So if no non-flag arguments are given, don't pass any
# linker flags.  This catches cases like "gcc" (should just print
# "gcc: no input files") and "gcc -v" (should print the version).
if [ "$nonFlagArgs" = 0 ]; then
    dontLink=1
fi


# Optionally filter out paths not refering to the store.
params=("$@")

# Add the flags for the C compiler proper.
extraAfter=($NIX_CFLAGS_COMPILE)
extraBefore=()

if [ "$dontLink" != 1 ]; then

    # Add the flags that should only be passed to the compiler when
    # linking.
    extraAfter+=($NIX_CFLAGS_LINK)

    # Add the flags that should be passed to the linker (and prevent
    # `ld-wrapper' from adding NIX_LDFLAGS again).
    for i in $NIX_LDFLAGS_BEFORE; do
        extraBefore=(${extraBefore[@]} "-Wl,$i")
    done
    for i in $NIX_LDFLAGS; do
        if [ "${i:0:3}" = -L/ ]; then
            extraAfter+=("$i")
        else
            extraAfter+=("-Wl,$i")
        fi
    done
    export NIX_LDFLAGS_SET=1
fi



# As a very special hack, if the arguments are just `-v', then don't
# add anything.  This is to prevent `gcc -v' (which normally prints
# out the version number and returns exit code 0) from printing out
# `No input files specified' and returning exit code 1.
if [ "$*" = -v ] || [ "$*" = -qhelp ] ; then
    extraAfter=()
    extraBefore=()
fi

# Optionally print debug info.
if [ -n "$NIX_DEBUG" ]; then
  echo "original flags to @prog@:" >&2
  for i in "${params[@]}"; do
      echo "  $i" >&2
  done
  echo "extraBefore flags to @prog@:" >&2
  for i in ${extraBefore[@]}; do
      echo "  $i" >&2
  done
  echo "extraAfter flags to @prog@:" >&2
  for i in ${extraAfter[@]}; do
      echo "  $i" >&2
  done
fi

exec prefix/bin/.orig/`basename $0` -F$XLCMP_CFG ${extraBefore[@]} "${params[@]}" "${extraAfter[@]}"
