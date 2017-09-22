{ stdenv
, config
, fetchgitPrivate
, boost
, libxml2
, cmake
, mpiRuntime
, pkgconfig
, hdf5
, cnk-spi ? null
}:

stdenv.mkDerivation rec {
  name = "hpctools-${version}";
  version = "3.3.0";
  buildInputs = [ stdenv pkgconfig boost cmake mpiRuntime libxml2 hdf5 cnk-spi ];

  src = fetchgitPrivate {
    url = config.bbp_git_ssh + "/hpc/HPCTools";
    rev = "bd1ac24b2761e51f22f72359029dbda4b15a1d26";
    sha256 = "15k2wg8ajcnd3n8ys595ckkdddz5bwz5sqwbk40q1bjw8d3g3p98";
  };

  cmakeFlags= [ "-DLIB_SUFFIX=" "-DCMAKE_BUILD_TYPE=RelWithDebInfo" ];

  enableParallelBuilding = true;

  crossAttrs = {
	## enforce mpiwrapper in cross compilation mode for bgq
    cmakeFlags= cmakeFlags ++ [ "-DCMAKE_CXX_COMPILER=mpic++" "-DCMAKE_C_COMPILER=mpicc" ];

	preConfigure = ''
		export NIX_CROSS_CFLAGS_COMPILE="$NIX_CROSS_CFLAGS_COMPILE -I${cnk-spi}/include/kernel/cnk"
	'';
  };
}

