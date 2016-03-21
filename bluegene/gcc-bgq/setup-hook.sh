

addCVars () {
    
    export NIX_ENFORCE_PURITY=0
    
    if [ -d $1/include ]; then
        export NIX_CFLAGS_COMPILE+=" -isystem $1/include"
    fi

    if [ -d $1/lib64 -a ! -L $1/lib64 ]; then
        export NIX_LDFLAGS+=" -L$1/lib64"
    fi

    if [ -d $1/lib ]; then
        export NIX_LDFLAGS+=" -L$1/lib"
    fi

    if test -d $1/Library/Frameworks; then
        export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -F$1/Library/Frameworks"
    fi

}

envHooks+=(addCVars)

export CC=gcc
export CXX=g++

