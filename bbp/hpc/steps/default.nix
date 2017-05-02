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
  version = "3.0-releasepreview";

  nativeBuildInputs = [ cmake swig ];
  
  buildInputs = [ stdenv blas cython liblapack mpiRuntime petsc steps-python-env gtest ];

  src = fetchgitPrivate {
    url = "ssh://git@github.com/CNS-OIST/HBP_STEPS.git";
    rev = "eaf2f5210e47aef0caae0d6038f6358aebff65c7";
    sha256 = "0a431chsqklgkxsgd0glppgdkq41v1912sn7i2qwz9jrw0hbzbzr";
  };
  

  enableParallelBuilding = true;

  CXXFLAGS="-pthread ";
  
  cmakeFlags = [ "-DGTEST_USE_EXTERNAL=TRUE" "-DPETSC_EXECUTABLE_RUNS=TRUE" 
		 "-DCMAKE_CXX_COMPILER=mpic++" "-DCMAKE_C_COMPILER=mpicc" ];
 
  preConfigure = ''
		# 42 dude !
		export CC=mpicc
		export CXX=mpicxx
  ''; 

  passthru = {
	python-env = steps-python-env;

  };
}


