{ stdenv, fetchgitExternal, cmake, boost, pkgconfig, mpiRuntime}:

stdenv.mkDerivation rec {
  name = "reportinglib-${version}";
  version = "2.4.2-201611";


  buildInputs = [ stdenv cmake boost pkgconfig  mpiRuntime];


  src = fetchgitExternal {
    url = "ssh://bbpcode.epfl.ch/sim/reportinglib/bbp";
    rev = "a5cd8467b439342252147ff6f35cb1ab726b1006";
    sha256 = "0hwq7l64zlha34gzfm6844qgra7n68ckv1nnfhma9avajhnxa38y";
  };
  
  
  ##
  ## create virtual defines.h, we do not need this
  ## this file generation should be removed, this kind of check should
  ## be done  with configure_file() 
  patchPhase= ''
	sed -i 's@include(CommonCPack)@include(PackageConfig)@g' CMakeLists.txt &&
    touch reportinglib/defines.h
	'';  
  
}


