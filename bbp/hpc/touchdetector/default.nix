{ asciidoc
, boost
, cmake
, config
, docbook_xsl
, fetchgitPrivate
, generateDoc ? true
, hdf5
, hpctools
, libxml2
, libxslt
, mpiRuntime
, pandoc
, pkgconfig
, stdenv
, xmlto
, zlib
}:

stdenv.mkDerivation rec {
  name = "touchdetector-${version}";
  version = "4.3.1-2017.10dev";
  meta = {
    description = "detects autaptic touches between branches";
    homepage = "https://bbpcode.epfl.ch/code/#/admin/projects/building/TouchDetector";
    maintainers = with config.maintainers; [
      brunomaga
      adevress
    ];
    license = {
      fullName = "Blue Brain Project 2017, 2018 All rights reserved";
    };
  };
  src = fetchgitPrivate {
    url = config.bbp_git_ssh + "/building/TouchDetector";
    rev = "846a43b56df5b830cafd35e0c4d2d1f944330eb3";
    sha256 = "0pz0j84j35c1r7hx6xjl2r721hs4dk5s5d91qj9gmyc0rmr1w29s";
  };

  buildInputs = [
    boost
    hdf5
    hpctools
    libxml2
    mpiRuntime
    zlib
  ];
  nativeBuildInputs = [pkgconfig cmake ]
  ++ stdenv.lib.optional generateDoc [ asciidoc xmlto docbook_xsl libxslt ];

  cmakeFlags = [ "-DLIB_SUFFIX=" ]
  ++ stdenv.lib.optional generateDoc [ "-DTOUCHDETECTOR_DOCUMENTATION=TRUE" ];

  docCss = ../../common/vizDoc/github-pandoc.css;
  postInstall = [
	''
	mkdir -p $doc/share
	''
   ] ++ (stdenv.lib.optional ) (pandoc != null) [ ''
    install -D ../LICENSE.txt $out/share/doc/TouchDetector/LICENSE.txt ;
    mkdir -p $out/share/doc/TouchDetector/html
    ${pandoc}/bin/pandoc -s -S --self-contained \
      -c ${docCss} ${src}/README.md \
      -o $out/share/doc/TouchDetector/html/index.html
  ''];

  outputs =  [ "out" "doc" ];

  crossAttrs = {
    ## enforce mpiwrapper in cross compilation mode for bgq
    cmakeFlags= cmakeFlags ++ [ "-DCMAKE_CXX_COMPILER=mpic++" "-DCMAKE_C_COMPILER=mpicc" ];
  };
}
