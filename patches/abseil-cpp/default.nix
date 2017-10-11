{
  cctz,
  cmake,
  fetchFromGitHub,
  gmock,
  gtest,
  stdenv
}:

stdenv.mkDerivation rec {
  name = "abseil-${version}";
  version = builtins.substring 0 6 src.rev;

  src = fetchFromGitHub {
    owner = "adevress";
    repo = "abseil-cpp";
    rev = "977ccb392aa25f026afeed3e12e43a90768e7392";
    sha256 = "0b5iyjxmc5j9q9dwvxam9d6n509cd39z9fzk82z8kjkp2ay7khg4";
  };

  buildInputs = [
    cctz
    cmake
    gmock
    gtest
    stdenv
  ];
}
