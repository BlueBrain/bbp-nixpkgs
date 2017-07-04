{ fetchgitExternal
, config
, stdenv
, boost
, cmake
, bbpsdk
, cairo
, curl
, libxml2
, brion
, pkgconfig}:

stdenv.mkDerivation rec {
  name = "muk-${version}";
  version = "3.9.0";
  buildInputs = [ stdenv bbpsdk brion boost cairo curl libxml2 ];
  nativeBuildInputs = [ pkgconfig cmake ];

  src = fetchgitExternal {
    url = config.bbp_git_ssh + "/sim/MUK";
    rev = "a0079a353f41a76dbd0483f73e60c486d54ea147";
    sha256 = "1fvyy3js6hncgc3h6pnsjx7idj13q1v07lpfy6wrpfcbp3cwn0ff";
  };

  enableParallelBuilding = true;

  doCheck = true;
  # tests don't find the .so, explicitly give the path to the library
  # this was blessed by Adrien Devresse :)
  preCheck = ''
   export LD_LIBRARY_PATH=`readlink -f ./lib`
  '';
  checkTarget = "test";
}
