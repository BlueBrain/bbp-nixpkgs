{ stdenv, fetchgit, cmake, pkgconfig, openssl, libxml2, boost }:

stdenv.mkDerivation rec {
  name = "davix-0.4.0";
  buildInputs = [ stdenv pkgconfig cmake openssl libxml2 boost boost ];

  src = fetchgit {
    url = "https://github.com/cern-it-sdc-id/davix.git";
    rev = "9d8f400ec1882602fc18312f35d617fe94ebbd67";
    sha256 = "074i8xa6q9sf9ggqbdws64dmw5l1y17as81inl3sj9gc8n9abqvx";
  };
}

