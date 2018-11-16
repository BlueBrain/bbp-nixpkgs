{ stdenv
, config
, fetchgitPrivate
, boost
, lunchbox
, brion
, vmmlib
, servus
, mvdtool
, cmake
, pkgconfig
, python
, hdf5
, doxygen
, legacyVersion ? false
 }:


let
   bbpsdk-info  = {
        version = "0.26-dev201708";
        rev = "9ff8bea92a74075399b0824931043c30a78f452f";
        sha256 = "1i6glp79qy9k9cqbqr971dv9kyx7hw1rnzjmx5jwfwd4i3xy5rvm";
    };
in

stdenv.mkDerivation rec {
  name = "bbpsdk-${version}";
  version = bbpsdk-info.version;
  buildInputs = [ stdenv pkgconfig boost brion vmmlib servus mvdtool cmake lunchbox python hdf5 doxygen];

  src = fetchgitPrivate {
    url = config.bbp_git_ssh + "/common/BBPSDK";
    rev = bbpsdk-info.rev;
    sha256 = bbpsdk-info.sha256;
  };

  enableParallelBuilding = false;

  propagatedBuildInputs = [ brion lunchbox ];

}

