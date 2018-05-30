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
  version = "2.4.2-2018.03";
  src = fetchgitPrivate {
    url = config.bbp_git_ssh + "/sim/reportinglib/bbp";
    rev = "a2afa0fcf994efa1570bb267c7d24e9a53ed5622";
    sha256 = "1mc5qrp1qazcsb6d6v5933vz07ca3wsbpbk06qlw6imq1vf0hx6q";
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
