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
    rev = "8cfead25725f69e39ac642031d92d429d68044ea";
    sha256 = "1q82z658763yqd6lmcnrdndy0k2sck04a8mfqk5mk4h1m4wba17g";
  };

  enableParallelBuilding = true;
}
