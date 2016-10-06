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
  version = "2.11.0";

  buildInputs = [ stdenv pkgconfig boost cmake openscenegraph 
				  lunchbox brion bbpsdk collage osgtransparency
				  equalizer pythonEnv-rtneuron qt ]  ;

  src = fetchgitExternal{
    url = "ssh://bbpcode.epfl.ch/viz/RTNeuron";
    rev = "561dbfc52c137d06ac75cd270c1bbf96fc1be84a" ;
    sha256 = "09301n85yhw8qggcbzhn84yd23mz4zvj1r0wvs279r862dk3svb0";
  };

  enableParallelBuilding = true;
  
}



