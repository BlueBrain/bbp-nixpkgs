# All standard nixpkg with patch for BBP usage
{
 std-pkgs
}:


let
    MergePkgs = with MergePkgs;  std-pkgs // patches;
    patches = with patches; with MergePkgs; rec {

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

	  libflame = callPackage ./libflame {
		blis = blis;
	 };

	 clapack = callPackage ./clapack {
		blas = openblas;
		
	 };

          ##  slurm BBP configuration
          #    Add support for Kerberos plugin and allow it to run
          #    with system configuration

         slurm-llnl-minimal = callPackage ./slurm {
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
       
        ## 
        # mvapich2 mpi implementation
        #
        mvapich2 = callPackage ./mvapich2 {
            # libibverbs needs a recompilation and a sync
            # on viz cluster lx/viz1 due to InfiniBand OFed ABI maddness 
            libibverbs = null;
            librdmacm =  null;
            slurm-llnl = slurm-llnl-full;
            extraConfigureFlags = [ "--with-device=ch3:nemesis"];
        };
          
          
        libnss-native-plugins = callPackage ./nss-plugin {


        };

	#cmake = std-pkgs.cmake.overrideDerivation ( oldAttr: rec {
	#	majorVersion = "3.6";
	#	minorVersion = "1";
	#	version = "${majorVersion}.${minorVersion}";	        
	#
	#	  src = fetchurl {
	#	    url = "${oldAttr.meta.homepage}files/v${majorVersion}/cmake-${version}.tar.gz";
	#	    sha256 = "04ggm9c0zklxypm6df1v4klrrd85m6vpv13kasj42za283n9ivi8";
	#	  };


	# });

	##
	#
	folly = callPackage ./folly {

	};

    ## PETSc utility toolkit
    #
    petsc = callPackage ./petsc {
	        mpiRuntime = pkgs.openmpi;
			blas = openblas;
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

    };
       
in
  MergePkgs




