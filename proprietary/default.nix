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





	};
in

 pkgs // prop_pkgs
