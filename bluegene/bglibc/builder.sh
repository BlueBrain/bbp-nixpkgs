# Glibc cannot have itself in its RPATH.
export NIX_NO_SELF_RPATH=1

source $stdenv/setup

postConfigure() {
    # Hack: get rid of the `-static' flag set by the bootstrap stdenv.
    # This has to be done *after* `configure' because it builds some
    # test binaries.
    export NIX_CFLAGS_LINK=
    export NIX_LDFLAGS_BEFORE=

    export NIX_DONT_SET_RPATH=1
    unset CFLAGS
    export NIX_ENFORCE_PURITY=0
}


postInstall() {
    if test -n "$installLocales"; then
        make -j${NIX_BUILD_CORES:-1} -l${NIX_BUILD_CORES:-1} localedata/install-locales
    fi
    
    test -f $out/etc/ld.so.cache && rm $out/etc/ld.so.cache

    ## include the linux kernel headers
    if test -n "$kernelHeaders"; then
      
	# Include the Linux kernel headers in Glibc, except the `scsi'
        # subdirectory, which Glibc provides itself.
        (cd $out/include && \
         ln -sv $(ls -d $kernelHeaders/include/* | grep -v 'scsi$') .)
    fi
	
    # Fix for NIXOS-54 (ldd not working on x86_64).  Make a symlink
    # "lib64" to "lib".
    if test -n "$is64bit"; then
        ln -s lib $out/lib64
    fi

    # This file, that should not remain in the glibc derivation,
    # may have not been created during the preInstall
    rm -f $out/lib/libgcc_s.so.1

    ## fix some prefix issues associated to IBM patch
    ## and prefix
    if [ -d "$out/$out" ]; then
	echo "postInstall fix BlueGene/Q libc links...."
        mkdir -p $out/{share,libexec,lib}
	mkdir -p $out/lib/gconv

	# copy static libs
     	cp $out/$out/lib/*.a $out/lib/
        cp $out/$out/lib/*.o $out/lib/


        cp $out/$out/lib/libc.so $out/lib/libc.so
        # create relevant symlink
	pushd $out/lib
                for i in lib*.so.*
                do
		  ln -s ${i} ${i%.*} || true
                done
        popd

        # copy gconv
        cp -r $out/$out/lib/gconv/* $out/lib/gconv/

        # copy locales
  	cp -r $out/$out/share/* $out/share/

        # copy libexec 
        cp $out/$out/libexec/* $out/libexec/ 
    fi

    ## HACK
    ## the linker 2.21 for compute node after the patch has a corruption problem
    ## easy/dirty hot fix : replace it by the native glibc 2.12.2 one
    echo "Take linker from ${bglinkerfix} "
    cp ${bglinkerfix} $out/lib/ld-2.17.so

}

genericBuild
