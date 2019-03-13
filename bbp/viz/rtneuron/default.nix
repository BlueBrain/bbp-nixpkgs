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
    rev = "61c962fe813df07adf5dd7315a14ba7b7eb2e1b0";
    sha256 = "0jp5ipka1r7q2xy7lz8306gj6dvxjv63ig3550gdissf9ppwdxk9";
  };

  cmakeFlags = [ "-DDISABLE_SUBPROJECTS=TRUE" ];

  enableParallelBuilding = true;
}
