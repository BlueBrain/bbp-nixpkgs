{ stdenv
, pkgconfig
, automake
, autoconf
, libtool
, fetchFromGitHub
, boost
, libevent
, zlib
, openssl
, google-gflags
, glog
, jemalloc 
, snappy
, python
, double_conversion
, libiberty
}:


stdenv.mkDerivation rec {
  name = "folly-${version}";
  version = "2016.07.26";  
  
  src = fetchFromGitHub {
    owner = "facebook";
    repo = "folly";
    rev = "66950202701a4fa60fde106f5bcae6d8dbe4327d";
    sha256 = "0gyzpphmnr9bdd8jlz7rd6fkrcx6ssgrv2ah7glyvghq6qhrj6dy";
 };
 
  
  buildInputs = [ automake autoconf libtool python pkgconfig boost zlib libevent openssl google-gflags glog jemalloc snappy double_conversion libiberty ];
  
  preConfigure = ''
                    cd folly
		    autoreconf -ivf
                 '';
                 
                 
  configureScript = [ "sh ./configure" ];
  
  configureFlags = [ ];
                     
  enableParallelBuilding = true;  
  
  meta = {
    description = " folly whoah";
    longDescription = ''
    '';
  };
}


