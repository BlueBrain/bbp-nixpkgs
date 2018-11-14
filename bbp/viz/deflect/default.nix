{ stdenv
, fetchgit
, cmake
, boost
, freeglut
, libXi
, libXmu
, mesa
, libjpeg_turbo
, qt
}:

stdenv.mkDerivation rec {
  name = "deflect-${version}";
  version = "latest";

  buildInputs = [ stdenv cmake boost freeglut mesa libjpeg_turbo libXi libXmu qt.qtbase ];

  src = fetchgit {
    url = "https://github.com/BlueBrain/Deflect";
    rev = "8225138d485a18c0de54a1eeb02140e4521c81e9";
    sha256 = "08h63k3nnx74pnqkqir9c4lr0wg7fandha3xvrwpc349kwf8f542";
  };
  
  enableParallelBuilding = true;

}



