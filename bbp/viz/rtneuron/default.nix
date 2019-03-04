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
    rev = "8ee0d765b96c0d81f2e5a8b0069d06f52644aa1d";
    sha256 = "137n9p4yn5rpkkjafimyzci0hwqpk3b0lqxfcqb4kw8bvg00qmrv";
  };

  cmakeFlags = [ "-DDISABLE_SUBPROJECTS=TRUE" ];

  enableParallelBuilding = true;
}
