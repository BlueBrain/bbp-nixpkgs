{ stdenv, fetchgit, cmake, doxygen }:

stdenv.mkDerivation rec {
  name = "vmmlib-${version}";
  version = "latest";

  buildInputs = [ stdenv cmake doxygen];

  src = fetchgit {
    url = "https://github.com/eyescale/vmmlib.git";
    rev= "6fd928f676417eb379155e213e9a8052d87cf39f";
    sha256 = "1scvcxb3dyxws78ldfb8x00wjbsn0q9qdspqdng7hnlggsjcy6c3";
  };


  enableParallelBuilding = true;
}
