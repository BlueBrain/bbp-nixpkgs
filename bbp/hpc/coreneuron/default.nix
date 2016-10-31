{ stdenv, fetchgitPrivate, python, perl, cmake, boost, pkgconfig, mpiRuntime, mod2c, neurodamus-coreneuron}:

stdenv.mkDerivation rec {
  name = "coreneuron-${version}";
  version = "0.8.1-201610";

  buildInputs = [ boost mpiRuntime mod2c ];

  nativeBuildInputs= [ python perl pkgconfig cmake ];

  cmakeFlags= ["-DADDITIONAL_MECHPATH=${neurodamus-coreneuron}/lib/modlib/" "-DADDITIONAL_MECHS=${neurodamus-coreneuron}/lib/modlib/coreneuron_modlist.txt"];

  src = fetchgitPrivate {
    url = "ssh://bbpcode.epfl.ch/sim/coreneuron";
    rev =  "f86ea002df6d65deeffce22823acde0867e487a1";
    sha256 = "0fr7jykssb6da4jvf7h0bfbc9zxy74swqn8sf86gkpji54wxi32m";
  };

}
