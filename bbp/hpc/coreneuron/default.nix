{ stdenv, fetchgitPrivate, python, perl, cmake, boost, pkgconfig, mpiRuntime, mod2c, neurodamus}:

stdenv.mkDerivation rec {
  name = "coreneuron-${version}";
  version = "0.8.1-201706";

  buildInputs = [ boost mpiRuntime mod2c ];

  nativeBuildInputs= [ python perl pkgconfig cmake ];

  cmakeFlags= ["-DADDITIONAL_MECHPATH=${neurodamus.src}/lib/modlib/" "-DADDITIONAL_MECHS=${neurodamus.src}/lib/modlib/coreneuron_modlist.txt"];

  src = fetchgitPrivate {
    url = "ssh://git@github.com/BlueBrain/CoreNeuron.git";
    rev =  "e836854bc09c2a257ee6ea340ac195159bf211f3";
    sha256 = "0q4sxbkwmf6k50n3gdhw65gs890qj1fqixz6xw2nw1sd60axzns0";
  };

}
