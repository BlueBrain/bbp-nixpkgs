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
  version = "3.1-releasepreview";

  nativeBuildInputs = [ cmake swig ];
  
  buildInputs = [ stdenv blas cython liblapack mpiRuntime petsc steps-python-env gtest ];

  src = fetchgitPrivate {
    url = "ssh://git@github.com/CNS-OIST/HBP_STEPS.git";
    rev = "5d8f5f86fb0f27cf5fb2ca4da5f5ff15e53bfa27";
    sha256 = "1gv6drcpwya4qhiryxx7bf2gvm0k9lp57kgg35ihq931fzrk5isj";
  };
  

  enableParallelBuilding = true;

  
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


