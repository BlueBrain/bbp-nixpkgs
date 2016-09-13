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
  version = "3.9.0";
  
  buildInputs = [ boost hpctools zlib mpiRuntime libxml2 hdf5 ];
  
  nativeBuildInputs = [ pkgconfig cmake python-env ] ++ stdenv.lib.optional (generateDoc == true ) [ asciidoc xmlto docbook_xsl libxslt  ];

  src = fetchgitPrivate {
    url = "ssh://bbpcode.epfl.ch/building/Functionalizer";
    rev = "161df613d52d1ac41d8fb105daf901e7f12e8696";
    sha256 = "1rw9wby8jr2ffs3i6li37xfawimmihrvkpc0w0aypsa1cd6wxh1n";
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


