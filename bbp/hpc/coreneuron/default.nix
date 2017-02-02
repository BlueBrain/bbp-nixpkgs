{ stdenv, fetchgitPrivate, python, perl, cmake, boost, pkgconfig, mpiRuntime, mod2c, neurodamus}:

stdenv.mkDerivation rec {
  name = "coreneuron-${version}";
  version = "0.8.1-201611";

  buildInputs = [ boost mpiRuntime mod2c ];

  nativeBuildInputs= [ python perl pkgconfig cmake ];

  cmakeFlags= ["-DADDITIONAL_MECHPATH=${neurodamus.src}/lib/modlib/" "-DADDITIONAL_MECHS=${neurodamus.src}/lib/modlib/coreneuron_modlist.txt"];

  src = fetchgitPrivate {
    url = "ssh://bbpcode.epfl.ch/sim/coreneuron";
    rev =  "f6b49e957f484b49c08ea4f7e289b2254eff2c32";
    sha256 = "09dpi1iqgz301h59ks6x148iqjky490cijn7kxq585054nz89qwl";
  };

}
