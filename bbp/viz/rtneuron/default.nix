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

  version2-info = {
    version = "2.13.0";
    url = config.bbp_git_ssh + "/viz/RTNeuron";
    rev = "0916a3ac0ff855ec5820e52514c61ba3955004ca";
    sha256 = "0bdiqkbqpvc1x3hb8lj0zcxyykbdpprrkvyqxc3p99czzx1qk27y";
    buildInputs = [ bbpsdk ];
    fetchFunction = fetchgitPrivate;
  };

  version3-info = {
    version = "3.0.0";
    url = "https://github.com/BlueBrain/RTNeuron.git";
    rev = "a08934911a4af4ae3e2ee7d92e52cb7bd9aab3ce";
    sha256 = "015y4a838wzw4bxk2qchl4li2vxj6xjmj3da1r6cjqay4vzxp4sm";
    buildInputs = [];
    fetchFunction = fetchgit;
  };

  version-info = if (legacyVersion) then version2-info else version3-info;

  pythonEnv-rtneuron = pythonPackages.python.buildEnv.override {
    extraLibs = [ pythonPackages.pyopengl pythonPackages.pyqt5
                  pythonPackages.h5py pythonPackages.decorator
                  pythonPackages.numpy pythonPackages.ipython brion virtualgl ];
  };

in
stdenv.mkDerivation rec {
  name = "rtneuron-${version}";
  version = version-info.version;

  buildInputs = [ stdenv pkgconfig boost cmake openscenegraph lunchbox brion
                  collage osgtransparency equalizer pythonPackages.sphinx_1_3
                  pythonPackages.lxml qt.qtbase qt.qtsvg ] ++
                version-info.buildInputs;

  preConfigure = ''
	export PATH="${pythonEnv-rtneuron}/bin:$PATH"
  '';

  src = version-info.fetchFunction {
    url = version-info.url;
    rev = version-info.rev;
    sha256 = version-info.sha256;
  };

  cmakeFlags = [ "-DDISABLE_SUBPROJECTS=TRUE" ];

  enableParallelBuilding = true;
}
