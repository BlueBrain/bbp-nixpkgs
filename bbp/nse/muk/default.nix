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
    sha256 = "1gbxxngyzzx45n8yvf6x6ann8gr0kw8lxkhmr8fd2fmzicbjzrgv";
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
