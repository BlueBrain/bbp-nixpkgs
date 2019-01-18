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
    rev = "7d7ed754896207025191f951f59d6b04b9f9e61f";
    sha256 = "0fsfqsh51xvird8447w98jsfvd7njl2msqcxbj0865b4v94k9sck";
  };

  enableParallelBuilding = true;
}
