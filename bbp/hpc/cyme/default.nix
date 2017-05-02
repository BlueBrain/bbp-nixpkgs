{ stdenv, fetchgitExternal, boost, cmake }:

stdenv.mkDerivation rec {
  name = "cyme-${version}";
  version = "1.6.0-201704";
  
  buildInputs = [ stdenv boost cmake ];

  src = fetchgitExternal {
    url = "https://github.com/BlueBrain/cyme.git";
    rev = "eb4734b8a5c183027c4bb9a2cd4947fbc59ec8d5";
    sha256 = "10h65w0vxpczqmdgc6bksii3i8r8dms1v8p5lldrpm6ykssnkydr";
  }; 

  enableParallelBuilding = true;
  
    
  doCheck = true;
  
  checkTarget = "test";
  
}


