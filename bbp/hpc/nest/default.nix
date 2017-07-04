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
  buildInputs = [ stdenv cmake libtool pkgconfig mpiRuntime ]
               ++ stdenv.lib.optional (isBGQ == false) [ cython gsl readline python];

  src = fetchFromGitHub {
    owner = "nest";
    repo = "nest-simulator";  
    rev = "5003e2b32f409bd13ad570df6093532c993466a2";
    sha256 = "0zl2nw9nhps1swyiyasnb9fspffm71c45ayqn5grqrxs3qv4xh7m";
  };
  

  isBGQ = if builtins.hasAttr "isBlueGene" stdenv == true
           then builtins.getAttr "isBlueGene" stdenv else false;


  CXXFLAGS = stdenv.lib.optional (isBGQ) "-qnoipa";

  cmakeFlags = stdenv.lib.optional (mpiRuntime != null) [ "-Dwith-mpi=ON" ]
	       ++ stdenv.lib.optional (isBGQ) [ "-Denable-bluegene=Q"
					     "-Dwith-gsl=OFF"
					     "-Dwith-readline=OFF"
					     "-Dwith-python=OFF"
					     "-Dstatic-libraries=ON" ];


  enableParallelBuilding = true;
 
  outputs = [ "out" "doc" ];
  
}


