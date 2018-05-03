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
  version = "2.3";
  
  buildInputs = [ pkgconfig boost mvdtool pythonPackages.python cmake ];

  src = fetchgitPrivate {
    url = config.inait_git_ssh + "/SIMULATION/neuroconnector.git";
    rev = "326e8378f2ae3ea01b2e6b7c5829970812e6524d";
    sha256 = "0iyb9kadh4flz03kps6yiaz0af1jjsxqpc3x53fh8mk1zh82pn69";
  };
  
  propagatedBuildInputs = [ mvdtool pythonPackages.numpy ];
  
   passthru = {
    pythonModule = pythonPackages.python;
  };
 
}


