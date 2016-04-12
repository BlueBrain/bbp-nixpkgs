{ stdenv, fetchgitPrivate, pkgconfig, boost, hpctools, libxml2, cmake, mpiRuntime, zlib, python, hdf5, asciidoc, xmlto, docbook_xsl, libxslt }:

stdenv.mkDerivation rec {
  name = "functionalizer-3.6.0-DEV";
  buildInputs = [ stdenv pkgconfig boost hpctools zlib cmake mpiRuntime libxml2 python hdf5 asciidoc xmlto docbook_xsl libxslt ];

  src = fetchgitPrivate {
    url = "ssh://bbpcode.epfl.ch/building/Functionalizer";
    rev = "85d21868571f8bc5144644cd795b4d683846b003";
    sha256 = "0psb4vkc8qhh72579la4xbd5f48aag66136cvrn1s8nsjymdfsbj";
  };
  
  cmakeFlags=[ "-DBoost_USE_STATIC_LIBS=FALSE"
	       "-DUNIT_TESTS=TRUE"
	       "-DFUNCTIONALIZER_DOCUMENTATION=TRUE"
	     ];   

  enableParallelBuilding = true;
 
  outputs = [ "out" "doc" ];
  
}


