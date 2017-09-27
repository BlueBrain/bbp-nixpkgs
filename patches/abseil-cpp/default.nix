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
    rev = "827226585158822f6d20d6899a55ae6f216b80f7";
    sha256 = "0jkn4g5k80nb1mc3fs64jjyyxx9x7l1z82qw6k274qjj15yy0shf";
  };

  buildInputs = [
    cctz
    cmake
    gmock
    gtest
    stdenv
  ];
}
