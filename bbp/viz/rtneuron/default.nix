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
                  equalizer pythonEnv-rtneuron qt.qtbase qt.qtsvg ];

  src = fetchgitPrivate {
    url = config.bbp_git_ssh + "/viz/RTNeuron";
    rev = "47dce1e11a6534dc2eb4971a589cec459c9cc274";
    sha256 = "0ci7hlxykjy6v0iwkaz39rkif897hhxsfw8w2fprg789cjawjp6j";
  };


  enableParallelBuilding = true;
}
