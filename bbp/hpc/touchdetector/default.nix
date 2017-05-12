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
  version = "4.3.0-2017.05";

  nativeBuildInputs = [pkgconfig cmake ]
        ++ stdenv.lib.optional (generateDoc == true) [ asciidoc xmlto docbook_xsl libxslt ];
			


  buildInputs = [ boost hpctools zlib mpiRuntime libxml2  hdf5 ];

  src = fetchgitPrivate {
    url = "ssh://bbpcode.epfl.ch/building/TouchDetector";
    rev = "d3e0989d738c74fe13b103f3a1994c4b5b9b93c6";
    sha256 = "00bb4dwxmkpm9z4qbd8aaab9fj5m8nvsdjkhs2504kg03ivhv38l";
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


