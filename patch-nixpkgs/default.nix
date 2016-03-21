# All standard nixpkg with patch for BBP usage
{
 std-pkgs
}:


let
    MergePkgs = with MergePkgs;  std-pkgs // patches;
    patches = with patches; with MergePkgs; { 
        
		  hdf5-cpp = callPackage ./hdf5 {
			szip = null;
			mpi = null;
			enableCpp = true;
		  };         

		  libnss-native-plugins = callPackage ./nss-plugin {

		  };
    };
       
in
  MergePkgs




