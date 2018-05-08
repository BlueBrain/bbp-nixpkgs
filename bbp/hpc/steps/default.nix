{
  blas
, config
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
  version = "3.3.0";

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
    rev = "5edef4f589efa49ecfaaeebc3599985df03f4126";
    sha256 = "1xg8ibxdwv6s0lhgd5zifgq2n77lhmvlnw75vck20p3xkg1xbmga";
  };

  meta = {
    description = "STochastic Engine for Pathway Simulation";
    longDescription = ''
      STEPS is a package for exact stochastic simulation of
      reaction-diffusion systems in arbitrarily complex 3D geometries.
      Our core simulation algorithm is an implementation of Gillespie's SSA,
      extended to deal with diffusion of molecules over the elements of a 3D
      tetrahedral mesh.
    '';
    platforms = stdenv.lib.platforms.all;
    homepage = http://steps.sourceforge.net;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [
      "the NEST Initiative"
    ];
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
    mkdir -p $out/share/doc/steps/html
    echo '<html><head><meta http-equiv="refresh" content="0; URL=${meta.homepage}"/></head></html>' >$out/share/doc/steps/html/index.html
  '';

  doCheck = false;

  checkPhase = ''export LD_LIBRARY_PATH="$PWD/src:$LD_LIBRARY_PATH" ctest -V'';

  passthru = {
	  python-env = steps-python-env;
  };

  outputs = [ "out" "doc" ];
}
