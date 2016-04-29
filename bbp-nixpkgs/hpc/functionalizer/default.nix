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
, hdf5
, generateDoc ? true
, asciidoc
, xmlto
, docbook_xsl
, libxslt }:

stdenv.mkDerivation rec {
  name = "functionalizer-3.7.0";
  buildInputs = [ stdenv pkgconfig boost hpctools zlib cmake mpiRuntime libxml2 python hdf5 ]
   ++ stdenv.lib.optional (generateDoc == true ) [ asciidoc xmlto docbook_xsl libxslt  ];

  src = fetchgitPrivate {
    url = "ssh://bbpcode.epfl.ch/building/Functionalizer";
    rev = "4f84d8ae165c9f006d3dd41069d0923add24cf9d";
    sha256 = "0y4916dsqiamh5n37281zwif1iznkskh5avq3qlwy256pmzjfsp7";
  };
  

  cmakeFlags=[ "-DBoost_USE_STATIC_LIBS=FALSE"
	       "-DUNIT_TESTS=TRUE" ]
	        ++ stdenv.lib.optional (generateDoc == true ) [ "-DFUNCTIONALIZER_DOCUMENTATION=TRUE" ] ;   

  enableParallelBuilding = true;
 
  outputs = [ "out" "doc" ];
  
}


