{ stdenv, fetchgitPrivate, python, perl, cmake, boost, pkgconfig, mpiRuntime, mod2c, neurodamus-coreneuron}:

stdenv.mkDerivation rec {
  name = "coreneuron-${version}";
  version = "0.8.1-201609";

  buildInputs = [ boost mpiRuntime mod2c ];

  nativeBuildInputs= [ python perl pkgconfig cmake ];

  cmakeFlags= ["-DADDITIONAL_MECHPATH=${neurodamus-coreneuron}/lib/modlib/" "-DADDITIONAL_MECHS=${neurodamus-coreneuron}/lib/modlib/coreneuron_modlist.txt"];

  src = fetchgitPrivate {
    url = "ssh://bbpcode.epfl.ch/sim/coreneuron";
    rev =  "6614b86b8756a30dc9b6e1ce3b6506556ec5d53c";
    sha256 = "0rynlpypa03a55zw0w7aji95dw6a4c22nwhjwhpxwhp49jm568kk";
  };

}
