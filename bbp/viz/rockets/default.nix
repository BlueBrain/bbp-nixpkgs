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
    rev = "7d86fe6c938d0c49a758ff253b69548e52b58598";
    sha256 = "1h0x1qriv23a2jmhkn66vlwvva7ccfls6kz62r5qlw0ig1as59yq";
  };

  enableParallelBuilding = true;
}
