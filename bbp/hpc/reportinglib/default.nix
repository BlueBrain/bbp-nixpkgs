{ boost
, cmake
, config
, fetchgitPrivate
, mpiRuntime
, pandoc
, pkgconfig
, stdenv
}:

stdenv.mkDerivation rec {
  name = "reportinglib-${version}";
  version = "2.4.2-2018.06";
  src = fetchgitPrivate {
    url = config.bbp_git_ssh + "/sim/reportinglib/bbp";
    rev = "09037b2e755b83aa9429982c6b7c1531c1fb19d3";
    sha256 = "0vmfzc2v62bd4vc84sas114x0s95gpdx1g6g5jcmq8w2cwv7dv6h";
  };

  buildInputs = [ stdenv cmake boost pkgconfig  mpiRuntime];


  docCss = ../../common/vizDoc/github-pandoc.css;
  postInstall = [
	"mkdir -p $doc/share/doc"
 ] ++ (stdenv.lib.optional) (pandoc != null) [ ''
    mkdir -p $out/share/doc/reportinglib/html
    ${pandoc}/bin/pandoc -s -S --self-contained \
      -c ${docCss} ${src}/README.md \
      -o $out/share/doc/reportinglib/html/index.html
  '' ];

  outputs = [ "out" "doc" ];

  meta = {
    description = "Blue Brain Reporting library";
    homepage = "https://bbpcode.epfl.ch/code/#/admin/projects/sim/reportinglib/bbp";
    license = {
      fullName = "Blue Brain Project 2017, 2018 All rights reserved";
    };
    maintainers = with config.maintainers; [
      jamesgkind
      pramodskumbhar
    ];
  };


}
