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
  name = "touchdetector-${version}";
  version = "4.3.0";

  nativeBuildInputs = [pkgconfig cmake ]
        ++ stdenv.lib.optional (generateDoc == true) [ asciidoc xmlto docbook_xsl libxslt ];
			


  buildInputs = [ boost hpctools zlib mpiRuntime libxml2  hdf5 ];

  src = fetchgitPrivate {
    url = "ssh://bbpcode.epfl.ch/building/TouchDetector";
    rev = "80ed9fac1de0c566c9c599bb08fbf9dc7ef66202";
    sha256 = "0b6dl4vhi90jh36qlyahl3s89v0fby5mm2imilv91dsz0jc6xm8r";
  };

  cmakeFlags =  [ "-DLIB_SUFFIX=" ] ++ stdenv.lib.optional (generateDoc == true) [ "-DTOUCHDETECTOR_DOCUMENTATION=TRUE" ]; 

  postInstall = ''
                install -D ../LICENSE.txt $out/share/doc/TouchDetector/LICENSE.txt ;
                install -D ../README.txt $out/share/doc/TouchDetector/README.txt ;
                '';


  outputs =  [ "out" "doc" ];

  crossAttrs = {
    ## enforce mpiwrapper in cross compilation mode for bgq
    cmakeFlags= cmakeFlags ++ [ "-DCMAKE_CXX_COMPILER=mpic++" "-DCMAKE_C_COMPILER=mpicc" ];
  };



}


