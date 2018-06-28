{ stdenv
, fetchgit
, boost
, cmake
, pkgconfig
, lunchbox
, pression
}:

stdenv.mkDerivation rec {
  name = "collage-${version}";
  version = "1.7-dev201708";

  buildInputs = [ stdenv pkgconfig boost cmake lunchbox pression ];

  src = fetchgit {
    url = "https://github.com/Eyescale/Collage.git";
    rev = "e2bc13dc2f85535e1f8caeb13f53b62c2bacb734";
    sha256 = "1cm91dmbjjx0qylsjh9rqjmmcgcfbwhciydj1y25s0nlwnkrh665";
  };

  enableParallelBuilding = true;

  propagatedBuildInputs = [ lunchbox pression ];

}
