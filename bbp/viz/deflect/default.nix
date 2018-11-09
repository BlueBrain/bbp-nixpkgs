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
    rev = "b58d1fba17bbdd0474a7827ddcf75a50a0e8fb36";
    sha256 = "0i50dbm9abzfcpyv7y4695jpxfa1bk1rkyqkd98p4c7xxphah8hc";
  };
  
  enableParallelBuilding = true;

}



