{ stdenv
, fetchgitPrivate
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
, pythonPackages
, qt
, virtualgl
}:

let 

  pythonEnv-rtneuron = pythonPackages.python.buildEnv.override { 
	extraLibs = [ pythonPackages.h5py 
				  pythonPackages.decorator 
				  pythonPackages.numpy
				  pythonPackages.pyqt5
				  pythonPackages.ipython
				  brion bbpsdk virtualgl ];
	
 };
in
stdenv.mkDerivation rec {
  name = "rtneuron-${version}";
  version = "2.12.0-201706";

  buildInputs = [ stdenv pkgconfig boost cmake openscenegraph 
				  lunchbox brion bbpsdk collage osgtransparency
				  equalizer pythonEnv-rtneuron qt.base ]  ;

  src = fetchgitPrivate {
    url = "ssh://bbpcode.epfl.ch/viz/RTNeuron";
    rev = "eb11426548ff3a423c15309c948e76053d8908b4";
    sha256 = "0aa5iqhpihq4xmnj1bc4n9q87v792s29gy1vmd04qna2nz0b07fj";
  };


  enableParallelBuilding = true;

  
}



