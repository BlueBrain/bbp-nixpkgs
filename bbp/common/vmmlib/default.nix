{ stdenv, fetchgit, cmake, doxygen }:

stdenv.mkDerivation rec {
  name = "vmmlib-${version}";
  version = "latest";

  buildInputs = [ stdenv cmake doxygen];

  src = fetchgit {
    url = "https://github.com/eyescale/vmmlib.git";
    rev= "b75b7b6bbb999c32e985ce8d9230283623541883";
    sha256 = "0bk6j3fblg2glrd8kns4jkycm3wypdzz0vxgqn059sz13bwlyrcw";
  };


  enableParallelBuilding = true;
}
