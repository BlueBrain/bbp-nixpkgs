{ stdenv
, coreutils
, binutils
, which 
, cc 
, commBGQPrefix ? "/bgsys/drivers/ppcfloor/comm"
} :


stdenv.mkDerivation {
    name = "mpi-bgq-12.1.0";
    
    preferLocalBuild = true;    
    
    buildInputs = [ cc ];
    
    forwardCompiler = cc;
    
    buildCommand = ''
    
      ## test if we are on a IBM machine
      if [ ! -d ${commBGQPrefix} ]; then
        echo "Invalid IBM comm prefix ${commBGQPrefix}"
        exit 1
      fi
    
      mkdir -p $out/nix-support
      substituteAll ${./setup-hook.sh} $out/nix-support/setup-hook         

      pushd ${commBGQPrefix}
      
      
      cp -r ${commBGQPrefix}/. $out
      
      ## replace compiler path to our nix xlc compiler
      sed -i 's@/opt/ibmcmp/vacpp/bg/12.1/bin@${cc}/bin@g' $out/bin/xl/mpi*    
      
      ## force static linking, we are on BG/Q
      sed -i 's@-I$includedir@ -Wl,-Bstatic -I$includedir@g' $out/bin/xl/mpi*
      
      
      mv $out/bin $out/bin-all
      ln -s $out/bin-all/xl $out/bin
      
      
      echo "${cc} ${which}" >> $out/nix-support/propagated-user-env-packages
      echo "${cc} ${which}" >> $out/nix-support/propagated-native-build-inputs
      
      '';
      

}





