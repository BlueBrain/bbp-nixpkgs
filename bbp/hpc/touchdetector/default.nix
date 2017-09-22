{ stdenv
, config
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
  version = "4.3.1-2017.06";

  nativeBuildInputs = [pkgconfig cmake ]
        ++ stdenv.lib.optional generateDoc [ asciidoc xmlto docbook_xsl libxslt ];


  buildInputs = [ boost hpctools zlib mpiRuntime libxml2  hdf5 ];

  src = fetchgitPrivate {
    url = config.bbp_git_ssh + "/building/TouchDetector";
    rev = "ae7cb236b99a3a9a7af894e47c5cbbd95f675cb3";
    sha256 = "04x6hc3pbxf1s2wlvdjm1qfcnvjpjc8yr02z4gissh647cym3rvg";
  };

  cmakeFlags =  [ "-DLIB_SUFFIX=" ] ++ stdenv.lib.optional generateDoc [ "-DTOUCHDETECTOR_DOCUMENTATION=TRUE" ];

  postInstall = ''
                install -D ../LICENSE.txt $out/share/doc/TouchDetector/LICENSE.txt ;
                install -D ../README.txt $out/share/doc/TouchDetector/README.txt ;
                '';


  outputs =  [ "out" ] ++ stdenv.lib.optional generateDoc "doc";

  crossAttrs = {
    ## enforce mpiwrapper in cross compilation mode for bgq
    cmakeFlags= cmakeFlags ++ [ "-DCMAKE_CXX_COMPILER=mpic++" "-DCMAKE_C_COMPILER=mpicc" ];
  };



}


