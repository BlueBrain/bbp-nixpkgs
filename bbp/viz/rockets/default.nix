{ stdenv
, config
, fetchgit
, libwebsockets
, boost
, cmake
}:

stdenv.mkDerivation rec {
  name = "rockets-${version}";
  version = "latest";

  buildInputs = [ stdenv boost cmake libwebsockets ];

  src = fetchgit {
    url  = "https://github.com/BlueBrain/Rockets.git";
    rev = "cc53765c97a7daa7c651024c81de70d3fa8f4252";
    sha256 = "1pn31crcnnl36r5by7vx4crsqhwn93jgm9h98scyp2yh2j2i9jr3";
  };

  enableParallelBuilding = true;
}
