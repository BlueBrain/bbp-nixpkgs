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
        sha256 = "1vf6i6pdjqbdww0lq4z6g6vvrs46czf444jv85shyd8achhmg055";
    };

    legacy-repair = {
        version = "0.26-legacy";
        rev = "7ccfd867b43746909ac3429cf44e2e4014431bbf";
        sha256 = "0kxr69fkn9l3zf2xrs20jl15sifmvwaz7qchlgzkjjzx5r122qsm";
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

