{ stdenv
, fetchFromGitHub
, pkgconfig
, boost
, cmake
, zlib
, hdf5
, highfive
, pythonPackages
 }:

let
    # create a python environment with numpy for numpy bindings tests
    python_test_env = pythonPackages.python.buildEnv.override {
        extraLibs = [ pythonPackages.numpy ];
    };

in

stdenv.mkDerivation rec {
  name = "mvd-tool-${version}";
  version = "1.3";
  
  buildInputs = [ stdenv pkgconfig boost zlib cmake hdf5 ];
  nativeBuildInputs = [ python_test_env ];

  src = fetchFromGitHub {
    owner = "BlueBrain";
    repo = "MVDTool";
    rev = "f7517b0ef60172f8a904a2cb4af681635658246c";
    sha256 = "050lq9anfbqh36mhp66qsqpril2sn8jdp79xsymlc8dpgi7ii1sa";
  };
  
  cmakeFlags=[ 
			   "-DUNIT_TESTS=ON"
			   "-DMVDTOOL_INSTALL_HIGHFIVE=OFF"
			 ];   

  enableParallelBuilding = true;
  
  doCheck = true;
  
  checkPhase = ''
    ctest -V
  '';

  propagatedBuildInputs = [ highfive ];
  
}


