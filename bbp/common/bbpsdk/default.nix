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
        version = "latest";
        rev = "d2874569e95246dc5c9751e401d7bb4d9859e7f7";
        sha256 = "1whxwc2pdg17dqh5vmkypzg1ddlv6y7siq9x57612lsh1hzhq31z";
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

