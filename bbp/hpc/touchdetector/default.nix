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
  version = "4.3.1-2017.10dev";

  nativeBuildInputs = [pkgconfig cmake ]
        ++ stdenv.lib.optional generateDoc [ asciidoc xmlto docbook_xsl libxslt ];


  buildInputs = [ boost hpctools zlib mpiRuntime libxml2  hdf5 ];

  src = fetchgitPrivate {
    url = config.bbp_git_ssh + "/building/TouchDetector";
    rev = "c6234115e887b6e27d6949a9b08620b9cc56c573";
    sha256 = "193rivdm3np9ss7jcr0wfv80wrvar4a2z5rfv1fizksrha16w2ri";
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


