# All standard nixpkg with patch for BBP usage
{
 pkgs,
 config 
}:


let
    MergePkgs = with MergePkgs;  pkgs // bgq-override;
    bgq-override = with bgq-override; with MergePkgs; { 
    

	
	xlc = callPackage ./xlc { };


	bgq-glibc = callPackage ./bgq-glibc-native { } ;
  
 
  	gcc-bgq = callPackage ./gcc-bgq { };
 

	mpi-bgq = callPackage ./mpi-bgq {  
        	cc = xlc;
	 };    


	stdenv = pkgs.stdenv.override {
			extraAttrs = { isBlueGene = true; };
        };


	bgq-stdenv-origin = (overrideCC stdenv mpi-bgq)
                    //  { isBlueGene = true;
                          glibc = bgq-glibc; };

        bgq-stdenv = makeStaticLibraries bgq-stdenv-origin;
  
	bgq-stdenv-gcc = (addAttrsToDerivation { NIX_ENFORCE_PURITY=""; } 
                            (overrideCC stdenv gcc-bgq)
                         );
	 # BGQ pure environment
	 #
	 bglibc = callPackage ./bglibc {
	    kernelHeaders = linuxHeaders;
	    installLocales = config.glibc.locales or false;
	    machHeaders = null;
	    hurdHeaders = null;
	    gccCross = null;		
	 };

	 # BGQ derivated packages
   
        bgq-cmake = MergePkgs.stdenv.lib.overrideDerivation MergePkgs.cmake (oldAttrs:  {
               stdenv = stdenv // rec { glibc = bgq-glibc; 
					libc = bgq-glibc; };
	       name = oldAttrs.name + "-bgq";
        });


	bgq-tbb = tbb.override{
		stdenv = bgq-stdenv-gcc;
	};

        bgq-hdf5 = hdf5.override{
                stdenv = bgq-stdenv;
                enableShared = false;
        	zlib = bgq-zlib;
        };   
  
        bgq-zlib = zlib.override {
                stdenv = bgq-stdenv-origin;
        };


	bgq-xz = xz.override {
					stdenv = bgq-stdenv;
	};
	   
	bgq-bzip2 = bzip2.override { 
					stdenv = bgq-stdenv-gcc;
					linkStatic = true;
	};            


	bgq-libxml2 = libxml2.override { 
					stdenv = bgq-stdenv;
					zlib = null;
					xz = null;
	};
              
  
	bgq-boost = boost.override { 
					stdenv = bgq-stdenv-gcc;
					enableStatic = true;
					enableShared = true;
					bzip2 = bgq-bzip2;
					disableLibraries= "context";
	};



	bgq-map = with MergePkgs; {
		cmake = bgq-cmake;
		hdf5 = bgq-hdf5;
		xz = bgq-xz;
		zlib = bgq-zlib;
		bzip2 = bgq-bzip2;
		libxml2 = bgq-libxml2;
		mpiRuntime = bgq-mpi;
		stdenv = bgq-stdenv;
		boost = bgq-boost;
	};
	
	};

	# enable BGQ on BGQ, hiden anywhere else
	all-pkgs = if (import ./portability.nix).isBlueGene == true then MergePkgs else pkgs;       

in
  all-pkgs // { isBlueGene = (import ./portability.nix).isBlueGene; }




