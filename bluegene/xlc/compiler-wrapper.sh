#!/bin/bash

if [[ -z $LANG || $LANG = C || $LANG = POSIX ]]; then
  LANG=en_US
fi
export LANG
export NLSPATH=@xlcPrefix@/msg/%L/%N:/opt/ibmcmp/vacpp/bg/12.1/msg/%L/%N
export LD_LIBRARY_PATH=@xlcPrefix@/lib:$LD_LIBRARY_PATH
export OS_RELEASE=`/usr/bin/head -1 /etc/redhat-release | sed -e "s/.*release[ \t]*\([0-9\.]*\).*/\1/g"`
export XLCMP_CFG=@xlcPrefix@/vac/bg/12.1/etc/vac.cfg.rhel${OS_RELEASE}.gcc447


## force in the path the correct libstdc++ 
export NIX_LDFLAGS="-L@prefix_stdcpplib@/lib ${NIX_LDFLAGS}"





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


## Add RPATH management
##for XLC we do not have an linker wrapper

# Add all used dynamic libraries to the rpath.
if [ "$NIX_DONT_SET_RPATH" != 1 ]; then

    libPath=""
    addToLibPath() {
        local path="$1"
        if [ "${path:0:1}" != / ]; then return 0; fi
        case "$path" in
            *..*|*./*|*/.*|*//*)
                local path2
                if path2=$(readlink -f "$path"); then
                    path="$path2"
                fi
                ;;
        esac
        case $libPath in
            *\ $path\ *) return 0 ;;
        esac
        libPath="$libPath $path "

    }

    addToRPath() {
        # If the path is not in the store, don't add it to the rpath.
        # This typically happens for libraries in /tmp that are later
        # copied to $out/lib.  If not, we're screwed.
#        if [ "${NIX_STORE}x" != "x" ]; then
#            if [ "${1:0:${#NIX_STORE}}" != "$NIX_STORE" ]; then return 0; fi
#        fi
        case $rpath in
            *\ $1\ *) return 0 ;;
        esac
        rpath="$rpath $1 "

    }

    libs=""
    addToLibs() {
        libs="$libs $1"
    }

    rpath=""

    # First, find all -L... switches.
    allParams=("${params[@]}" ${extraAfter[@]})
    n=0
    while [ $n -lt ${#allParams[*]} ]; do
        p=${allParams[n]}
        p2=${allParams[$((n+1))]}
        if [ "${p:0:3}" = -L/ ]; then
            addToLibPath ${p:2}
        elif [ "$p" = -L ]; then
            addToLibPath ${p2}
            n=$((n + 1))
        elif [ "$p" = -l ]; then
            addToLibs ${p2}
            n=$((n + 1))
        elif [ "${p:0:2}" = -l ]; then
            addToLibs ${p:2}
        elif [ "$p" = -dynamic-linker ]; then
            # Ignore the dynamic linker argument, or it
            # will get into the next 'elif'. We don't want
            # the dynamic linker path rpath to go always first.
            n=$((n + 1))
        elif [[ "$p" =~ ^[^-].*\.so($|\.) ]]; then
            # This is a direct reference to a shared library, so add
            # its directory to the rpath.
            path="$(dirname "$p")";
            addToRPath "${path}"
        fi
        n=$((n + 1))
    done

    # Second, for each directory in the library search path (-L...),
    # see if it contains a dynamic library used by a -l... flag.  If
    # so, add the directory to the rpath.
    # It's important to add the rpath in the order of -L..., so
    # the link time chosen objects will be those of runtime linking.

    for i in $libPath; do
        for j in $libs; do
            if [ -f "$i/lib$j.so" ]; then
                addToRPath $i
                break
            fi
        done
    done


    # Finally, add `-rpath' switches.
    for i in $rpath; do
        extraAfter=(${extraAfter[@]} -Wl,-rpath,$i)
    done


    ## to avoid static linking of libc
    if [[ "${LINK_LIBC_STATIC}x" == "x" ]]; then
        export extraBefore="${extraBefore[@]}  -Wl,-Bdynamic -lc -ldl "
    fi


    ## post final, add interpreter if needed
    extraAfter=(${extraAfter[@]} -Wl,--dynamic-linker=@default_libc_path@/ld-2.12.2.so)
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
