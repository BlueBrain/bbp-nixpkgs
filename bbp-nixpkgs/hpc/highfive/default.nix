{ stdenv, fetchFromGitHub, boost, cmake, zlib, hdf5 }:

stdenv.mkDerivation rec {
  name = "highfive-0.8-DEV";
  buildInputs = [ stdenv boost cmake zlib hdf5];

  src = fetchFromGitHub {
    owner = "BlueBrain";
    repo = "HighFive";
    rev = "ba0f864bbf1d1a7a217359fdc494053a4d8bd94e";
    sha256 = "0hi4l9bmj9kvadvpn2mwlm871jk1ssdskfc48wmd9r3rjx6maczy";
  }; 

  enableParallelBuilding = true;
    
  cmakeFlags = "-DUNIT_TESTS=TRUE";  
    
  doCheck = true;
  
  checkTarget = "test";
  
}


