{ stdenv
, fetchgitPrivate
, pkgconfig
, boost
, hpctools
, libxml2
, cmake
, mpiRuntime
, zlib
, python
, pythonPackages
, hdf5
, generateDoc ? true
, asciidoc
, xmlto
, docbook_xsl
, libxslt }:

let
  python-env = python.buildEnv.override {
		extraLibs = [ pythonPackages.h5py ];
  };

in 

stdenv.mkDerivation rec {
  name = "functionalizer-${version}";
  version = "3.9.2";
  
  buildInputs = [ boost hpctools zlib mpiRuntime libxml2 hdf5 ];
  
  nativeBuildInputs = [ pkgconfig cmake python-env ] ++ stdenv.lib.optional (generateDoc == true ) [ asciidoc xmlto docbook_xsl libxslt  ];

  src = fetchgitPrivate {
    url = "ssh://bbpcode.epfl.ch/building/Functionalizer";
    rev = "73b641813d233060ea9c4efd8d603accbc9c35d0";
    sha256 = "1xkxm46lryw4giggx0jn36hmknhkvvbca1ymcgakwm3r3jmq0hgv";
  };
  

  cmakeFlags=[ "-DUNIT_TESTS=TRUE" ''-DLIB_SUFFIX='' ]
	        ++ stdenv.lib.optional (generateDoc == true ) [ "-DFUNCTIONALIZER_DOCUMENTATION=TRUE" ] ;   

  enableParallelBuilding = true;
 
  outputs = [ "out" "doc" ];

  crossAttrs = {
    ## enforce mpiwrapper in cross compilation mode for bgq
    cmakeFlags= cmakeFlags ++ [ "-DCMAKE_CXX_COMPILER=mpic++" "-DCMAKE_C_COMPILER=mpicc" ];
  };
  
}


