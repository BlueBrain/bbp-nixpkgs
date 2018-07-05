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
  version = "2.3.2";
  
  buildInputs = [ pkgconfig boost mvdtool pythonPackages.python cmake ];

  src = fetchgitPrivate {
    url = config.inait_git_ssh + "/SIMULATION/neuroconnector.git";
    rev = "59a7a9cd8ae4eecfa59ca59320e40bffe9e8431c";
    sha256 = "1r6qbyfs5va2p2vmhmp22d3byx52wbdia7ndrhlj6mx4klbbslhq";
  };
  
  propagatedBuildInputs = [ mvdtool pythonPackages.numpy ];
  
   passthru = {
    pythonModule = pythonPackages.python;
  };
 
}


