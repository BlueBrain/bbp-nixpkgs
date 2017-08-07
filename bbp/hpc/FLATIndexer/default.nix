{ stdenv,
config,
fetchgitPrivate,
pkgconfig,
boost,
bbpsdk,
brion,
lunchbox,
vmmlib,
servus,
cmake,
mpiRuntime,
zlib,
python,
numpy,
hdf5,
doxygen }:

stdenv.mkDerivation rec {
  name = "flatindexer-${version}";
  version = "1.8.2";
  buildInputs = [ stdenv pkgconfig boost cmake  bbpsdk brion lunchbox vmmlib servus zlib python numpy hdf5 doxygen];

  src = fetchgitPrivate {
    url = config.bbp_git_ssh + "/building/FLATIndex";
    rev = "d240ef9f83ea0d1acf099769e6df8fdbfeaa67b0";
    sha256 = "1whfd96jh5d5cqzwc66yg4i2zc7mdi257k0lppljz0avsp93bgdx";
  };


  cmakeFlags= [ "-DCOMMON_DISABLE_WERROR=TRUE" ];


  enableParallelBuilding = true;
}


