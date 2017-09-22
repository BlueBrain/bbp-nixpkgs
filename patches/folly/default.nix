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
 
  nativeBuildInputs = [ automake autoconf libtool python pkgconfig ];
  
  buildInputs = [   boost zlib libevent openssl 
                    google-gflags glog jemalloc 
                    snappy double_conversion libiberty ];
  
  preConfigure = ''
                    cd folly
                    autoreconf -ivf
                 '';
                 
                  
  configureFlags = [ 
                        "--with-boost=${boost.dev}" 
                        "--with-boost-libdir=${boost}/lib"
                    ];
                     
  enableParallelBuilding = true;  
 
  propagatedBuildInputs = [ glog openssl libevent ];
 
  meta = with stdenv.lib; {
    description = "An open-source C++ (utility) library developed and used at Facebook";
    
    longDescription = ''
        Folly (acronymed loosely after Facebook Open Source Library) is a library of C++11 components designed with practicality and efficiency in mind.
        Folly contains a variety of core library components used extensively at Facebook. 
        In particular, it's often a dependency of Facebook's other open source C++ efforts and place where those projects can share code.    
    '';
    
    license     = licenses.asl20;
    homepage    = https://github.com/facebook/folly;
    maintainers = [ maintainers.adev ];
    platforms   = platforms.unix;    
    
  };
}


