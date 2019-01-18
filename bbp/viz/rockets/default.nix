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
    rev = "ea375c115b03a236ed0e9526e1b8e85949c9af77";
    sha256 = "0fldv35yjwi92vrhyb2hbyz46vjbslk5z8ck96p98nf0fghvi7ng";
  };

  enableParallelBuilding = true;
}
