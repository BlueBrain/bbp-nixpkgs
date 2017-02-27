{ stdenv
, coreutils
, binutils
, bgq-driver
, nativePrefix ? "/bgsys/drivers/toolchain/${bgq-driver}/gnu-linux"
} :


stdenv.mkDerivation {
    name = "gcc-bgq-4.4.7";
    
    preferLocalBuild = true;  
    
    gcc = "/usr"; 
    
    buildCommand = '' 
        
      wrap() {
        local dst="$1"
        local wrapper="$2"
        export prog="$3"
        substituteAll "$wrapper" "$out/bin/$dst"
        chmod +x "$out/bin/$dst"
      }    
    
      ## test if we are on a IBM machine
      if [ ! -d ${nativePrefix} ]; then
        echo "Invalid BGQ GCC compiler prefix ${nativePrefix}"
        exit 1
      fi
    
      export default_cxx_stdlib_compile="-isystem /usr/include/c++/4.4.7/"  
    
      mkdir -p $out/nix-support
      substituteAll "${./setup-hook.sh}" "$out/nix-support/setup-hook"

      pushd ${nativePrefix}
      
      
      
      cp -r ${nativePrefix}/. $out

      
      popd
      

# create some alias to the cross compiler
# for auto detection


    pushd $out/bin
    for i in *
    do
         ln -s $out/bin/$i $out/bin/$(echo "$i" | sed 's@powerpc64-bgq-linux-@@g')
    done                 
          
    rm -f $out/bin/{cc,cpp,gcc*,c++*,g++*}
    
    # c compiler
    wrap "cc" "${./cc-wrapper.sh}" "$out/bin/powerpc64-bgq-linux-gcc";
    wrap "gcc" "${./cc-wrapper.sh}" "$out/bin/powerpc64-bgq-linux-gcc";      

    # c++ compiler
    wrap "c++" "${./cc-wrapper.sh}" "$out/bin/powerpc64-bgq-linux-g++";
    wrap "g++" "${./cc-wrapper.sh}" "$out/bin/powerpc64-bgq-linux-g++";   
    
      '';

   passthru = {
	cc = "/bgsys/drivers/toolchain/V1R2M3/gnu-linux";
	
   };

}





