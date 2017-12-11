{ stdenv
, config
, fetchgitPrivate
, cmake
, boost
, pkgconfig
, mpiRuntime}:

stdenv.mkDerivation rec {
  name = "reportinglib-${version}";
  version = "2.4.2-dev201710";


  buildInputs = [ stdenv cmake boost pkgconfig  mpiRuntime];


  src = fetchgitPrivate {
    url = config.bbp_git_ssh + "/sim/reportinglib/bbp";
    rev = "160d01ae0d17b366368706f1c8d9b5e115754a36";
    sha256 = "08i78alrwk4p462qjrl5vj0xwhja73a24k8ynainvhfnrcam2wcj";
  };



}


