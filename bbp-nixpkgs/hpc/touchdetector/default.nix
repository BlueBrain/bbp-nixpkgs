{ 
  stdenv
, fetchgitPrivate
, pkgconfig
, boost
, hpctools
, libxml2 
, cmake
, mpiRuntime
, zlib 
, hdf5
, generateDoc ? true
, asciidoc
, xmlto
, docbook_xsl
, libxslt 
}:

stdenv.mkDerivation rec {
  name = "touchdetector-4.3.0-DEV";
  buildInputs = [ stdenv pkgconfig boost hpctools zlib cmake mpiRuntime libxml2  hdf5 ]
	++ stdenv.lib.optional (generateDoc == true) [ asciidoc xmlto docbook_xsl libxslt ];

  src = fetchgitPrivate {
    url = "ssh://bbpcode.epfl.ch/building/TouchDetector";
    rev = "a924602d90db567ac283abdd42fa25487ecf990a";
    sha256 = "0xcjh299xhmmvv42pq91k6v0xq677b1ax9xb7j60raa3mm2r39ld";
  };

  cmakeFlags =  stdenv.lib.optional (generateDoc == true) [ "-DTOUCHDETECTOR_DOCUMENTATION=TRUE" ]; 

  postInstall = ''
		install -D ../LICENSE.txt $out/share/doc/TouchDetector/LICENSE.txt ;
		install -D ../README.txt $out/share/doc/TouchDetector/README.txt ;
		'';

  enableParallelBuilding = true;

  outputs =  [ "out" "doc" ];

}


