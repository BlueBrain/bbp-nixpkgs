# All standard nixpkg with patch for BBP usage
{
 std-pkgs
}:


let
    MergePkgs = with MergePkgs;  std-pkgs // patches;
    patches = 
    with patches; with MergePkgs; rec {

        ##utility for debug info
        enableDebugInfo = stdenv: stdenv //
        { mkDerivation = args: stdenv.mkDerivation (args // {
                dontStrip = true;
                dontCrossStrip = true;
                NIX_CFLAGS_COMPILE = toString (args.NIX_CFLAGS_COMPILE or "") + " -ggdb -g ";
                NIX_CROSS_CFLAGS_COMPILE = toString (args.NIX_CROSS_CFLAGS_COMPILE or "") + " -ggdb -g";
            });
        };


        ##open scene graph, for viz software
        openscenegraph = callPackage ./openscenegraph {

        };

        ##httpxx, http protocol parser for C++ 
        httpxx = callPackage ./httpxx {

        };

        gmsh = callPackage ./gmsh {
            fltk = fltk13;
            opencascade = null;
        };

        blender = callPackage ./blender {
			stdpkgs = std-pkgs;
        };
 
        
        intel-mpi-bench = callPackage ./intel-mpi-bench {
            mpi = mvapich2;
        };

		osu-mpi-bench = callPackage ./osu-mpi-bench {
            mpi = mvapich2;
        };


		scorec = callPackage ./scorec {
            mpi = mvapich2-rdma;
        };

        
   		icc-native = callPackage ./icc-native {

		};

		WrappedICC = if (icc-native != null) then (import ./cc-wrapper  {
				inherit stdenv binutils coreutils ;
				libc = glibc;
				nativeTools = false;
				nativeLibc = false;
				cc = icc-native;
		}) else null;

		stdenvICC = overrideCC stdenv WrappedICC;

        ## new virtualGL verison for viz team
        virtualgl = std-pkgs.virtualgl.overrideDerivation ( oldAttr: rec {
                version ="2.5.1-fixaliasing";
                name = "virtualgl-${version}";
                src = fetchFromGitHub {
                    owner = "VirtualGL";
                    repo = "VirtualGL";
                    rev = "5efe949c6f85c6ddf6bc5b786c6ce505bbd1d5d1";
                    sha256 = "0wdpdvk1dw19b78zj7p7sa393j1cvssab10b48qlvjk6f06xn8kb";
                };

            patches = [];
            prePatch = ''
            sed -i s,LD_PRELOAD=lib,LD_PRELOAD=$out/lib/lib, server/vglrun.in
            '';


        });

        # ispc compiler for brayns
        ispc = callPackage ./ispc {
            # require clang compiler
            inherit clangStdenv;
            clangUnwrapped = llvmPackages.clang-unwrapped;
            #require cmake 3.6
            inherit cmake36;
        };

        ## nvidia openGL implementation
        # required on viz cluster with nvidia hardware
        # where the native library are not usable ( too old ) 
        nvidia-x11-34032 = callPackage ./nvidia-driver/legacy340-32-kernel26.nix {
            libsOnly = true;
            kernel = null;
        };



        ## patch version of HDF5 with 
        # cpp bindigns enabled        
        hdf5-cpp = callPackage ./hdf5 {
            szip = null;
            mpi = null;
            enableCpp = true;
        };

        ## enforce thread safety
        hdf5 =  std-pkgs.hdf5.overrideDerivation  ( oldAttrs:{
            configureFlags = oldAttrs.configureFlags + " --enable-threadsafe ";
        });        


        blis = callPackage ./blis {

        };


        clapack = callPackage ./clapack {
            blas = openblas;
        };

        ##  slurm BBP configuration
        #    Add support for Kerberos plugin and allow it to run
        #    with system configuration
        slurm-llnl-minimal = callPackage ./slurm {
            inherit config;
            lua = null;
            numactl = null;
            hwloc = null;
        };

        slurm-llnl-full = slurm-llnl-minimal.override {
            slurmPlugins = [auks slurm-plugins];
            lua = lua5_1;
        };

        ## slurm auks plugin
        #
        auks = callPackage ./auks {
            slurm-llnl= slurm-llnl-minimal; 
            nss-plugins = libnss-native-plugins;
        };

        ## slurm lua plugin
        slurm-plugins = callPackage ./slurm-spank-plugins {
            slurm-llnl= slurm-llnl-minimal;
            lua = lua5_1;
        };



		ibverbs-upstream = callPackage ./ibverbs {

		};

		rdmacm-upstream = callPackage ./rdmacm {
			libibverbs = ibverbs-upstream;
        };


		numactl = std-pkgs.numactl.overrideDerivation (oldAttr: rec {

			postInstall = ''
						## strip libtool bullshit files 
						rm -f $out/lib/*.la
			'';

		});

		## mpich2 implementation
		#
		mpich2 = callPackage ./mpich{

		};

        ## 
        # mvapich2 mpi implementation
        #
        mvapich2 = callPackage ./mvapich2 {
			stdenv = enableDebugInfo stdenv;
            # libibverbs needs a recompilation and a sync
            # on viz cluster lx/viz1 due to InfiniBand OFed ABI maddness 
            libibverbs = null;
            librdmacm =  null;
            slurm-llnl = slurm-llnl-full;
            extraConfigureFlags = [ "--with-device=ch3:nemesis"];
        };

        ## mvapich2 with clang wrapper
        mvapich2-clang = mvapich2.override {
            stdenv = ( overrideCC stdenv clang);
        };



        ## MVAPICH 2 support with RDMA / Infiniband
        mvapich2-rdma =  if (builtins.pathExists "/usr/include/infiniband/") then ((mvapich2.overrideDerivation (oldAttr: rec {
	  
		name = "mvapich2-rdma-${version}";
		version = "2.2b";
 
	   src = fetchurl {
    	 url = "http://mvapich.cse.ohio-state.edu/download/mvapich/mv2/mvapich2-${version}.tar.gz";
	   	 sha256 = "18nn9lcwd6g44rl3y6b5n25d1k4l2ksh1xjzw84r639q2hd6ki45";
	   };

	 })).override {
			stdenv = enableDebugInfo stdenv;
            librdmacm = ibverbs-upstream;
            libibverbs = rdmacm-upstream;
            extraConfigureFlags = [ ];
            
            ## InfiniBand driver ABI / API is not stable nor portable
            ## We need to compile both IB and mvapich2 locally
            ##              
            enforceLocalBuild = true;
        }) else mvapich2;


        libnss-native-plugins = callPackage ./nss-plugin {

        };

        cmake36 = std-pkgs.cmake.overrideDerivation ( oldAttr: rec {
            majorVersion = "3.6";
            minorVersion = "1";
            version = "${majorVersion}.${minorVersion}";            

            src = fetchurl {
                url = "${oldAttr.meta.homepage}files/v${majorVersion}/cmake-${version}.tar.gz";
                sha256 = "04ggm9c0zklxypm6df1v4klrrd85m6vpv13kasj42za283n9ivi8";
            };

            outputs = [ "out" "doc" ];
        });

        ##
        #
        folly = callPackage ./folly {

        };

        ## PETSc utility toolkit
        #
        petsc = callPackage ./petsc {
            mpiRuntime = pkgs.openmpi;
            blas = openblasCompat;
            blasLibName = "openblas";
            liblapack = openblasCompat;
            liblapackLibName = "openblas";
        };

        ## profiling tools        
        papi = callPackage ./papi {

        };        

        hpctoolkit = callPackage ./hpctoolkit {
            papi = papi;
        };

        ## env modules
        environment-modules =  callPackage ./env-modules { 
            tcl = tcl-8_5;
        };

        envModuleGen = callPackage ./env-modules/generator.nix;

        gitreview = callPackage ./gitreview {

        };

    };

    additionalPythonPackages = pythonPackages:  rec {

        ## python packages
        nose_xunitmp = pythonPackages.buildPythonPackage rec {
            name = "nose_xunitmp-${version}";
            version = "0.4";

            src = MergePkgs.fetchurl {
            url = "https://pypi.python.org/packages/86/cc/ab61fd10d25d090e80326e84dcde8d6526c45265b4cee242db3f792da80f/nose_xunitmp-0.4.0.tar.gz";
            md5 = "c2d1854a9843d3171b42b64e66bbe54f";
            };

            buildInputs = with pythonPackages; [ nose ];

        }; 

        nose_testconfig = pythonPackages.buildPythonPackage rec {
            name = "nose_testconfig-${version}";
            version = "0.10";

            src = MergePkgs.fetchurl {
                url = "https://pypi.python.org/packages/a0/1a/9bb934f1274715083cfe8139d7af6fa78ca5437707781a1dcc39a21697b4/nose-testconfig-0.10.tar.gz";
                md5 = "2ff0a26ca9eab962940fa9b1b8e97995";
            };

            buildInputs = with pythonPackages; [ nose ];

        };           

    };
       
in
  MergePkgs // { pythonPackages = MergePkgs.pythonPackages // (additionalPythonPackages (MergePkgs.pythonPackages)); }




