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
  
  buildInputs = [ stdenv pkgconfig boost hpctools zlib cmake mpiRuntime libxml2 python-env hdf5 ]
   ++ stdenv.lib.optional (generateDoc == true ) [ asciidoc xmlto docbook_xsl libxslt  ];

  src = fetchgitPrivate {
    url = "ssh://bbpcode.epfl.ch/building/Functionalizer";
    rev = "76274c82a1095a98817b39087d78836165fb6ac7";
    sha256 = "1dlmaac6d7cc4m8mcfkaavczw35rz35pg1za26ssb76iaxahaqhx";
  };
  

  cmakeFlags=[ "-DBoost_USE_STATIC_LIBS=FALSE"
	       "-DUNIT_TESTS=TRUE" ]
	        ++ stdenv.lib.optional (generateDoc == true ) [ "-DFUNCTIONALIZER_DOCUMENTATION=TRUE" ] ;   

  enableParallelBuilding = true;
 
  outputs = [ "out" "doc" ];
  
}


