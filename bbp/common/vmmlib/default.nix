{ stdenv, fetchgitExternal, cmake, doxygen, python, blas  }:

stdenv.mkDerivation rec {
  name = "vmmlib-1.11.0";
  buildInputs = [ stdenv cmake doxygen python blas];

  src = fetchgitExternal {
    url = "https://github.com/Eyescale/vmmlib.git";
    rev= "cfa6243f33f4073011feaa7ac0aab15122369ec6";
    sha256 = "0b5zlzymdwn374jd2gs96jvvhkqf9whf2mpqcislpwi6wrz7rczw";
  };


  enableParallelBuilding = true;
}


