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
    rev = "c786dd41977bef10b0cf3e3668812d42e72fa131";
    sha256 = "0m95ibhf6fjqjb9w7ryi8s15qwznd9ppi88fcwp8s35rl5vsz48h";
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


