{ stdenv, fetchgit, cmake, doxygen }:

stdenv.mkDerivation rec {
  name = "vmmlib-${version}";
  version = "1.13.0-201805";

  buildInputs = [ stdenv cmake doxygen];

  src = fetchgit {
    url = "https://github.com/Eyescale/vmmlib.git";
    rev= "6bfad3cc80b3a83131927d857b4606e92cef36cb";
    sha256 = "0azs47958jycmlx3y2k5hgxffh9dx3wv28lych6yw273w0icizk6";
  };


  enableParallelBuilding = true;
}


