{ stdenv
,  pkgs
,  python
, mpiRuntime
, bg-hdf5
}:

let 
     bg-pkgs = pkgs // rec { openblas = pkgs.blis; openblasCompat = pkgs.blis; };

     pythonPkgs = (import ../../std-nixpkgs/pkgs/top-level/python-packages.nix { 
				stdenv = pkgs.stdenvCross;
				python = python.crossDrv;
				pkgs = bg-pkgs;
				self = pythonPkgs;
				} 
		  );

     bg-overrides = rec { 
	     bg-numpy = pkgs.callPackage ./numpy {
		blis = pkgs.blis;
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


