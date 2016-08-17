# All standard nixpkg with patch for BBP usage
{
 pkgs,
 config 
}:


let
    MergePkgs = with MergePkgs;  pkgs // bgq-override;
    bgq-override = with bgq-override; with MergePkgs; { 


	makeCrossSetupHook = { deps ? [], substitutions ? {} }: script:
	    runCommand "hook" substitutions
	      (''
	        mkdir -p $out/nix-support
	        cp ${script} $out/nix-support/setup-hook
	      '' + lib.optionalString (deps != []) ''
	        echo ${toString deps} > $out/nix-support/propagated-build-inputs
	        echo ${toString deps} > $out/nix-support/propagated-native-build-inputs
		'' + lib.optionalString (substitutions != {}) ''
	        substituteAll ${script} $out/nix-support/setup-hook
	      '');

	makeCrossWrapper = makeCrossSetupHook { } ../std-nixpkgs/pkgs/build-support/setup-hooks/make-wrapper.sh;


        bg-basicSetup = {
		dontDisableStatic = true;	# Keep all static libraries for BGQ
		dontPatchELF = true;		# page size are different between compute node and frontend.....
	};
    
	# specific stdenv properties for BGQ cross compilation for stripping
	bg-dontFixPath = { 
		dontFixup = true; 
		dontCrossStrip = true; 
		dontStrip = true;		# avoid strip, same reason than before and we want to keep debug infos
	};


	bgdontFixPathStdenv = env: (addAttrsToDerivation bg-dontFixPath env); 

	bgbasicSetupStdenv = env: (addAttrsToDerivation bg-basicSetup env);

	bg-wrapGCCCross =
	    {gcc, libc, binutils, cross, shell ? "", name ? "gcc-cross-wrapper-bgq"}:
	
	    forceNativeDrv (import ./gcc-cross-wrapper {
	      nativeTools = false;
	      nativeLibc = false;
	      noLibc = (libc == null);
	      inherit gcc binutils libc shell name cross stdenv;
	    });	

	
	crossBGQSystem = {
		config = "powerpc64-bgq-linux";
		bigEndian = true;
		arch = "powerpc64";
		float = "hard";
		withTLS = true;
		libc = "glibc";

	        platform = ((import ../std-nixpkgs/pkgs/top-level/platforms.nix).powerpc64_pc)
				// { kernelArch = "powerpc"; kernelMajor = "2.6"; };

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


	stdenv = pkgs.stdenv // rec { isBlueGene = true; };


	bgq-stdenv-origin = (overrideCC stdenv mpi-bgq)
                    //  { isBlueGene = true;
                          glibc = bgq-glibc; };

 
	bgq-stdenv-gcc41 = (addAttrsToDerivation { NIX_ENFORCE_PURITY=""; } 
                            (overrideCC stdenv gcc-bgq)
                         );

        bgq-stdenv-gcc47 =  ( bgdontFixPathStdenv bgq-stdenv-gcc47-nofix );
			     
	bgq-stdenv-gcc47-nofix = bgbasicSetupStdenv (makeStdenvCross  stdenv crossBGQSystem bgbinutils bg-gcc47) ;

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

      ## gcc golang compiler in cross compiling mode for BGQ compute node
      bg-gccgo = bg-wrapGCCCross {
           gcc = forceNativeDrv (gcc47-proto.cc.override {
	      stdenv = stdenv;
              cross = crossBGQSystem;
	      langC= true;
              langCC = true;
	      langGo = true;
              langFortran = false;
              binutilsCross = bgbinutils;
              libcCross = bglibc;
              enableShared = true;
              enablePlugin = false;
          });
          libc = bglibc;
          binutils = bgbinutils;
          cross = crossBGQSystem;
       };



	## special MPICH 3.2 patched by Rob for BGQ
	#
       bg-mpich2 = (callPackage ./mpich2 {
		stdenv = bgq-stdenv-gcc47;
		libc = bglibc;
       });


	## GCC based environment
	bgq-stdenv-gcc = bgq-stdenv-gcc41;

	bgq-stdenv-gcc-static = makeStaticLibraries bgq-stdenv-gcc;

	## XLC based environment
        bgq-stdenv = bgq-stdenv-origin;

	bgq-stdenv-mpixlc = bgq-stdenv-origin;
        bgq-stdenv-mpixlc-static =  makeStaticLibraries bgq-stdenv-mpixlc;
 

	## recursively import all package in cross compile stdenv
	all-pkgs-bgq-gcc47 = 
			(let
 			     base_config = config;
			     base_pkgs = (import ../std-nixpkgs/pkgs/top-level/all-packages.nix) { 
						crossSystem = crossBGQSystem;
						config = base_config // {
							## global override to force the BGQ compute environment
							# as default nix Cross compile environment 
							packageOverrides = pkgs: (
								 (base_config.packageOverrides pkgs) 
								 // 
								 rec { 
									stdenvCross = bgq-stdenv-gcc47-nofix; 
									libcCross = bglibc;
									binutilsCross = bgbinutils;

									gfortran = bg-gcc47;

									perl = pkgs.perl.overrideDerivation (oldAttr:{ outputs = [ "out" ]; });

									pythonCross = bgq-python27-gcc47.crossDrv;
				
									python27 = pythonCross;
									python = pythonCross;

									openssl = bgq-openssl-gcc47;

                                                                       openblas = bgq-openblas;
                                                                       openblasCompat = bgq-openblas;


									numpy = bgq-pythonPackages-gcc47.bg-numpy;

									hdf5 = bgq-hdf5-gcc47;

									bbp-mpi = bg-mpich2;


								 }
							); 
						};
					};
			     patch_pkgs = (import ../patch-nixpkgs { std-pkgs = base_pkgs; } );
			     fortranCompiler = { gfortran = bgq-stdenv-gcc47; };
			in
			     patch_pkgs // fortranCompiler);
	

	 # BGQ derivated packages
   
        bgq-cmake = MergePkgs.stdenv.lib.overrideDerivation MergePkgs.cmake (oldAttrs:  {
               stdenv = stdenv // rec { glibc = bgq-glibc; 
					libc = bgq-glibc; };
	       name = oldAttrs.name + "-bgq";
        });


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


        bgq-zlib-gcc47 = all-pkgs-bgq-gcc47.zlib;

        bgq-python27-gcc47 = callPackage ./python-2.7 {
		stdenv = bgq-stdenv-gcc47-nofix;
		bzip2 = bgq-bzip2-gcc47;
		openssl = bgq-openssl-gcc47;
		zlib = bgq-zlib-gcc47;

		pythonOrigin = python27;
		pythonCrossNative = python27;

	};

        bgq-pythonPackages-gcc47 = (import ./bg-pythonPackages { 
								 mpiRuntime = bg-mpich2;
								 stdenv = bgq-stdenv-gcc47-nofix; 
								 python = bgq-python27-gcc47; 
								 bg-hdf5 = bgq-hdf5-gcc47;
								 pkgs = all-pkgs-bgq-gcc47 // { makeWrapper = makeCrossWrapper; };
				   				}
				   );



	bgq-xz = xz.override {
					stdenv = bgq-stdenv-mpixlc-static;
	};

	bgq-xv-gcc47 = all-pkgs-bgq-gcc47.xz;
	   
	bgq-bzip2 = (bzip2.override { 
					stdenv = bgq-stdenv-gcc-static;
					linkStatic = true;
	});            

	bgq-bzip2-gcc47 = all-pkgs-bgq-gcc47.bzip2; 


	bgq-openssl-gcc47 = openssl.overrideDerivation (oldAttr: {
		stdenv= bgq-stdenv-gcc47-nofix;
		outputs = [ "out" ];
	});



	bgq-libxml2 = ( libxml2.override { 
					stdenv = bgq-stdenv-mpixlc-static;
					zlib = null;
					xz = null;
	});

	bgq-libxml2-gcc47 = all-pkgs-bgq-gcc47.libxml2;
              
  
	bgq-boost = (boost.overrideDerivation (oldAttrs:  {
			patches = [ boost/boost-bgq.patch ];

	})).override { 
					stdenv = bgq-stdenv-gcc;
					enableStatic = true;
					enableShared = true;
					bzip2 = bgq-bzip2;
					disableLibraries= "context";
	};


	bgq-boost-gcc47 = (all-pkgs-bgq-gcc47.boost.overrideDerivation (oldAttrs:  {
                        patches = [ boost/boost-bgq.patch ];
			disableLibraries= "context";
	                dontFixup = false;
        	        dontCrossStrip = false;
	                dontStrip = false; 
        }));


	bgq-clapack = all-pkgs-bgq-gcc47.clapack.override {
		stdenv = bgq-stdenv-gcc47-nofix;
		fetchurl = fetchurl;
		blas = bgq-openblas;
		blasLibName = "openblas";
	};

	bgq-openblas = callPackage ./bg-openblas {
		stdenv = bgq-stdenv-gcc47;
		liblapack = all-pkgs-bgq-gcc47.liblapack;
		config =  crossBGQSystem;
	};
	
	

	bgq-petsc-gcc47 = all-pkgs-bgq-gcc47.petsc.override {
		stdenv = bgq-stdenv-gcc47;
		liblapack = bgq-openblas;
		liblapackLibName = "openblas";
		blas = bgq-openblas;
		blasLibName = "openblas";
		mpiRuntime = bg-mpich2;

	};


	bgq-map = with MergePkgs; {
		cmake = bgq-cmake;
		hdf5 = bgq-hdf5;
		xz = bgq-xz;
		zlib = bgq-zlib;
		bzip2 = bgq-bzip2;
		libxml2 = bgq-libxml2;
		mpiRuntime = mpi-bgq;
		mpich2-gcc47 = bg-mpich2;
		stdenv = bgq-stdenv;
		stdenv-gcc47 = bgq-stdenv-gcc47;
		boost = bgq-boost;
		python = bgq-python27-gcc47;
		pythonPackages = bgq-pythonPackages-gcc47;
		blas = MergePkgs.blis;
	};


	bgq-map-gcc47 = with MergePkgs; {
         	cmake = bgq-cmake;
		hdf5 = bgq-hdf5-gcc47;
	 	xz = bgq-xz-gcc47;
		zlib = bgq-zlib-gcc47;
		bzip2 = bgq-bzip2-gcc47;
		stdenv = bgq-stdenv-gcc47;
		mpiRuntime = bg-mpich2;
		bbp-mpi = bg-mpich2;
		blas = all-pkgs-bgq-gcc47.blis;
		python = bgq-python27-gcc47;
		petsc = bgq-petsc-gcc47;

	};
	
	};

	# enable BGQ on BGQ, hiden anywhere else
	all-pkgs = if (import ./portability.nix).isBlueGene == true then MergePkgs else pkgs;       

in
  all-pkgs // { isBlueGene = (import ./portability.nix).isBlueGene; }




