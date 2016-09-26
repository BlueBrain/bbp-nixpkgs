{ stdenv
, fetchgitExternal 
, boost 
, pkgconfig 
, cmake 
, openscenegraph
, lunchbox 
, brion 
, bbpsdk
, collage
, equalizer
, osgtransparency
, python
, pythonPackages
, qt
}:

stdenv.mkDerivation rec {
  name = "rtneuron-${version}";
  version = "2.10.0";

  buildInputs = [ stdenv pkgconfig boost cmake openscenegraph 
				  lunchbox brion bbpsdk collage osgtransparency
				  equalizer python pythonPackages.numpy qt ]  ;

  src = fetchgitExternal{
    url = "ssh://bbpcode.epfl.ch/viz/RTNeuron";
    rev = "6b8cbd9f77304219ab5c679028de78bba6754773";
    sha256 = "1wbjj1zlc8r4r8bd1wn4398zch8630a0y61vsp51s361blhnwhg2";
  };

  enableParallelBuilding = true;
  
}



