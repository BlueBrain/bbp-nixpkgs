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
		extraLibs = [ pythonPackages.unittest2 pythonPackages.numpy pythonPackages.nose
                pythonPackages.nose_xunitmp pythonPackages.nose_testconfig libxslt  ];
	};
in
stdenv.mkDerivation rec {
  name = "steps-${version}";
  version = "2.2.1";

  nativeBuildInputs = [ cmake swig ];
  
  buildInputs = [ stdenv blas cython liblapack mpiRuntime petsc steps-python-env gtest ];

  src = fetchgitPrivate {
    url = "ssh://git@github.com/BlueBrain/HBP_STEPS.git";
    rev = "85eb9104b985ddee8621f75c87ab5fd0c443b8bf";
    sha256 = "16pszr7wcy1x6fhx9pdkwb2ailclm469vzq43dxd7khvsqydxi74";
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


