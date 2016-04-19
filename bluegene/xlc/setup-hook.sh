
addXLCVars () {
    
    export NIX_ENFORCE_PURITY=0
    
          
    
    if [ -d $1/include ]; then
        export NIX_CFLAGS_COMPILE+=" -I $1/include"
    fi

    if [ -d $1/lib64 -a ! -L $1/lib64 ]; then
        export NIX_LDFLAGS+=" -L$1/lib64"
    fi

    if [ -d $1/lib ]; then
        export NIX_LDFLAGS+=" -L$1/lib"
    fi
    


}

## default CC to use
export CC=bgxlc_r
export CXX=bgxlc++_r

# cmake libc fix
# add bgq libc in the path
export LDFLAGS+=" -L@default_libc_path@ -lc "


envHooks+=(addXLCVars)

