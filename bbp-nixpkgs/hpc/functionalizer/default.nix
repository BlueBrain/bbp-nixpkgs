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
    rev = "fc7e1fa2e908b789dea0bf4efa8a2db8a5d3c43a";
    sha256 = "1w0xr9g6rwv2dxxkqj2jyiz0y5gp3zwkbzss2rlvgzlfykpjvgin";
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


