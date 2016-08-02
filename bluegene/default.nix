# All standard nixpkg with patch for BBP usage
{
 pkgs,
 config 
}:


let
    MergePkgs = with MergePkgs;  pkgs // bgq-override;
    bgq-override = with bgq-override; with MergePkgs; { 
    
	# specific stdenv properties for BGQ cross compilation
	bg-dontFixPath = { 
		dontDisableStatic = true;	# Keep all static libraries for BGQ
		dontPatchELF = true;		# page size are different between compute node and frontend.....
		dontFixup = true; 
		dontCrossStrip = true; 
		dontStrip = true;		# avoid strip, same reason than before and we want to keep debug infos
		NIX_DONT_SET_RPATH = "1";	# overloading the RPATH cause crash on BGQ compute node
	};

	bgdontFixPathStdenv = env: (addAttrsToDerivation bg-dontFixPath env); 

	bg-wrapGCCCross =
	    {gcc, libc, binutils, cross, shell ? "", name ? "gcc-cross-wrapper"}:
	
	    forceNativeDrv (import ../std-nixpkgs/pkgs/build-support/gcc-cross-wrapper {
	      nativeTools = false;
	      nativeLibc = false;
	      noLibc = (libc == null);
	      stdenv = bgdontFixPathStdenv stdenv;
	      inherit gcc binutils libc shell name cross;
	    });	

	
	crossBGQSystem = {
		config = "powerpc64-bgq-linux";
		bigEndian = true;
		arch = "powerpc64";
		float = "hard";
		withTLS = true;
		libc = "glibc";

	        platform = ((import ../std-nixpkgs/pkgs/top-level/platforms.nix).powerpc64_pc)
				// { kernelArch = "powerpc"; };

		openssl.system = "linux-ppc64";

           };

	
	BGQLinuxHeaders = forceNativeDrv (import ../std-nixpkgs/pkgs/os-specific/linux/kernel-headers/3.12.nix {
	    inherit stdenv fetchurl perl;
	    cross = crossBGQSystem;
	  });



	xlc = callPackage ./xlc { };


	bgq-glibc = callPackage ./bgq-glibc-native { } ;
  
 
  	gcc-bgq =   (callPackage ./gcc-bgq { }) // { target = crossBGQSystem; } ;
 

	mpi-bgq = callPackage ./mpi-bgq {  
        	cc = xlc;
	 };    


	stdenv = pkgs.stdenv.override {
			extraAttrs = { isBlueGene = true; };
        };


	bgq-stdenv-origin = (overrideCC stdenv mpi-bgq)
                    //  { isBlueGene = true;
                          glibc = bgq-glibc; };

 
	bgq-stdenv-gcc41 = (addAttrsToDerivation { NIX_ENFORCE_PURITY=""; } 
                            (overrideCC stdenv gcc-bgq)
                         );

        bgq-stdenv-gcc47 =  ( bgdontFixPathStdenv 
			     (makeStdenvCross  stdenv crossBGQSystem bgbinutils bg-gcc47)
			    );

	 # BGQ pure environment
	 #
	 bglibc = callPackage ./bglibc {
	    stdenv = stdenv;
	    kernelHeaders = BGQLinuxHeaders;
	    installLocales = false;
	    machHeaders = null;
	    hurdHeaders = null;
	    gccCross = bg-gcc47CrossStage;	
	 };

	bgbinutils = callPackage ./bgbinutils {
		noSysDirs = true;
		cross= crossBGQSystem;
         };

        gcc47-proto = wrapCC (callPackage ./bg-gcc {

	   noSysDirs = true;
	   ppl = null;
	   cloog = null;

	    # bootstrapping a profiled compiler does not work in the sheevaplug:
	    #     # http://gcc.gnu.org/bugzilla/show_bug.cgi?id=43944
            profiledCompiler = false;
            cross = null;
            libcCross = null;
            texinfo = texinfo413;
    
	});


	bg-gcc47CrossStage = bg-wrapGCCCross {
	   gcc = forceNativeDrv (gcc47-proto.cc.override {
	      stdenv = stdenv;
	      cross = crossBGQSystem;
	      crossStageStatic = true;
              langCC = false;
              binutilsCross = bgbinutils;
              libcCross = null;
	      enableShared = false;
	      enablePlugin = false;
          });
          libc = null;
          binutils = bgbinutils;
          cross = crossBGQSystem;
       };


      bg-gcc47 = bg-wrapGCCCross {
           gcc = forceNativeDrv (gcc47-proto.cc.override {
	      stdenv = stdenv;
              cross = crossBGQSystem;
              langCC = true;
	      langFortran = true;
              binutilsCross = bgbinutils;
              libcCross = bglibc;
              enableShared = true;
              enablePlugin = false;
          });
          libc = bglibc;
          binutils = bgbinutils;
          cross = crossBGQSystem;
       };

       bg-mpich2 = (callPackage ./mpich2 {
		stdenv = bgq-stdenv-gcc47;
       }).crossDrv;


	## GCC based environment
	bgq-stdenv-gcc = bgq-stdenv-gcc41;

	bgq-stdenv-gcc-static = makeStaticLibraries bgq-stdenv-gcc;

	## XLC based environment
        bgq-stdenv = bgq-stdenv-origin;

	bgq-stdenv-mpixlc = bgq-stdenv-origin;
        bgq-stdenv-mpixlc-static =  makeStaticLibraries bgq-stdenv-mpixlc;
 

	

	 # BGQ derivated packages
   
        bgq-cmake = MergePkgs.stdenv.lib.overrideDerivation MergePkgs.cmake (oldAttrs:  {
               stdenv = stdenv // rec { glibc = bgq-glibc; 
					libc = bgq-glibc; };
	       name = oldAttrs.name + "-bgq";
        });


	bgq-tbb = tbb.override{
		stdenv = bgq-stdenv-gcc;
	};

        bgq-hdf5 = (hdf5.override {
                stdenv = bgq-stdenv-mpixlc-static;
                enableShared = false;
        	zlib = bgq-zlib;
        });


	bgq-hdf5-gcc47 = (hdf5.overrideDerivation (oldAttrs: {
		dontSetConfigureCross = true;

	})).override {
                stdenv = bgq-stdenv-gcc47;
                enableShared = false;
                zlib = bgq-zlib-gcc47;
        };    
  

        bgq-zlib = ( zlib.override {
                stdenv = bgq-stdenv-mpixlc;
        });


        bgq-zlib-gcc47 = (zlib.override {
                stdenv = bgq-stdenv-gcc47;
        });




        bgq-python27-gcc47 = callPackage ./python-2.7 {
		stdenv = bgq-stdenv-gcc47;
		bzip2 = bgq-bzip2-gcc47;
		openssl = bgq-openssl-gcc47;

		pythonOrigin = python27;
		pythonCrossNative = python27;

	};



	bgq-xz = xz.override {
					stdenv = bgq-stdenv-mpixlc-static;
	};
	   
	bgq-bzip2 = (bzip2.override { 
					stdenv = bgq-stdenv-gcc-static;
					linkStatic = true;
	});            

	bgq-bzip2-gcc47 = bzip2.override { 
					stdenv = bgq-stdenv-gcc47;
	};            


	bgq-openssl-gcc47 = ((openssl.overrideDerivation (oldAttr: {
		outputs = [ "out" ];
	})).override {
					stdenv = bgq-stdenv-gcc47;
	});



	bgq-libxml2 = ( libxml2.override { 
					stdenv = bgq-stdenv-mpixlc-static;
					zlib = null;
					xz = null;
	});
              
  
	bgq-boost = (boost.overrideDerivation (oldAttrs:  {
			patches = [ boost/boost-bgq.patch ];

	})).override { 
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




