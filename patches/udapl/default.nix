
{ stdenv, fetchurl, ibverbs, librdmacm }:

stdenv.mkDerivation rec {

  name = "udapl-${version}";
  version = "2.1.10";

  srcs = fetchurl {
	url = "https://www.openfabrics.org/downloads/dapl/dapl-${version}.tar.gz";
	sha256 = "16zsa2vbm5b7aniq82bsiwag47jbi3y3yi9mdpmdiapw8wxxzdlf";
  };
 
  buildInputs = [ ibverbs librdmacm ];

  #configureFlags = [ "--sysconfdir=/etc/" ];


  meta = with stdenv.lib; {
    homepage = https://www.openfabrics.org/;
    license = licenses.bsd2;
    platforms = with platforms; linux ++ freebsd;
  };
}


