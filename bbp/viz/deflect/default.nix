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
    rev = "c849a1946fd238a94a9c31adcc2cc467935baf58";
    sha256 = "16bqfpwyin34w79w8mwmc7d5x6q2pl77gxlsmwhm4aysjc90m6jw";
  };
  
  enableParallelBuilding = true;

}



