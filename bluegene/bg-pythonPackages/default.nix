{ stdenv
,  pkgs
,  python
, mpiRuntime
, bg-hdf5
, bgq-openblas
}:

let 
     bg-pkgs = pkgs // rec { openblas = bgq-openblas; openblasCompat = bgq-openblas; };

    makeCrossSetupHook = { deps ? [], substitutions ? {} }: script:
            pkgs.runCommand "hook" substitutions
              (''
                mkdir -p $out/nix-support
                cp ${script} $out/nix-support/setup-hook
              '' + pkgs.lib.optionalString (deps != []) ''
                echo ${toString deps} > $out/nix-support/propagated-build-inputs
                echo ${toString deps} > $out/nix-support/propagated-native-build-inputs
                '' + pkgs.lib.optionalString (substitutions != {}) ''
                substituteAll ${script} $out/nix-support/setup-hook
              '');

     makeCrossWrapper = makeCrossSetupHook { } ../../std-nixpkgs/pkgs/build-support/setup-hooks/make-wrapper.sh;




     pythonPkgs = (import ./python-packages.nix { 
				stdenv = pkgs.stdenvCross;
				python = python.crossDrv;
                # For BGQ, we need to wrapper script to triggers even in cross compiler environment
                # Override them
				pkgs = bg-pkgs // { makeSetupHook = makeCrossSetupHook; makeWrapper = makeCrossWrapper; };
 				self = pythonPkgs;
   	});

    

     bg-overrides = rec { 
	     bg-numpy = pkgs.callPackage ./numpy {
		    inherit bgq-openblas;
	     };

	     numpy = bg-numpy;


	    bg-mpi4py = pythonPkgs.mpi4py.override {
    		mpi = mpiRuntime.crossDrv;
    		openssh = null;
	    };

    	   
	   bg-cython = pythonPkgs.cython.overrideDerivation (oldAttr: {
    		nativeBuildInputs = [ pkgs.makeWrapper ];
	
       });
 
        bg-h5py = pythonPkgs.h5py.override {
    		mpi = mpiRuntime.crossDrv;
    		mpi4py = bg-mpi4py;
    		mpiSupport = false;
    		numpy = bg-numpy;
    		hdf5 = bg-hdf5.crossDrv;
    		cython = bg-cython;
	    };


    };
    

 
in 
  pythonPkgs // bg-overrides


