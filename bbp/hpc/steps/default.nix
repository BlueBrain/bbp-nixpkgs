{
  blas
, cmake
, cython
, fetchgitPrivate
, gtest
, liblapack
, libxslt
, mpiRuntime
, numpy
, petsc
, python
, pythonPackages
, stdenv
, swig
}:

let
	steps-python-env = python.buildEnv.override {
		extraLibs = [
      libxslt
      pythonPackages.pandas
      pythonPackages.nose_xunitmp
      pythonPackages.nose
      pythonPackages.nose_testconfig
      pythonPackages.numpy
      pythonPackages.unittest2
    ];
	};
in
stdenv.mkDerivation rec {
  name = "steps-${version}";
  version = "3.1-2017.07-PR109";

  nativeBuildInputs = [ cmake swig python ];

  buildInputs = [
    blas
    cython
    gtest
    liblapack
    mpiRuntime
    petsc
    stdenv
    python
    steps-python-env
  ];

  src = fetchgitPrivate {
    url = "ssh://git@github.com/CNS-OIST/HBP_STEPS.git";
    rev = "a8a2c446b270bd1616006cf2f02255b67bec2b9d";
    sha256 = "07y4hfy1n2hh1dwz70az3pv2psmsr1a17l56r9b9pfm3s63898y1";
  };

  enableParallelBuilding = true;

  patches = [
    ./tests-link-against-dl-library.patch
  ];

  preConfigure = ''
    # 42 dude !
    export CC=mpicc
    export CXX=mpicxx
    export CXXFLAGS="-pthread -D__STDC_CONSTANT_MACROS"
  '';

  cmakeFlags = [
    "-DCMAKE_CXX_COMPILER=mpic++"
    "-DCMAKE_C_COMPILER=mpicc"
    "-DPETSC_EXECUTABLE_RUNS=TRUE"
  ];

  passthru = {
	  python-env = steps-python-env;
  };
}
