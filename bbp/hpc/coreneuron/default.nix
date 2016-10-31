{ stdenv, fetchgitPrivate, python, perl, cmake, boost, pkgconfig, mpiRuntime, mod2c, neurodamus-coreneuron}:

stdenv.mkDerivation rec {
  name = "coreneuron-${version}";
  version = "0.8.1-201610";

  buildInputs = [ boost mpiRuntime mod2c ];

  nativeBuildInputs= [ python perl pkgconfig cmake ];

  cmakeFlags= ["-DADDITIONAL_MECHPATH=${neurodamus-coreneuron}/lib/modlib/" "-DADDITIONAL_MECHS=${neurodamus-coreneuron}/lib/modlib/coreneuron_modlist.txt"];

  src = fetchgitPrivate {
    url = "ssh://bbpcode.epfl.ch/sim/coreneuron";
    rev =  "b1e5e60ee9954081e15c44da7d2ee28c802d13e1";
    sha256 = "1vdq0b2nn476c9w73l25jbqi7vi24pfgqd2hjx8zg786l9cs3bry";
  };

}
