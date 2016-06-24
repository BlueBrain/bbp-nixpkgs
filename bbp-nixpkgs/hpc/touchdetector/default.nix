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
  name = "touchdetector-4.3.0";
  buildInputs = [ stdenv pkgconfig boost hpctools zlib cmake mpiRuntime libxml2  hdf5 ]
	++ stdenv.lib.optional (generateDoc == true) [ asciidoc xmlto docbook_xsl libxslt ];

  src = fetchgitPrivate {
    url = "ssh://bbpcode.epfl.ch/building/TouchDetector";
    rev = "80ed9fac1de0c566c9c599bb08fbf9dc7ef66202";
    sha256 = "0b6dl4vhi90jh36qlyahl3s89v0fby5mm2imilv91dsz0jc6xm8r";
  };

  cmakeFlags =  stdenv.lib.optional (generateDoc == true) [ "-DTOUCHDETECTOR_DOCUMENTATION=TRUE" ]; 

  postInstall = ''
		install -D ../LICENSE.txt $out/share/doc/TouchDetector/LICENSE.txt ;
		install -D ../README.txt $out/share/doc/TouchDetector/README.txt ;
		'';

  enableParallelBuilding = true;

  outputs =  [ "out" "doc" ];

}


