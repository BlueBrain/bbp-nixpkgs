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


        icc-native = callPackage ./icc-native {

        };

        WrappedICC = if (icc-native != null) then (import ../patches/cc-wrapper  {
            inherit stdenv binutils coreutils ;
            libc = glibc;
            nativeTools = false;
            nativeLibc = false;
            cc = icc-native;
        }) else null;


        stdenvICC = overrideCC stdenv WrappedICC;

        stdenvIntelfSupported = if (WrappedICC != null) then stdenvICC else stdenv;


	};
in

 pkgs // prop_pkgs
