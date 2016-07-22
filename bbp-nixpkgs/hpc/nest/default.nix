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
  version = "2.10.0";
  buildInputs = [ stdenv cmake libtool pkgconfig mpiRuntime ]
               ++ stdenv.lib.optional (isBGQ == false) [ cython gsl readline python];

  src = fetchFromGitHub {
    owner = "nest";
    repo = "nest-simulator";  
    rev = "193594f9ce199a0db1322e7752da00237a671f4b";
    sha256 = "09w9mkdi6jlac020i4icvxnxwnbh33mwfnldm9il2fl3xd4gza14";
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


