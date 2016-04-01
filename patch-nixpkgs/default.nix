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

		  slurm-llnl = std-pkgs.stdenv.lib.overrideDerivation std-pkgs.slurm-llnl ( oldAttrs: {
			name = oldAttrs.name + "-bbp";
		
                        configureFlags = oldAttrs.configureFlags + " --sysconfdir=/etc/slurm ";	
	
		 });
		
		  ## 
		  # mvapich2 mpi implementation
		  #
		  mvapich2 = callPackage ./mvapich2 {
			slurm = slurm-llnl;	
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




