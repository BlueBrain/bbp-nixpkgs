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
  version = "2.4.2-2018.07";
  src = fetchgitPrivate {
    url = config.bbp_git_ssh + "/sim/reportinglib/bbp";
    rev = "949fd223419dce20d814751f33f2a757073607a5";
    sha256 = "0nwdn7m4dbls06ldhnaxi5c0jl8z5348mqyb3cnpykjwn6y937yp";
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
