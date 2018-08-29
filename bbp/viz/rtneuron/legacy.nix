{ bbpsdk
, boost
, brion
, cmake
, collage
, config
, cudatoolkit8
, doxygen
, equalizer
, fetchgitPrivate
, legacyVersion ? false
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
  version = "2.13.0";

  buildInputs = [ stdenv pkgconfig boost cmake openscenegraph lunchbox brion
                  collage osgtransparency equalizer pythonPackages.sphinx_1_3
                  qt.qtbase qt.qtsvg bbpsdk ];

  preConfigure = ''
	export PATH="${pythonEnv-rtneuron}/bin:$PATH"
  '';

  src = fetchgitPrivate {
    url = config.bbp_git_ssh + "/viz/RTNeuron";
    rev = "0916a3ac0ff855ec5820e52514c61ba3955004ca";
    sha256 = "0bdiqkbqpvc1x3hb8lj0zcxyykbdpprrkvyqxc3p99czzx1qk27y";
  };

  cmakeFlags = [ "-DDISABLE_SUBPROJECTS=TRUE" ];

  enableParallelBuilding = true;
}
