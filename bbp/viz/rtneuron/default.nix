{ bbpsdk
, boost
, brion
, cmake
, collage
, config
, cudatoolkit8
, doxygen
, equalizer
, fetchgit
, lunchbox
, openscenegraph
, osgtransparency
, pkgconfig
, pythonPackages
, qt
, virtualgl
, stdenv
}:

let
  pythonEnv-rtneuron = pythonPackages.python.buildEnv.override {
    extraLibs = [ pythonPackages.pyopengl pythonPackages.pyqt5
                  pythonPackages.h5py pythonPackages.decorator
                  pythonPackages.numpy pythonPackages.ipython brion virtualgl ];
  };

in
stdenv.mkDerivation rec {
  name = "rtneuron-${version}";
  version = "latest";

  buildInputs = [ stdenv pkgconfig boost cmake openscenegraph lunchbox brion
                  collage osgtransparency equalizer pythonPackages.sphinx_1_3
                  pythonPackages.lxml qt.qtbase qt.qtsvg doxygen ];

  preConfigure = ''
	export PATH="${pythonEnv-rtneuron}/bin:$PATH"
  '';

  src = fetchgit {
    url = "https://github.com/BlueBrain/RTNeuron.git";
    rev = "92d3770c4ec109b808817178095ad25b547ee935";
    sha256 = "1jx27pf6p6h87c289lgqipas2shcsmv8mjkl9aiqfvcnf7qgni1z";
  };

  cmakeFlags = [ "-DDISABLE_SUBPROJECTS=TRUE" ];

  enableParallelBuilding = true;
}
