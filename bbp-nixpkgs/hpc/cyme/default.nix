{ stdenv, fetchgit, boost, cmake, cmake-external }:

stdenv.mkDerivation rec {
  name = "cyme-0.1";
  buildInputs = [ stdenv boost cmake cmake-external];

  src = fetchgit {
    url = "https://github.com/BlueBrain/cyme.git";
    rev = "f8c3708ae10a85706ac487400da75e8e03c0b5b9";
    sha256 = "0fbl83zlbnhmkzmn4s12rncj9l17qcwirg0d2xkqw1qgyagg0ibd";
    leaveDotGit = true;
  }; 

  enableParallelBuilding = true;
  
    
  doCheck = true;
  
  checkTarget = "test";
  
}


