{ stdenv
, config
, fetchgitPrivate
, pkgconfig
, boost
, cmake
, mvdtool
, pythonPackages
 }:

stdenv.mkDerivation rec {
  name = "neuroconnector-${version}";
  version = "2.0";
  
  buildInputs = [ pkgconfig boost mvdtool pythonPackages.python cmake ];

  src = fetchgitPrivate {
    url = config.inait_git_ssh + "/SIMULATION/neuroconnector.git";
    rev = "621478d1155bff48ce7b5e0d302ba7fa97937fe5";
    sha256 = "0ixq64c7z6lwjsg8lx06rsqbswhh578il45sb5lim59nnwyw3ml1";
  };
  
  propagatedBuildInputs = [ mvdtool pythonPackages.numpy ];
  
  passthru = {
	pythonModule = pythonPackages;
  };
}


