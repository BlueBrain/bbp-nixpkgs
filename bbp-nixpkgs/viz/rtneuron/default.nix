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
, virtualgl
}:

let 
  pythonEnv-rtneuron = python.buildEnv.override { 
	extraLibs = [ pythonPackages.h5py 
				  pythonPackages.decorator 
				  pythonPackages.numpy
#				  pythonPackages.pyqt5
#				  pythonPackages.ipython
				  brion bbpsdk virtualgl ];
	
 };
in
stdenv.mkDerivation rec {
  name = "rtneuron-${version}";
  version = "2.10.0";

  buildInputs = [ stdenv pkgconfig boost cmake openscenegraph 
				  lunchbox brion bbpsdk collage osgtransparency
				  equalizer pythonEnv-rtneuron qt ]  ;

  src = fetchgitExternal{
    url = "ssh://bbpcode.epfl.ch/viz/RTNeuron";
    rev = "7784a737cb7a4f91e39e7c9f3dcf70c6666f38b8";
    sha256 = "0yfb2d8k5lzp9kjvgknq9bzfpb0bdaawgxygjin3ddcnplc7l3l6";
  };

  enableParallelBuilding = true;
  
}



