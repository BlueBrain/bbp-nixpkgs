{ stdenv
, fetchgitPrivate
, cmake
, blas
, liblapack
, python
, pythonPackages
, libxslt
, swig
, numpy
, cython
, petsc
, mpiRuntime
, gtest }:

let 
	steps-python-env = python.buildEnv.override {
		extraLibs = [ 	pythonPackages.unittest2 pythonPackages.numpy pythonPackages.nose
                		pythonPackages.nose_xunitmp pythonPackages.nose_testconfig
						pythonPackages.pandas 
						libxslt  ];
	};
in
stdenv.mkDerivation rec {
  name = "steps-${version}";
  version = "3.1-2016.07";

  nativeBuildInputs = [ cmake swig ];
  
  buildInputs = [ stdenv blas cython liblapack mpiRuntime petsc steps-python-env gtest ];

  src = fetchgitPrivate {
    url = "ssh://git@github.com/CNS-OIST/HBP_STEPS.git";
    rev = "ea6216c6440c510f2621029fec7a8d64d157aa02";
    sha256 = "1jrnhhyxcdfy2qy1a3x4k5ndyzljqvj436a8hbimcyjcmwjmac7q";
  };
  

  enableParallelBuilding = true;

  patches = [
    ./tests-link-against-dl-library.patch
  ];

  
  cmakeFlags = [ "-DPETSC_EXECUTABLE_RUNS=TRUE" 
		 "-DCMAKE_CXX_COMPILER=mpic++" "-DCMAKE_C_COMPILER=mpicc" ];
 
  preConfigure = ''
		# 42 dude !
		export CC=mpicc
		export CXX=mpicxx
        export CXXFLAGS="-pthread -D__STDC_CONSTANT_MACROS"
  ''; 

  passthru = {
	python-env = steps-python-env;

  };
}


