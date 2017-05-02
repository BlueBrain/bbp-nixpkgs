{ stdenv, fetchgitPrivate, python, perl, cmake, boost, pkgconfig, mpiRuntime, mod2c, neurodamus}:

stdenv.mkDerivation rec {
  name = "coreneuron-${version}";
  version = "0.8.1-201704";

  buildInputs = [ boost mpiRuntime mod2c ];

  nativeBuildInputs= [ python perl pkgconfig cmake ];

  cmakeFlags= ["-DADDITIONAL_MECHPATH=${neurodamus.src}/lib/modlib/" "-DADDITIONAL_MECHS=${neurodamus.src}/lib/modlib/coreneuron_modlist.txt"];

  src = fetchgitPrivate {
    url = "ssh://git@github.com/BlueBrain/CoreNeuron.git";
    rev =  "46ca23d052e87ead4067339c9fbbd01f9c943be7";
    sha256 = "125n4vx31s271kh7xf5iya7cwfjr74wzrph8q6k1afp7rk1aa6b2";
  };

}
