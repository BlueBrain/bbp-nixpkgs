# All standard nixpkg with patch for BBP usage
{
 std-pkgs
}:


let
    pkgFun = 
    pkgs:
      with pkgs;
      let 
         callPackage = newScope mergePkgs;
         mergePkgs = pkgs // { 
         
		  hdf5-cpp = callPackage ./hdf5 {
			szip = null;
			mpi = null;
			enableCpp = true;
		  };         

        };
        in
        mergePkgs;
in
  (pkgFun std-pkgs)




