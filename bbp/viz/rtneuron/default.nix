{ stdenv
, config
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
	extraLibs = [ pythonPackages.pyopengl
                  pythonPackages.pyqt5
                  pythonPackages.h5py
                  pythonPackages.decorator
                  pythonPackages.numpy
                  pythonPackages.ipython
                  brion bbpsdk virtualgl ];

 };
in
stdenv.mkDerivation rec {
  name = "rtneuron-${version}";
  version = "2.13.0-dev201708";

  buildInputs = [ stdenv pkgconfig boost cmake openscenegraph
                  lunchbox brion bbpsdk collage osgtransparency
                  equalizer pythonEnv-rtneuron qt.base ];

  src = fetchgitPrivate {
    url = config.bbp_git_ssh + "/viz/RTNeuron";
    rev = "36885db50256158028195ed6d22dcf6f3f59cb9a";
    sha256 = "1hxkpjvnkh8kfif0gdxbz52y8sjlffz3p51lvjj0ags2jygqi3wx";
  };


  enableParallelBuilding = true;
}
