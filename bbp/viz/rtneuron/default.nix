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
  version = "2.13.0-201707";

  buildInputs = [ stdenv pkgconfig boost cmake openscenegraph
                  lunchbox brion bbpsdk collage osgtransparency
                  equalizer pythonEnv-rtneuron qt.base ];

  src = fetchgitPrivate {
    url = config.bbp_git_ssh + "/viz/RTNeuron";
    rev = "d60e5a30945a7a619ea9db83dad5a6e1119d07fd";
    sha256 = "1y0qd9y86aw82marv7kgjdhr0fs6wvhqcsgw9d3qpfasvhv4qsps";
  };


  enableParallelBuilding = true;
}
