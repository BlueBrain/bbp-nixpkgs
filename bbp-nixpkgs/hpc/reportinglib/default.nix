{ stdenv, fetchgitExternal, cmake, boost, pkgconfig, mpiRuntime}:

stdenv.mkDerivation rec {
  name = "reportinglib-2.4.1";
  buildInputs = [ stdenv cmake boost pkgconfig  mpiRuntime];


  src = fetchgitExternal {
    url = "ssh://bbpcode.epfl.ch/sim/reportinglib/bbp";
    rev = "6ffbdbfb58b50ee312e85d7d75defffaf33abea8";
    sha256 = "1p45wpnkyg0v8xjj4153n8z01nnll3lcfaji4026pmvhdspfhfix";
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


