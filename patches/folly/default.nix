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
    rev = "ee207f19892790e091082cc7c7ab8c5df0398061";
    sha256 = "1ldzfk75blag00gsla84fdysv0ilcs1psadaz3jasqid857z0r74";
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


