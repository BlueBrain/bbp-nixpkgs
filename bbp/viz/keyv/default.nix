{ stdenv, boost, fetchgitExternal, cmake, leveldb, lunchbox }:

stdenv.mkDerivation rec {
  name = "keyv-${version}";
  version = "1.0.0";

  buildInputs = [ stdenv boost cmake lunchbox leveldb ];

  src = fetchgitExternal{
    url = "https://github.com/BlueBrain/Keyv.git";
    rev = "a476524310fd9dd4915e3ce1b1affe2cdba65bc6";
    sha256 = "0ylcm33670721r6hp7bp26d2j1bzya4gafbm6gj1m9jpckvaz39a";
  };
  
  enableParallelBuilding = true;

  propagatedBuildInputs = [ lunchbox leveldb ];
  
}



