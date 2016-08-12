{ stdenv
,  pkgs
,  python
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

     bg-numpy = pkgs.callPackage ./numpy {
	blis = pkgs.blis;
     };

     numpy = bg-numpy;


   
     bg-h5py = pythonPkgs.h5py.override {	
	stdenv = pkgs.stdenvCross;
	numpy = bg-numpy;
     };

    

 
in 
  pythonPkgs // { bg-numpy = bg-numpy; bg-h5py = bg-h5py; }


