{ stdenv
, fetchFromGitHub
, cmake
, mpi
 }:

stdenv.mkDerivation rec {
  name = "hello-world-${version}";
  version = "0.1";
  
  buildInputs = [ stdenv cmake mpi];

  src = fetchFromGitHub {
	owner= "BlueBrain";
	repo = "HelloWorld";
    rev = "b911553e892b57ebc2cef4c75ff5e2fc86b22d80";
    sha256 = "0zaj8yg6xvd38g9jv99isjyq91g0a0cgxnawkj0vcmb1mp87q1ff";
  };
  

  enableParallelBuilding = true;
  
  
}


