{ stdenv, fetchFromGitHub, python, perl, cmake, boost, pkgconfig, mpiRuntime, mod2c, neurodamus}:

stdenv.mkDerivation rec {
  name = "coreneuron-${version}";
  version = "0.8.1-201706";

  src = fetchFromGitHub {
    owner = "BlueBrain";
    repo = "Coreneuron";
    rev =  "e836854bc09c2a257ee6ea340ac195159bf211f3";
    sha256 = "1pygz3fiqj2z5ln8bshdnmivh62i2q60b3k00kq96vx6abv7jjaw";
  };



  buildInputs = [ boost mpiRuntime mod2c ];

  nativeBuildInputs= [ python perl pkgconfig cmake ];

  cmakeFlags= ["-DADDITIONAL_MECHPATH=${neurodamus.src}/lib/modlib/" "-DADDITIONAL_MECHS=${neurodamus.src}/lib/modlib/coreneuron_modlist.txt"];

}
