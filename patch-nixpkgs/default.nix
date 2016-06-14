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

	  ##  slurm BBP configuration
	  #    Add support for Kerberos plugin and allow it to run
	  #    with system configuration

	 slurm-llnl-minimal = callPackage ./slurm {
		lua = null;
		numactl = null;
		hwloc = null;
	 };

	 slurm-llnl = slurm-llnl-minimal.override {
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
          };
          libnss-native-plugins = callPackage ./nss-plugin {


          };

         environment-modules =  callPackage ./env-modules { 
            tcl = tcl-8_5;
         };
         
         envModuleGen = callPackage ./env-modules/generator.nix;

    };
       
in
  MergePkgs




