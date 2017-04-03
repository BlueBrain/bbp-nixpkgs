{ stdenv, fetchFromGitHub, boost, cmake, zlib, hdf5 }:

stdenv.mkDerivation rec {
  name = "highfive-1.2";
  buildInputs = [ stdenv boost cmake zlib hdf5];

  src = fetchFromGitHub {
    owner = "BlueBrain";
    repo = "HighFive";
    rev = "3b60be112359ab08b350abfe5fc7bca262400f45";
    sha256 = "1nhls9a0vcnhaaz8srrrg0aljdz92h8hj2nhcypx742281lnnqga";
  }; 

  enableParallelBuilding = true;
    
  cmakeFlags = "-DUNIT_TESTS=TRUE";  
    
  doCheck = true;
  
  checkTarget = "test";


  propagatedBuildInputs = [ hdf5 ];
  
}


