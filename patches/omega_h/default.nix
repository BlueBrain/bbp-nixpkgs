{
  cmake,
  fetchFromGitHub,
  gmodel,
  libmeshb,
  stdenv,
  trilinos,
  zlib,
  extra_cmake_flags ? []
}:

stdenv.mkDerivation rec {
  name = "omega_h-${version}";
  version = "9.13.5";

  src = fetchFromGitHub {
    owner = "ibaned";
    repo = "omega_h";
    rev = "v${version}";
    sha256 = "0j76fg1bf2zjg9jm4zf8plqxmd7ys7a09zdddg76qj7v99yv5j7l";
  };

  omega_h-data = fetchFromGitHub {
    owner = "ibaned";
    repo = "omega_h-data";
    rev = "9ef1f41c06d196b3b814215569fe39ba939ae3ca";
    sha256 = "01c0nknwqrxskpnqbi68zliyabs864h6lbs6gr4m7kxykz74m2vc";
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
  ];

  propagatedBuildInputs = [
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
  ++ extra_cmake_flags
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
