{ stdenv, fetchgitPrivate, cmake, cmake-external, boost, pkgconfig, mpiRuntime}:

stdenv.mkDerivation rec {
  name = "reportinglib-2.4.1-stable";
  buildInputs = [ stdenv cmake cmake-external boost pkgconfig  mpiRuntime];


  src = fetchgitPrivate {
    url = "ssh://bbpcode.epfl.ch/sim/reportinglib/bbp";
    rev = "6ffbdbfb58b50ee312e85d7d75defffaf33abea8";
    sha256 = "1l15ax6wh1w2g2wrr7d7jaknq2sx02cl3l0dj5cchl66v9dh0sdz";
    deepClone= true;
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


