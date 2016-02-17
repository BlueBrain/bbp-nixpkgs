{ stdenv, fetchgit, boost, cmake, cmake-external }:

stdenv.mkDerivation rec {
  name = "cyme-0.1";
  buildInputs = [ stdenv boost cmake cmake-external];

  src = fetchgit {
    url = "https://github.com/BlueBrain/cyme.git";
    rev = "f8c3708ae10a85706ac487400da75e8e03c0b5b9";
    sha256 = "1yv8cj782y9nb8r2ks8msdqywvkll88hhf3zzf5q4li459g617zh";
    leaveDotGit = true;
  }; 

  enableParallelBuilding = true;
  
    
  doCheck = true;
  
  checkTarget = "test";
  
}


