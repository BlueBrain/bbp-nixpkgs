{ stdenv, fetchgitPrivate, python, perl, cmake, boost, pkgconfig, mpiRuntime, mod2c, neurodamus}:

stdenv.mkDerivation rec {
  name = "coreneuron-${version}";
  version = "0.8.1-201703";

  buildInputs = [ boost mpiRuntime mod2c ];

  nativeBuildInputs= [ python perl pkgconfig cmake ];

  cmakeFlags= ["-DADDITIONAL_MECHPATH=${neurodamus.src}/lib/modlib/" "-DADDITIONAL_MECHS=${neurodamus.src}/lib/modlib/coreneuron_modlist.txt"];

  src = fetchgitPrivate {
    url = "ssh://bbpcode.epfl.ch/sim/coreneuron";
    rev =  "11a244dbd0b76c458e0ac95b11b3a7c6ae860f30";
    sha256 = "06zfdmq1zd8l1cy6az3z4kxnvzi7zbf21mb61cjkbji5kmv3z210";
  };

}
