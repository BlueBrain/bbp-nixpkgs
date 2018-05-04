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
  version = "2.12.0-201706";
  buildInputs = [ stdenv cmake libtool pkgconfig mpiRuntime python cython ]
               ++ stdenv.lib.optional (isBGQ == false) [ gsl readline];

  src = fetchFromGitHub {
    owner = "nest";
    repo = "nest-simulator";
    rev = "5003e2b32f409bd13ad570df6093532c993466a2";
    sha256 = "0zl2nw9nhps1swyiyasnb9fspffm71c45ayqn5grqrxs3qv4xh7m";
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

  isBGQ = if builtins.hasAttr "isBlueGene" stdenv == true
           then builtins.getAttr "isBlueGene" stdenv else false;


  CXXFLAGS = stdenv.lib.optional (isBGQ) "-qnoipa";

  cmakeFlags = stdenv.lib.optional (mpiRuntime != null) [ "-Dwith-mpi=ON" ]
	       ++ stdenv.lib.optional (isBGQ) [ "-Denable-bluegene=Q"
					     "-Dwith-gsl=OFF"
					     "-Dwith-readline=OFF"
					     "-Dwith-python=ON"
					     "-Dstatic-libraries=OFF" ];


  enableParallelBuilding = true;

  outputs = [ "out" "doc" ];

  postInstall = ''
    mkdir -p $out/share/doc/nest/html
    echo '<html><head><meta http-equiv="refresh" content="0; URL=${meta.homepage}"/></head></html>' >$out/share/doc/nest/index.html
  '';
}
