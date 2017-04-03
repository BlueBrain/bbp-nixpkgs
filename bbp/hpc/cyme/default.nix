{ stdenv, fetchgitExternal, boost, cmake }:

stdenv.mkDerivation rec {
  name = "cyme-${version}";
  version = "1.6.0-201703";
  
  buildInputs = [ stdenv boost cmake ];

  src = fetchgitExternal {
    url = "https://github.com/BlueBrain/cyme.git";
    rev = "eb4734b8a5c183027c4bb9a2cd4947fbc59ec8d5";
    sha256 = "1ddwkxnpg60n164j40bi0lrnal5cljxkcm2spwvrmp2q5apfx583";
  }; 

  enableParallelBuilding = true;
  
    
  doCheck = true;
  
  checkTarget = "test";
  
}


