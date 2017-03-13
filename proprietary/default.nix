# contains all proprietary software and their associated native mapping
{
  pkgs
,  config
}:


let
	prop_pkgs = with pkgs; rec {


        cray-mpich = callPackage ./cray-mpich {
			cc = gcc;
    	};


        patchelf_rewire = callPackage ./patchelf_rewire {

        };  

        allinea_ddt = callPackage ./allinea/ddt {
            inherit patchelf_rewire;
        };


	};
in

 pkgs // prop_pkgs
