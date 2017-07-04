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
    rev = "06b1be979a6e013adfe722e47e6de5af4250fa47";
    sha256 = "1sjg14rl0pl9irz9b095ndx85465858qc7mjmfbvdzi48fly03qb";
  };


  enableParallelBuilding = true;
}
