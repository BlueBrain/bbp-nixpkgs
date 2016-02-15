{ stdenv, fetchgit, boost, cmake, cmake-external }:

stdenv.mkDerivation rec {
  name = "cyme-0.1";
  buildInputs = [ stdenv boost cmake cmake-external];

  src = fetchgit {
    url = "https://github.com/BlueBrain/cyme.git";
    rev = "f8c3708ae10a85706ac487400da75e8e03c0b5b9";
    sha256 = "0qj126psxmm75acy0vf4m8bk2fvcg6pa53fqyq3qjc943kbfhams";
    leaveDotGit = true;
  }; 

  enableParallelBuilding = true;
  
    
  doCheck = true;
  
  checkTarget = "test";
  
}


