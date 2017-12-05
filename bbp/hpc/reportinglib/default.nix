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
  version = "2.4.2-dev201710";
  meta = {
    description = "Blue Brain Reporting library";
    homepage = "https://bbpcode.epfl.ch/code/#/admin/projects/sim/reportinglib/bbp";
    license = {
      fullName = "Blue Brain Project 2017, 2018 All rights reserved";
    };
    maintainers = with config.maintainers; [
      adevress
      ferdonline
      "Arseny V. Povolotsky - arseny.povolotsky@epfl.ch"
    ];
  };
  src = fetchgitPrivate {
    url = config.bbp_git_ssh + "/sim/reportinglib/bbp";
    rev = "160d01ae0d17b366368706f1c8d9b5e115754a36";
    sha256 = "08i78alrwk4p462qjrl5vj0xwhja73a24k8ynainvhfnrcam2wcj";
  };

  buildInputs = [ stdenv cmake boost pkgconfig  mpiRuntime];


  docCss = ../../common/vizDoc/github-pandoc.css;
  postInstall = ''
    mkdir -p $out/share/doc/reportinglib/html
    ${pandoc}/bin/pandoc -s -S --self-contained \
      -c ${docCss} ${src}/README.md \
      -o $out/share/doc/reportinglib/html/index.html
  '';
  outputs = [ "out" "doc" ];
}
