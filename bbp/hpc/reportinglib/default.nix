{ stdenv, fetchgitExternal, cmake, boost, pkgconfig, mpiRuntime}:

stdenv.mkDerivation rec {
  name = "reportinglib-${version}";
  version = "2.4.2-201611";


  buildInputs = [ stdenv cmake boost pkgconfig  mpiRuntime];


  src = fetchgitExternal {
    url = "ssh://bbpcode.epfl.ch/sim/reportinglib/bbp";
    rev = "98f5b5869ad3a2c741e847a658d2bb75986ed05f";
    sha256 = "1a3p7rl2ic1x3g0xhzxh8psbq6z97qvxs60r3zlsc08y83fink4f";
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


