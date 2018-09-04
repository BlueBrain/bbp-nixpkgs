{ stdenv
, boost
, config
, fetchgit
, cmake
, ceph ? null
, leveldb
, libmemcached
, lunchbox
, pression 
}:

let
	libceph = if ( config.keyv.useCeph or false ) then ceph else null;
in
stdenv.mkDerivation rec {
  name = "keyv-${version}";
  version = "latest";

  buildInputs = [ stdenv boost cmake libceph leveldb libmemcached lunchbox pression ];

  src = fetchgit {
    url = "https://github.com/BlueBrain/Keyv.git";
    rev = "8340fa2be4c1844a49714ec1f3166d6cbfd3692b";
    sha256 = "0an3fz29ka80w26fs38lfnidnr1qs7b8d71q8zxzz1jmgzxg9c5k";
  };
  
  enableParallelBuilding = true;

  propagatedBuildInputs = [ lunchbox leveldb pression ];
  
}
