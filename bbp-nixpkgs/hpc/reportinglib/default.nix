{ stdenv, fetchgitExternal, cmake, boost, pkgconfig, mpiRuntime}:

stdenv.mkDerivation rec {
  name = "reportinglib-${version}";
  version = "2.4.2";


  buildInputs = [ stdenv cmake boost pkgconfig  mpiRuntime];


  src = fetchgitExternal {
    url = "ssh://bbpcode.epfl.ch/sim/reportinglib/bbp";
    rev = "051e9f31abd28f67eb1dc26aad4120c2e6834ce2";
    sha256 = "1a1q5bjbfwn5xidl8b6vi03z8lch2c0phydd6cliwyq7w38s7i3c";
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


