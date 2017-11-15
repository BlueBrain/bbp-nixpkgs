{ stdenv
, config
, fetchgitPrivate
, libwebsockets
, boost
, cmake
}:

stdenv.mkDerivation rec {
  name = "rockets-${version}";
  version = "0.1.0-dev201711";

  buildInputs = [ stdenv boost cmake libwebsockets ];

  src = fetchgitPrivate {
    url = config.bbp_git_ssh + "/viz/Rockets";
    rev = "614d6b3078809dedb77629b061448c9f2c2f49fc";
    sha256 = "0n16aw951ifx3bl08mpq0aldmh4ixyy48xf4al413nsyqzv7ixrf";
  };

  enableParallelBuilding = true;
}
