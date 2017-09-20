{
  blas
, cmake
, cython
, fetchFromGitHub
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
, integrationTests? false
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
  ] ++ stdenv.lib.optional integrationTests validation;

  src = fetchgitPrivate {
    url = "ssh://git@github.com/CNS-OIST/HBP_STEPS.git";
    rev = "aeee332f602151cf1777773c3b7c4e9c6bc64910";
    sha256 = "02ccv7jk19fhxsc0g5awir9r3qnqsjbkzkfcl5cf0a7hn6k1yis3";
  };

  validation = if integrationTests
  then fetchFromGitHub {
    owner = "CNS-OIST";
    repo = "STEPS_Validation";
    rev = "b2f28b2773bb8b1da79d0cc7bd81d8d042636034";
    sha256 = "048iblc36nyxhbwcp3l4hpmq92fqajhxxclg7a2a1cwyycpdbz7q";
  }
  else null;

  enableParallelBuilding = true;

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

  doCheck = false;

  checkPhase = ''export LD_LIBRARY_PATH="$PWD/src:$LD_LIBRARY_PATH" ctest -V'';

  doInstallCheck = integrationTests;

  installCheckPhase = if integrationTests
  then ''
    runHook preInstallCheck
    (
      export PYTHONPATH="$out"
      cd ${validation}/validation
      chmod -R u+w .

      ${steps-python-env}/bin/${python.executable} \
        ${validation}/validation/run_validation_tests.py

      ${mpiRuntime}/bin/mpirun -n 4 \
        ${steps-python-env}/bin/${python.executable} \
        ${validation}/validation/run_validation_mpi_tests.py
    )
    runHook postInstallCheck
  ''
  else null;

  passthru = {
	  python-env = steps-python-env;
  };
}
