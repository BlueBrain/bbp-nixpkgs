# All standard nixpkg with patch for BBP usage
{
 pkgs,
 config 
}:


let
    bgq-driver = if (config ? ibm_bgq_driver_name) then config.ibm_bgq_driver_name else null;

    MergePkgs = with MergePkgs;  pkgs // bgq-override;

    bgq-override = with bgq-override; with MergePkgs; rec { 

        inherit bgq-driver;


        bg-basicSetup = {
            dontDisableStatic = true;       # Keep all static libraries for BGQ
            dontPatchELF = true;            # page size are different between compute node and frontend.....
        };
    
        # specific stdenv properties for BGQ cross compilation for stripping
        bg-dontFixPath = { 
            dontCrossStrip = true; 
            dontStrip = true;               # avoid strip, same reason than before and we want to keep debug infos
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

        cnk-spi = callPackage ./cnk-spi { 

        };

        xlc = callPackage ./xlc {
            ## pass the stdc++.so path to use for the rpath 
            bgqstdcpp = "${bg-gcc47.gcc}/powerpc64-bgq-linux";
         };


        bgq-glibc = callPackage ./bgq-glibc-native {
            inherit bgq-driver;
        };
  
 
        gcc-bgq =   (callPackage ./gcc-bgq { inherit bgq-driver; }) // { target = crossBGQSystem; } ;
 

        #mpi-bgq = callPackage ./mpi-bgq {  
        #    cc = xlc;
        #};   

		ibm-mpi = callPackage ./ibm-mpi {
			stdenv = bgq-stdenv-gcc47;
			cc = bg-gcc47;
			libc = bglibc;
			inherit cnk-spi;
		}; 


        ibm-mpi-xlc = callPackage ./ibm-mpi {
            stdenv = bgq-stdenv-gcc47;
            cc = xlc;
            ccName = "bgxlc_r";
            mpiCompilerCAlias = [ "mpixlc" "mpixlc_r" ];
            mpiCompilerCxxAlias = [ "mpixlcxx_r" "mpixlcxx" "mpixlC" "mpixlC_r" ];
            cxxName = "bgxlc++_r";
            libc = bglibc;
            inherit cnk-spi;
        };


        stdenv = pkgs.stdenv // rec { isBlueGene = true; };


        bgq-stdenv-origin = (overrideCC stdenv ibm-mpi-xlc)
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
        bg-mpich = (callPackage ./mpich2 {
            stdenv = bgq-stdenv-gcc47;
            libc = bglibc;
            cnk-spi = cnk-spi;
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
            base_pkgs = 
            (import ../std-nixpkgs/pkgs/top-level/all-packages.nix) { 
                crossSystem = crossBGQSystem;
                config = base_config // {
                    ## global override to force the BGQ compute environment
                    # as default nix Cross compile environment 
                    packageOverrides = 
                    pkgs: (
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

                        bbp-mpi = ibm-mpi;

                    }); 
                };
            };
            patch_pkgs = (import ../patches { std-pkgs = base_pkgs; } );
            fortranCompiler = { gfortran = bgq-stdenv-gcc47; };
        in
            patch_pkgs // fortranCompiler);


        # BGQ derivated packages
   
        bgq-cmake = MergePkgs.stdenv.lib.overrideDerivation MergePkgs.cmake (oldAttrs:  {
               stdenv = stdenv // rec { glibc = bgq-glibc; 
                                        libc = bgq-glibc; };
               name = oldAttrs.name + "-bgq";
        });


        bgq-hdf5 = (hdf5.overrideDerivation ( oldAttr: {         
            preConfigure = ''
                export RUNPARALLEL="mpiexec"
            '';
            configureFlags = "--disable-parallel ";
        })).override {
                stdenv = bgq-stdenv-mpixlc-static;
                enableShared = false;
                zlib = bgq-zlib;
        };


        bgq-hdf5-gcc47 = (hdf5.overrideDerivation (oldAttrs: {
                dontSetConfigureCross = true;
        })).override {
                stdenv = bgq-stdenv-gcc47;
                enableShared = false;
                zlib = bgq-zlib-gcc47;
        };

        bgq-phdf5-gcc47 = (hdf5.overrideDerivation (oldAttrs: {
                dontSetConfigureCross = true;
                preConfigure = ''
                    export LDFLAGS="-Wl,-Bstatic -lmpich-gcc"
                '';
                configureFlags = "--enable-parallel";
        })).override {
                stdenv = bgq-stdenv-gcc47;
                enableShared = false;
                zlib = bgq-zlib-gcc47;
                mpi = ibm-mpi;
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
            mpiRuntime = bg-mpich;
            stdenv = bgq-stdenv-gcc47-nofix; 
            python = bgq-python27-gcc47; 
            bg-hdf5 = bgq-hdf5-gcc47;
            bgq-openblas = bgq-openblas;
            pkgs = all-pkgs-bgq-gcc47;
        });



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



        bgq-libxml2 = ( libxml2.overrideDerivation ( oldAttrs: {
            configureFlags = [ 
                                "--host=powerpc64-unknown-linux-gnu"
                                "--build=powerpc64-bgq-linux"
                            ] ++ [ oldAttrs.configureFlags ];

        })).override { 
            stdenv = bgq-stdenv-mpixlc-static;
            zlib = null;
            xz = null;
        };

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
            DONT_USE_STATIC_STDCPP = "1";
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

        bgq-openblas-static = bgq-openblas.override {
            sharedLibrary = false;
        };



        bgq-petsc-gcc47 = all-pkgs-bgq-gcc47.petsc.override {
            fetchgit = fetchgit;
            stdenv = enableDebugInfo bgq-stdenv-gcc47;
            liblapack = bgq-openblas;
            liblapackLibName = "openblas";
            blas = bgq-openblas;
            blasLibName = "openblas";
            mpiRuntime = ibm-mpi;

        };


        bgq-petsc-gcc47-nodebug = all-pkgs-bgq-gcc47.petsc.override {
            fetchgit = fetchgit;
            stdenv = enableDebugInfo bgq-stdenv-gcc47;
            liblapack = bgq-openblas;
            liblapackLibName = "openblas";
            blas = bgq-openblas;
            blasLibName = "openblas";
            mpiRuntime = ibm-mpi;
            withDebug = false;
        };

        bgq-scorec-gcc47 = all-pkgs-bgq-gcc47.scorec.override {
            stdenv = enableDebugInfo bgq-stdenv-gcc47;
            mpi = ibm-mpi;
            cmake = bgq-cmake;
            parmetis = bgq-parmetis-gcc47;
            zoltan = bgq-zoltan-gcc47;
        };

        bgq-parmetis-gcc47 = all-pkgs-bgq-gcc47.parmetis.override {
            stdenv = enableDebugInfo bgq-stdenv-gcc47;
            mpi = ibm-mpi;
            cmake = bgq-cmake;
        };

        bgq-zoltan-gcc47 = all-pkgs-bgq-gcc47.trilinos.override {
            stdenv = enableDebugInfo bgq-stdenv-gcc47;
            mpi = ibm-mpi;
            cmake = bgq-cmake;
            parmetis = bgq-parmetis-gcc47;
            boost = bgq-boost-gcc47;
        };


        bgq-map = with MergePkgs; {
            cmake = bgq-cmake;
            hdf5 = bgq-hdf5;
            xz = bgq-xz;
            zlib = bgq-zlib;
            bzip2 = bgq-bzip2;
            libxml2 = bgq-libxml2;
            mpiRuntime = ibm-mpi-xlc;
            mpich2-gcc47 = bg-mpich;
            stdenv = bgq-stdenv;
            stdenv-gcc47 = bgq-stdenv-gcc47;
            boost = bgq-boost;
            blas = bgq-openblas;
        };


        bgq-map-gcc47 = with MergePkgs; {
            cmake = bgq-cmake;
            hdf5 = bgq-hdf5-gcc47;
            xz = bgq-xz-gcc47;
            zlib = bgq-zlib-gcc47;
            bzip2 = bgq-bzip2-gcc47;
            stdenv = bgq-stdenv-gcc47;
            boost = bgq-boost-gcc47;
            mpiRuntime = ibm-mpi;
            bbp-mpi = ibm-mpi;
            blas = bgq-openblas;
            python = bgq-python27-gcc47;
            petsc = bgq-petsc-gcc47;
            cnk-spi = cnk-spi;

        };
        
    };

        # enable BGQ on BGQ, hiden anywhere else
        all-pkgs = if (import ./portability.nix).isBlueGene == true then MergePkgs else pkgs;       

in
  all-pkgs // { isBlueGene = (import ./portability.nix).isBlueGene; }




