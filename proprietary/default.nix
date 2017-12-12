# contains all proprietary software and their associated native mapping
{
  pkgs
,  config
}:


let
    utils = (import ./utils/default.nix) { lib = pkgs.stdenv.lib; };

	prop_pkgs = with pkgs; rec {

        inherit utils;


        cray-mpich = callPackage ./cray-mpich {
			cc = gcc;
    	};


        patchelf_rewire = callPackage ./patchelf_rewire {

        };

        allinea_ddt = callPackage ./allinea/ddt {
            inherit patchelf_rewire;
        };

        ## nvidia
        inherit (callPackages ./cuda { inherit utils; })
        cudatoolkit6
        cudatoolkit65
        cudatoolkit7
        cudatoolkit75
        cudatoolkit8;

         ## nvidia openGL implementation
        # required on viz cluster with nvidia hardware
        # where the native library are not usable ( too old )
        nvidia-x11-34032 = callPackage ./nvidia-driver/legacy340-32-kernel26.nix {
            libsOnly = true;
            kernel = null;
        };

        nvidia-x11-36757 = callPackage ./nvidia-driver/nvidia-viz-default.nix {
            libsOnly = true;
            kernel = null;
        };

        nvidia-x11-38498 = callPackage ./nvidia-driver/nvidia-viz-default.nix {
            libsOnly = true;
            kernel = null;
            driverVersion = "384.98";
        };

        # set it up to default viz cluster version 
        nvidia-drivers = nvidia-x11-38498;
        

        ## intel
        icc-native = callPackage ./icc-native {

        };

        intel-mkl = callPackage ./intel-mkl {
        };

        WrappedICC = if (icc-native != null) then (import ../patches/cc-wrapper  {
            inherit stdenv binutils coreutils ;
            libc = glibc;
            nativeTools = false;
            nativeLibc = false;
            cc = icc-native;
        }) else null;


        stdenvICC = (overrideCC stdenv WrappedICC) // {  isICC = true; };

        stdenvIntelfSupported = if (WrappedICC != null) then stdenvICC else stdenv;

        intelMKLIfSupported = if (WrappedICC != null) then intel-mkl else pkgs.blas;
	};
in

 pkgs // prop_pkgs
