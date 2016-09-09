{ stdenv
, fetchgitPrivate
, boost
, libxml2
, cmake
, mpiRuntime
, pkgconfig
, python
, hdf5
, doxygen 
, cnk-spi ? null
}:

stdenv.mkDerivation rec {
  name = "hpctools-${version}";
  version = "3.3.0";
  buildInputs = [ stdenv pkgconfig boost cmake mpiRuntime libxml2 python hdf5 doxygen cnk-spi ];

  src = fetchgitPrivate {
    url = "ssh://bbpcode.epfl.ch/hpc/HPCTools";
    rev = "bd1ac24b2761e51f22f72359029dbda4b15a1d26";
    sha256 = "1liik1pfab6jyx608zgi1gw8mrkq3l7f7n4521m1im3356xy26hc";    
  };
      
  cmakeFlags= [ "-DLIB_SUFFIX=" ];
  
  enableParallelBuilding = true;  

  crossAttrs = {
	## enforce mpiwrapper in cross compilation mode for bgq 
    cmakeFlags= cmakeFlags ++ [ "-DCMAKE_CXX_COMPILER=mpic++" "-DCMAKE_C_COMPILER=mpicc" ];
	
	preConfigure = ''
		export NIX_CROSS_CFLAGS_COMPILE="$NIX_CROSS_CFLAGS_COMPILE -I${cnk-spi}/include/kernel/cnk"
	'';
  };
}

