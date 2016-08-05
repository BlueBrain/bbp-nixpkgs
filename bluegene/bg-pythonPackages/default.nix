{ stdenv
,  pkgs
,  python
}:

let 
     bg-pkgs = pkgs // rec { openblas = pkgs.blis; openblasCompat = pkgs.blis; };

     pythonPkgs = (import ../../std-nixpkgs/pkgs/top-level/python-packages.nix { 
				stdenv = pkgs.stdenvCross;
				python = python;
				pkgs = bg-pkgs;
				self = pythonPkgs;
				} 
		  );
     bg-numpy =  pythonPkgs.numpy.overrideDerivation (oldAttr: rec {
		
		 });

in 
  pythonPkgs // { bg-numpy = bg-numpy; }


