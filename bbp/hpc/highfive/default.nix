{ stdenv, fetchFromGitHub, boost, cmake, zlib, hdf5 }:

stdenv.mkDerivation rec {
  name = "highfive-1.0";
  buildInputs = [ stdenv boost cmake zlib hdf5];

  src = fetchFromGitHub {
    owner = "BlueBrain";
    repo = "HighFive";
    rev = "07133a1e336bc7ca5e14a81edacbf69060ad9f81";
    sha256 = "0w7gwcj1wlm4mndjs3yk5s9yqhwvy7b5gpr4ysbss2jim1whggvv";
  }; 

  enableParallelBuilding = true;
    
  cmakeFlags = "-DUNIT_TESTS=TRUE";  
    
  doCheck = true;
  
  checkTarget = "test";


  propagatedBuildInputs = [ hdf5 ];
  
}


