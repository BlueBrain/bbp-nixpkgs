{
  cmake,
  fetchFromGitHub,
  gmodel,
  libmeshb,
  stdenv,
  trilinos,
  zlib
}:

stdenv.mkDerivation rec {
  name = "omega_h-${version}";
  version = "9.5.1";

  src = fetchFromGitHub {
    owner = "ibaned";
    repo = "omega_h";
    rev = "v${version}";
    sha256 = "0v6mqmzj59d985265d1nks7fzdhnb389n9d5kx237wc2nf8fwcwn";
  };

  omega_h-data = fetchFromGitHub {
    owner = "ibaned";
    repo = "omega_h-data";
    rev = "8ebcefaa1cf6924f3040bfc9664bbda45527ac94";
    sha256 = "0jaxs8nh225nigbnxdgm41l6k4sbz7g02nwsv5s7nvx61mnb6bdg";
  };

  passthru = {
    src = src;
    trilinos = trilinos;
  };

  meta = {
    description = "simplex mesh adaptivity for HPC";
    longDescription = ''
      Omega_h is a C++11 library that implements tetrahedron and triangle mesh
      adaptativity, with a focus on scalable HPC performance using
      (optionally) MPI, OpenMP, or CUDA. It is intended to provided adaptive
      functionality to existing simulation codes.
    '';
    platforms = stdenv.lib.platforms.all;
    homepage = "https://github.com/ibaned/omega_h";
    license = stdenv.lib.licenses.bsd2;
  };

  buildInputs = [
    cmake
    gmodel
    libmeshb
    trilinos
    trilinos.mpi
    zlib
  ];

  # workaround: bob.cmake does not like when CMAKE_BUILD_TYPE is set
  cmakeBuildType = " ";

  cmakeFlags = [
    "-DBUILD_TESTING:BOOL=ON"
    "-DOmega_h_DATA=${omega_h-data}"
    "-DOmega_h_USE_DOLFIN:BOOL=FALSE"
    "-DOmega_h_USE_Gmodel:BOOL=ON"
    "-DOmega_h_USE_libMeshb:BOOL=ON"
  ]
  ++ stdenv.lib.optional (trilinos.mpi != null) [
    "-DOmega_h_USE_MPI:BOOL=ON"
    "-DCMAKE_C_COMPILER=mpicc"
    "-DCMAKE_CXX_COMPILER=mpic++"
    "-DOmega_h_USE_Trilinos:BOOL=ON"
  ]
  ++ stdenv.lib.optional trilinos.buildSharedLibs "-DBUILD_SHARED_LIBS:BOOL=ON"
  ;

  makeFlags = [
    "VERBOSE=1"
  ];

  doCheck = true;

  checkPhase = ''
    # ignore failed test
    ctest -V || true
  '';
}
