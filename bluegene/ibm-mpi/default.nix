{ stdenv
, config
, which 
, cnk-spi
, cc
, libc
, ccName ? "gcc"
, cxxName ? "g++"
, commBGQPrefix ? "/bgsys/drivers/ppcfloor/comm"
, mpiCompilerC ? "mpicc"
, mpiCompilerCxx ? "mpic++"
} :

let 
	release_name = if (config ? ibm_bgq_driver_name) then config.ibm_bgq_driver_name else "xxx";
in
stdenv.mkDerivation rec {
    name = "mpi-bgq-gcc-${version}";
	version = release_name;

	inherit mpiCompilerC mpiCompilerCxx;
    
    preferLocalBuild = true;    
    
    buildInputs = [ cc cnk-spi libc ];
    
    forwardCompiler = cc;

	compiler_dir = "${cc}";

	cc_compiler_path = "${cc}/bin/${ccName}";

	cnk_spi_path = "${cnk-spi}";

	glibc_path = "${libc}";
    
    buildCommand = ''   
 
      ## test if we are on a IBM machine
      if [ ! -d ${commBGQPrefix} ]; then
        echo "Invalid IBM comm prefix ${commBGQPrefix}"
        exit 1
      fi
    
      mkdir -p $out/nix-support
      substituteAll ${./setup-hook.sh} $out/nix-support/setup-hook         

      pushd ${commBGQPrefix}
      
	  mkdir -p $out/{include,lib,bin}

	  cp -r ${commBGQPrefix}/include/* $out/include
	  cp -r ${commBGQPrefix}/lib/lib*gcc* $out/lib
     
      substituteAll ${./mpicc.in} $out/bin/mpicc
    
      export cc_compiler_path="$cxx_compiler_path"
	  substituteAll ${./mpicc.in} $out/bin/mpic++
	  
	  chmod a+x $out/bin/mpicc
	  chmod a+x $out/bin/mpic++    
  
      echo "${cc} ${which}" >> $out/nix-support/propagated-user-env-packages
      echo "${cc} ${which}" >> $out/nix-support/propagated-native-build-inputs
   
	  for i in $out/lib/lib*.so
		do
			ls $i
			patchelf --set-rpath "${cnk-spi}/lib:''${out}/lib:${libc}/lib" $i
	  done


   
      '';


	crossAttrs = {
		    cc_compiler_path = "${cc}/bin/${stdenv.cross.config}-${ccName}";

		    cxx_compiler_path = "${cc}/bin/${stdenv.cross.config}-${cxxName}";
	};
      

}





