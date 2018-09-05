{ stdenv
, fetchFromGitHub
, pkgconfig
, boost
, cython
, cmake
, libtool
, gsl
, mpiRuntime
, python
, readline
}:

stdenv.mkDerivation rec {
  name = "nest-${version}";
  version = "2.14.0";
  buildInputs = [ stdenv cmake libtool pkgconfig mpiRuntime python cython ]
               ++ stdenv.lib.optional (isBGQ == false) [ gsl readline];

  src = fetchFromGitHub {
    owner = "nest";
    repo = "nest-simulator";
    rev = "de83e9e61b6d54160ca4ab89cf9d81990acd56f5";
    sha256 = "1cl0rhni4mjgk4qcsmlrbaz3l7bzm33pm99fhq42ydvjdhjmg8x2";
  };

  meta = {
    description = "The Neural Simulation Tool - NEST";
    longDescription = ''
      NEST is a simulator for spiking neural network models that focuses on
      the dynamics, size and structure of neural systems rather than on the
      exact morphology of individual neurons.
    '';
    platforms= stdenv.lib.platforms.all;
    homepage = https://github.com/nest/nest-simulator;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [
      "the NEST Initiative <info@nest-initiative.org>"
    ];
  };

  postPatch = ''
    echo fixing python install prefix
    CMAKE_FILES=(CMakeLists.txt cmake/ConfigureSummary.cmake
                 extras/ConnPlotter/CMakeLists.txt pynest/CMakeLists.txt
                 topology/CMakeLists.txt)
    for cmakefile in ''${CMAKE_FILES[@]} ; do
        echo patching ''$cmakefile
        substituteInPlace ''$cmakefile --replace "\''${CMAKE_INSTALL_PREFIX}/\''${PYEXECDIR}" "\''${PYEXECDIR}"
    done
    substituteInPlace extras/nest_vars.sh.in --replace 'NEST_PYTHON_PREFIX=''$NEST_INSTALL_DIR/' 'NEST_PYTHON_PREFIX='
    substituteInPlace testsuite/do_tests.sh.in --replace '@CMAKE_INSTALL_PREFIX@/@PYEXECDIR@' '@PYEXECDIR@'
  '';

  isBGQ = if builtins.hasAttr "isBlueGene" stdenv == true
           then builtins.getAttr "isBlueGene" stdenv else false;


  CXXFLAGS = stdenv.lib.optional (isBGQ) "-qnoipa";

  cmakeFlags = stdenv.lib.optional (mpiRuntime != null) [ "-Dwith-mpi=ON" ]
	       ++ stdenv.lib.optional (isBGQ) [ "-Denable-bluegene=Q"
					     "-Dwith-gsl=OFF"
					     "-Dwith-readline=OFF"
					     "-Dwith-python=ON"
					     "-Dstatic-libraries=OFF" "-DCMAKE_VERBOSE_MAKEFILE=ON"];


  enableParallelBuilding = true;

  outputs = [ "out" "doc" ];

  postInstall = ''
    mkdir -p $out/share/doc/nest/html
    echo '<html><head><meta http-equiv="refresh" content="0; URL=${meta.homepage}"/></head></html>' >$out/share/doc/nest/html/index.html
    sed -e "s@export NEST_DOC_DIR=.*@export NEST_DOC_DIR=$doc/share/doc/nest@" -i $out/bin/nest_vars.sh
  '';
}
