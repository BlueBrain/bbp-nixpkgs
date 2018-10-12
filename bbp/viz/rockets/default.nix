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
    rev = "e8aaf5e3b773399af1427c660e9d586c6248a173";
    sha256 = "1dacpnhvszbzwwjv1zv3yhacldv279s7l4lbffy28rkdhaqq1d9f";
  };

  enableParallelBuilding = true;
}
