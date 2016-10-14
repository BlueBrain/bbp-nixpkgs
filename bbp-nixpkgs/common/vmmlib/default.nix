{ stdenv, fetchgitExternal, cmake, doxygen, python, blas  }:

stdenv.mkDerivation rec {
  name = "vmmlib-1.11.0";
  buildInputs = [ stdenv cmake doxygen python blas];

  src = fetchgitExternal {
    url = "https://github.com/Eyescale/vmmlib.git";
    rev= "6554cd14a4b3e241064cd8e52b4410243c8f4a5e";
    sha256 = "10jdgd32wmw4f20qy30bqpxf3n7ad7sfpr1z079n3h3imj49j0y2";
  };


  enableParallelBuilding = true;
}


