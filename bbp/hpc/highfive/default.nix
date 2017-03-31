{ stdenv, fetchFromGitHub, boost, cmake, zlib, hdf5 }:

stdenv.mkDerivation rec {
  name = "highfive-1.0";
  buildInputs = [ stdenv boost cmake zlib hdf5];

  src = fetchFromGitHub {
    owner = "BlueBrain";
    repo = "HighFive";
    rev = "1f5b18c0d62602492339d6a11fb2e5cddfdb7bb9";
    sha256 = "18493v741qqmj4my0q7ppp2chhgjnczhpajsh4dz30m6h3aqzicf";
  }; 

  enableParallelBuilding = true;
    
  cmakeFlags = "-DUNIT_TESTS=TRUE";  
    
  doCheck = true;
  
  checkTarget = "test";


  propagatedBuildInputs = [ hdf5 ];
  
}


