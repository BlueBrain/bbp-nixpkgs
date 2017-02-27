{ stdenv
, config
, which 
, cnk-spi
, cc
, libc
, ccName ? "gcc"
, cxxName ? "g++"
, fortranName ? "f2003"
, commBGQPrefix ? "/bgsys/drivers/ppcfloor/comm"
, mpiCompilerC ? "mpicc"
, mpiCompilerCxx ? "mpic++"
, mpiCompilerFortran ? "mpif2003"
, mpiCompilerCAlias ? [ ]
, mpiCompilerCxxAlias ? [ "mpicxx" ]
, mpiCompilerFortranAlias ? [ "mpif90" "mpif77" ]
} :

let 
	release_name = if (config ? ibm_bgq_driver_name) then config.ibm_bgq_driver_name else "xxx";

    isXLCCompiler = if (cc ? isXLC) then cc.isXLC else false;
in
stdenv.mkDerivation rec {
    name = "mpi-bgq-${ccName}-${version}";
	version = release_name;

	inherit mpiCompilerC mpiCompilerCxx;
    
    preferLocalBuild = true;    
    
    buildInputs = [ cc cnk-spi libc ];
    
    forwardCompiler = cc;

	compiler_dir = "${cc}";

	cc_compiler_path = "${cc}/bin/${ccName}";

    cxx_compiler_path = "${cc}/bin/${cxxName}";

	fc_compiler_path = "${cc}/bin/${fortranName}";

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
     
      substituteAll ${./mpicc.in} $out/bin/${mpiCompilerC}
    
      export cc_compiler_path="$cxx_compiler_path"
	  substituteAll ${./mpicc.in} $out/bin/${mpiCompilerCxx}


      substituteAll ${./mpifortran.in} $out/bin/${mpiCompilerFortran}
	  
	  chmod a+x $out/bin/${mpiCompilerC}
	  chmod a+x $out/bin/${mpiCompilerCxx}
	  chmod a+x $out/bin/${mpiCompilerFortran}

      ## create all aliases
      ${ stdenv.lib.concatStrings (map ( x: ''
                ln -s $out/bin/${mpiCompilerC} $out/bin/${x}
             '' ) mpiCompilerCAlias)
      }

      ${ stdenv.lib.concatStrings (map ( x: ''
                ln -s $out/bin/${mpiCompilerCxx} $out/bin/${x}
             '' ) mpiCompilerCxxAlias)
      }
 
  
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





