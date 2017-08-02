{ stdenv, fetchFromGitHub, python, perl, cmake, boost, pkgconfig, mpiRuntime, mod2c, neurodamus}:

stdenv.mkDerivation rec {
  name = "coreneuron-${version}";
  version = "0.9-201707";

  src = fetchFromGitHub {
    owner = "BlueBrain";
    repo = "Coreneuron";
    rev =  "8c69803b1d365f9560cb8d0786f427c3e4847fc4";
    sha256 = "0zsl7g0b9ss1wqrwc42vfjylxb1sba9c5zq16z4y1qg7km1n40za";
  };



  buildInputs = [ boost mpiRuntime mod2c ];

  nativeBuildInputs= [ python perl pkgconfig cmake ];

  cmakeFlags= ["-DADDITIONAL_MECHPATH=${neurodamus.src}/lib/modlib/" "-DADDITIONAL_MECHS=${neurodamus.src}/lib/modlib/coreneuron_modlist.txt"];

}
