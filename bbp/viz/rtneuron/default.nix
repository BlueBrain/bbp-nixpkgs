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
  version = "2.12.0-201702";

  buildInputs = [ stdenv pkgconfig boost cmake openscenegraph 
				  lunchbox brion bbpsdk collage osgtransparency
				  equalizer pythonEnv-rtneuron qt ]  ;

  src = fetchgitExternal{
    url = "ssh://bbpcode.epfl.ch/viz/RTNeuron";
    rev = "78dca3d08052a0e2739a63e2e88721fb43120d02";
    sha256 = "1d44nkrn1y8gyygmvjwp52bx320alrhblh1d1fnv6yx8s0s6dl2l";
  };

  patches = [ ./missing_headers.patch  ./cpp14_revert.patch ];

  enableParallelBuilding = true;

  
}



