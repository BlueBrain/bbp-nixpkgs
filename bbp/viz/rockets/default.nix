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
    rev = "2a0ef51535e82c6de774f021dd133e1cbda40e85";
    sha256 = "144jxkicm8q9q91rx8f1hix306ff8afc1yq93hlpv1z47g2z0gxn";
  };

  enableParallelBuilding = true;
}
