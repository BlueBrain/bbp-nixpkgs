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
    rev = "aeee332f602151cf1777773c3b7c4e9c6bc64910";
    sha256 = "126ljq75bmf9ia4y24ym2z9zj1y86ywsnsr5bmx859dfddkdar6q";
  };

  enableParallelBuilding = true;

  preConfigure = ''
    # 42 dude !
    export CC=mpicc
    export CXX=mpic++
    export CXXFLAGS="-pthread -D__STDC_CONSTANT_MACROS"

  '' + (stdenv.lib.optionalString) (stdenv ? isBlueGene) ''
    echo "enable BGQ specific tuning "
  '';

  cmakeFlags = [
    "-DCMAKE_CXX_COMPILER=mpic++"
    "-DCMAKE_C_COMPILER=mpicc"
    "-DPETSC_EXECUTABLE_RUNS=TRUE"
  ] ++ (stdenv.lib.optionals) (stdenv ? isBlueGene) [
    "-DTARGET_NATIVE_ARCH=OFF"
  ];

  makeFlags = [ "VERBOSE=1" ];

  postInstall = ''
    mkdir -p $out/${python.sitePackages}
    ln -s $out/steps $out/${python.sitePackages}/steps
  '';

  doCheck = false;

  checkPhase = ''export LD_LIBRARY_PATH="$PWD/src:$LD_LIBRARY_PATH" ctest -V'';

  passthru = {
	  python-env = steps-python-env;
  };
}
