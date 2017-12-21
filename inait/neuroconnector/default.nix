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
  version = "2.1";
  
  buildInputs = [ pkgconfig boost mvdtool pythonPackages.python cmake ];

  src = fetchgitPrivate {
    url = config.inait_git_ssh + "/SIMULATION/neuroconnector.git";
    rev = "aed430c6a2dbabd3cdb3a60ef42a2ba20bd1fa48";
    sha256 = "0h4an9k1pda92l799nkn9gh58bzy3c2244zd8nkdsx00ws639lky";
  };
  
  propagatedBuildInputs = [ mvdtool pythonPackages.numpy ];
  
   passthru = {
    pythonModule = pythonPackages.python;
  };
 
}


