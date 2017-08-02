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
  version = "1.2";
  
  buildInputs = [ stdenv pkgconfig boost zlib cmake hdf5 ];
  nativeBuildInputs = [ python_test_env ];

  src = fetchFromGitHub {
    owner = "BlueBrain";
    repo = "MVDTool";
    rev = "bd061ec24b44cd3743879309ba127b27e4804b43";
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


