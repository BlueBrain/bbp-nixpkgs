{ stdenv
, fetchFromGitHub
, pkgconfig
, boost
, cython
, cmake
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
  version = "1.4";
  
  buildInputs = [ stdenv pkgconfig boost highfive cmake hdf5 ];
  nativeBuildInputs = [ python_test_env cython ];

  src = fetchFromGitHub {
    owner = "BlueBrain";
    repo = "MVDTool";
    rev = "1fe217e84524d891fc6f24fd696af66ba8d08f62";
    sha256 = "0lgwp7xzifb66f99hvklr5ij3lqfhim0c7nnrgrxmpwpgdkrh9r7";
  };
  
  cmakeFlags=[

	       # problem with cython 0.27.3 
               "-DBUILD_PYTHON_BINDINGS=OFF"
			 ];   

  enableParallelBuilding = true;
  
  # TODO: fix issue in MVD2 test
  doCheck = false;
  
  checkPhase = ''
    ctest -V
  '';

  propagatedBuildInputs = [ highfive ];
  
}


