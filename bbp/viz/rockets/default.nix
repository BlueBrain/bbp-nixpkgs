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
    rev = "40196fa81058a9b94b27f4d85c284bcf88fae305";
    sha256 = "1yjxs6xz67jc14233bvwx3xgl701zklmzqqqfqypsv2zg01sd5ph";
  };

  enableParallelBuilding = true;
}
