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
  version = "3.9.1";
  
  buildInputs = [ boost hpctools zlib mpiRuntime libxml2 hdf5 ];
  
  nativeBuildInputs = [ pkgconfig cmake python-env ] ++ stdenv.lib.optional (generateDoc == true ) [ asciidoc xmlto docbook_xsl libxslt  ];

  src = fetchgitPrivate {
    url = "ssh://bbpcode.epfl.ch/building/Functionalizer";
    rev = "4955bd86fb1171c64d774566eb6408f2edf99348";
    sha256 = "17m7nkkryydm7jy6rywfhv52bsgff6n6yrq69xjvkj30q61203g5";
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


