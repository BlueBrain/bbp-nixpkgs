{fetchgitExternal, stdenv, boost, cmake, bbpsdk, cairo, curl, libxml2, brion, pkgconfig}:

stdenv.mkDerivation rec {
  name = "muk-${version}";
  version = "3.9.0";
  buildInputs = [ stdenv bbpsdk brion boost cairo curl libxml2 ];
  nativeBuildInputs = [ pkgconfig cmake ];

  src = fetchgitExternal {
    url = "ssh://bbpcode.epfl.ch/sim/MUK";
    rev = "e748e399b5e2203bbcd132cddd4df31dee7a4467";
    sha256 = "0q1nrirp6n5v1r66zc21jbyvhfndkhm9hniycyl6gsbazwlrrnnp";
  };
}
