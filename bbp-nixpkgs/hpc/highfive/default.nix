{ stdenv, fetchFromGitHub, boost, cmake, zlib, hdf5 }:

stdenv.mkDerivation rec {
  name = "highfive-0.8-DEV";
  buildInputs = [ stdenv boost cmake zlib hdf5];

  src = fetchFromGitHub {
    owner = "BlueBrain";
    repo = "HighFive";
    rev = "25627b085c1ecc5ef84b01260108f9a044e8074e";
    sha256 = "1var09mar1da30d1avxi8qc9ny3wya87npz5m2gvq10sx1j1lnnz";
  }; 

  enableParallelBuilding = true;
    
  cmakeFlags = "-DUNIT_TESTS=TRUE";  
    
  doCheck = true;
  
  checkTarget = "test";


  propagatedBuildInputs = [ hdf5 ];
  
}


