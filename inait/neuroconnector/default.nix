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
  version = "2.2";
  
  buildInputs = [ pkgconfig boost mvdtool pythonPackages.python cmake ];

  src = fetchgitPrivate {
    url = config.inait_git_ssh + "/SIMULATION/neuroconnector.git";
    rev = "1745f99ba7297280ef73379ea094d7b53de4d445";
    sha256 = "1iisbxymjnzsscr595s0hdvx28agj34n58midj673qrjx878w3xr";
  };
  
  propagatedBuildInputs = [ mvdtool pythonPackages.numpy ];
  
   passthru = {
    pythonModule = pythonPackages.python;
  };
 
}


