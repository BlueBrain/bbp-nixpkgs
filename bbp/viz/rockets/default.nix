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
    rev = "25c65c3ee5d7fc377952910282ce19d37e33172e";
    sha256 = "0bw18lx0dbiygcg85gy43pyli42g7kg4v52hwbnnhcvpylciai8q";
  };

  enableParallelBuilding = true;
}
