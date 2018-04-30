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

    	bbp-virtualenv = callPackage ./bbp-virtualenv {};
    	bbp-virtualenv-py3 = bbp-virtualenv.override { python = python3; };

        # Boost with Python 3 support
        boost-py3 = (boost.overrideDerivation ( oldAttr: {
            name = oldAttr.name + "-py3";
        })).override {
            python = python3;
        };

        ccWrapperFun = callPackage ../std-nixpkgs/pkgs/build-support/cc-wrapper;

        gtest1_8 = callPackage ./gtest {

        };

        grpc = callPackage ./grpc {
            gtest = gtest1_8;
            c-ares = c-ares1_3;
        };

        cereal = callPackage ./cereal {

        };

        libwebsockets = callPackage ./libwebsockets {

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

        ## opencollada compiled in shared library for blender python modules
        opencollada-shared = opencollada.overrideDerivation ( oldAttr: {
            name = oldAttr.name + "-shared";

            cmakeFlags = [ "-DUSE_STATIC=OFF" "-DUSE_SHARED=ON" ];
        });

        blender = callPackage ./blender {
            pythonPackages = python3Packages;
            stdpkgs = std-pkgs;
        };

        blender-python = blender.override {
            pythonModule = true;
            opencollada = opencollada-shared;
        };

        intel-mpi-bench = callPackage ./intel-mpi-bench {
            mpi = mvapich2;
        };

        osu-mpi-bench = callPackage ./osu-mpi-bench {
            mpi = mvapich2;
        };

        scorec = callPackage ./scorec {
            mpi = mvapich2-rdma;
            parmetis  = parmetis;
        };

        parmetis = callPackage ./parmetis {
            mpi = mvapich2;
        };

        scalapack  = callPackage ./scalapack {
            mpi = mvapich2;
            blas = openblasCompat;
            lapack = openblasCompat;
        };


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

        # # llvm 4 backport
        # llvmPackages_4 = callPackage ./llvm/4 {
        #       newScope = extra: MergePkgs.newScope ({ cmake = cmake; } // extra );
        #       inherit ccWrapperFun;
        #       inherit (stdenvAdapters) overrideCC;
        # };

        likwid = callPackage ./likwid {
        };

        # llvm 3.9 backport
        llvmPackages_3_9 = llvmPackages_39;

        singularity = callPackage ./singularity {
        };

        # ispc compiler for brayns
        ispc = callPackage ./ispc {
            # require clang compiler
            clangStdenv = llvmPackages_3_9.stdenv;
            llvm = llvmPackages_3_9.llvm;
            clangUnwrapped = llvmPackages_3_9.clang-unwrapped;
        };


        ## patch version of HDF5 with
        # cpp bindigns enabled
        hdf5-cpp =  std-pkgs.hdf5.override {
            szip = null;
            mpi = null;
            cpp = true;
        };

        phdf5 = std-pkgs.hdf5.override {
            mpi = openmpi;

        };

        adios = callPackage ./adios {
            hdf5 = hdf5;
            mpi = openmpi;
        };

        uftrace = callPackage ./uftrace {
		pandoc = null;
        };

        blis = callPackage ./blis {
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
        # mvapich2 mpi
        #
        mvapich2-slurm = callPackage ./mvapich2 {
            stdenv = enableDebugInfo stdenv;
            # libibverbs needs a recompilation and a sync
            # on viz cluster lx/viz1 due to InfiniBand OFed ABI maddness
            libibverbs = null;
            librdmacm =  null;
            slurm-llnl = slurm-llnl-full;
            extraConfigureFlags = [ "--with-device=ch3:nemesis"];
        };

        mvapich2-hydra = mvapich2-slurm.override {
            slurm-llnl = null;
        };

        mvapich2 = if ( config ? mpi && config.mpi ? withSlurmPlugin  && config.mpi.withSlurmPlugin ) then mvapich2-slurm else mvapich2-hydra;


        ## MVAPICH 2 support with RDMA / Infiniband
        mvapich2-rdma =  if (builtins.pathExists "/usr/include/infiniband/") then ((mvapich2.overrideDerivation (oldAttr: rec {
            name = "mvapich2-rdma-${oldAttr.version}";
        })).override {
            stdenv = enableDebugInfo stdenv;
            librdmacm = ibverbs-upstream;
            libibverbs = rdmacm-upstream;
	    extraConfigureFlags = [ "--with-device=ch3:mrail" ];

        }) else mvapich2;

	
	udapl = callPackage ./udapl {
		ibverbs = ibverbs-upstream;
		librdmacm = rdmacm-upstream;
	};
 
	# openmpi
	openmpi = callPackage ./openmpi {
		libibverbs = ibverbs-upstream;
	};




	gpi2-rdma = callPackage ./gpi2 {
		libibverbs = ibverbs-upstream;
	};

	gpi2 = callPackage ./gpi2 {
		libibverbs = null;
	};



        libnss-native-plugins = callPackage ./nss-plugin {

        };

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

        trilinos = callPackage ./trilinos {
            mpi = pkgs.openmpi;
            parmetis = parmetis;
            withZoltan = true;
            yaml-cpp = yaml-cpp;
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

        tbb = callPackage ./tbb {

        };


        ## manylinux1 wrapper
        manylinux1 = callPackage ./manylinux1 {

        };


        # itk 4.40
        itk = callPackage ./itk {

        };

        # hadoken C++ toolkit
        hadoken = callPackage ./hadoken {


        };

        cython = pythonPackages.cython;

        ## machine learning tools
        #tensorflow
        caffe2 = callPackage ./caffe2 {
        };

        inherit (MergePkgs.callPackage ./cudnn {
          cudatoolkit7 = cudatoolkit7;
          cudatoolkit8 = cudatoolkit8;
        })
        cudnn_cudatoolkit7
        cudnn6_cudatoolkit8
        cudnn_cudatoolkit8
        ;

        cudnn = cudnn6_cudatoolkit8;

        cctz = callPackage ./cctz {
        };

        abseil-cpp = callPackage ./abseil-cpp {
            cctz = patches-pkgs.cctz;
            gtest = gtest1_8;
            gmock = gtest1_8;
        };

        omega_h = callPackage ./omega_h {
            gmodel = patches-pkgs.gmodel;
            libmeshb = patches-pkgs.libmeshb;
            trilinos = trilinos.override {
                buildSharedLibs = true;
                mpi = mpich2;
                withKokkos = true;
                withTeuchos = true;
                withZoltan = true;
                yaml-cpp = yaml-cpp;
            };
        };

        libmeshb = callPackage ./libmeshb {
        };

        gmodel =  callPackage ./gmodel {
        };

        yaml-cpp = callPackage ./yaml-cpp {
        };
    };

    additionalPythonPackages = MergePkgs.callPackage ./additionalPythonPackages ({
        pkgs = MergePkgs;
        pythonPackages = MergePkgs.pythonPackages;
    });

    additionalPython3Packages = MergePkgs.callPackage ./additionalPythonPackages ({
        pkgs = MergePkgs;
        pythonPackages = MergePkgs.python3Packages;
    });

  patches-pkgs = MergePkgs // {
      pythonPackages = MergePkgs.pythonPackages // (additionalPythonPackages);
      python27Packages = MergePkgs.python27Packages // (additionalPythonPackages);
      python3Packages = MergePkgs.python3Packages // (additionalPython3Packages);
      python36Packages = MergePkgs.python36Packages // (additionalPython3Packages);
  };

in
    patches-pkgs
