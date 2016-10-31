{stdenv}:
   
stdenv.mkDerivation {
  name = "libnss-native-wrapper-1.0";
   

  buildCommand = ''
    # copy all libnss-* plugins 
    mkdir -p $out/lib 
    cp -r /lib/*-linux-*/libnss_*.so* $out/lib  2> /dev/null || true
    cp -r /lib64/libnss_*.so* $out/lib 2> /dev/null || true
    
    # remove all already existing standard libc modules
    # to avoid collisions
    export std_glibc_module=( "nisplus" "dns" "compat" "hesiod" "db" "nis" "files")
    
    for i in "''${std_glibc_module[@]}"
    do
        rm -f $out/lib*/libnss_''${i}.so*
    done
    
  '';

  meta = { 
  
        description = "Wrapper to map native libnss plugins";

    };

}
