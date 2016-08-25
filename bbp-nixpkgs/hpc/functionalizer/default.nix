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
  version = "3.8.1";
  
  buildInputs = [ stdenv pkgconfig boost hpctools zlib cmake mpiRuntime libxml2 python-env hdf5 ]
   ++ stdenv.lib.optional (generateDoc == true ) [ asciidoc xmlto docbook_xsl libxslt  ];

  src = fetchgitPrivate {
    url = "ssh://bbpcode.epfl.ch/building/Functionalizer";
    rev = "2c9b8b2ea99c5e05b60ea4aa1d954b16086d9c1f";
    sha256 = "0g6lij714aafbs0rpg0dlc9vgz5hsfi3g1yx8d1333fpkg7j7iri";
  };
  

  cmakeFlags=[ "-DBoost_USE_STATIC_LIBS=FALSE"
	       "-DUNIT_TESTS=TRUE" ]
	        ++ stdenv.lib.optional (generateDoc == true ) [ "-DFUNCTIONALIZER_DOCUMENTATION=TRUE" ] ;   

  enableParallelBuilding = true;
 
  outputs = [ "out" "doc" ];
  
}


