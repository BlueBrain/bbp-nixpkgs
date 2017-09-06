{ stdenv, fetchFromGitHub, python, perl, cmake, boost, pkgconfig, mpiRuntime, mod2c, neurodamus}:

stdenv.mkDerivation rec {
  name = "coreneuron-${version}";
  version = "0.9-dev201708";

  src = fetchFromGitHub {
    owner = "BlueBrain";
    repo = "Coreneuron";
    rev =  "ffe7b8d42c1fae5eb20cace244d586a3ad3a1364";
    sha256 = "0db5wl7qm3i54jf3fas1wv31fbdgdkj9hnp8rrszjzr6a18sa8fj";
  };



  buildInputs = [ boost mpiRuntime mod2c ];

  nativeBuildInputs= [ python perl pkgconfig cmake ];

  cmakeFlags= ["-DADDITIONAL_MECHPATH=${neurodamus.src}/lib/modlib/" "-DADDITIONAL_MECHS=${neurodamus.src}/lib/modlib/coreneuron_modlist.txt"];

}
