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
   last = {
        version = "0.26-dev201708";
        rev = "d3ba7b165c3fafdf8fd438be9248d80c8fc3ab8b";
        sha256 = "0s1d6nanlyl47jg0dbmhwpwrgrgfmnf46hj5bvdjn6s58dyrhg1y";
    };

    legacy-repair = {
        version = "0.26-legacy";
        rev = "7ccfd867b43746909ac3429cf44e2e4014431bbf";
        sha256 = "1pcrds2sqajm22cvq9fb7vhl857p7w45j0p23q7220qj6am01k4x";
    };

    bbpsdk-info = if (legacyVersion) then legacy-repair else last;

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


  # will be restricted only to legacy version in future 
  patches = (stdenv.lib.optionals) (true) [ ./bbpsdk-highfive-legacy.patch ]; 

  # BBPSDK boost.python bindings take more than 1G mem per core to compile
  # with recent GCC, disable parallel buildings or GCC SIGBUS
  enableParallelBuilding = false;


  propagatedBuildInputs = [ brion lunchbox ];

}

