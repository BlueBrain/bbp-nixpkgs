{ fetchgitExternal
, config
, stdenv
, boost
, cmake
, hdf5-cpp
, pkgconfig
, gsl
, bbpsdk }:

stdenv.mkDerivation rec {
  name = "bluejittersdk-${version}";
  version = "${builtins.substring 0 6 src.rev}";
  buildInputs = [ stdenv boost cmake hdf5-cpp pkgconfig gsl bbpsdk ];

  src = fetchgitExternal {
    url = config.bbp_git_ssh + "/platform/BlueJitterSDK";
    rev = "eb836393e49a2b9cff954e57dd04218535b50e78";
    sha256 = "1lawy45qfmizrm6sxmkx63q7jjimk9if5clpd2vyrl2w7k8hq1hy";
  };

  cmakeFlags = [ "-DCOMMON_PACKAGE_USE_QUIET=FALSE" ];
}
