{ stdenv
, fetchurl
}:


stdenv.mkDerivation rec {
  name = "papi-${version}";
  version = "5.4.3";  
  
  src = fetchurl {
    url = "http://icl.cs.utk.edu/projects/papi/downloads/papi-${version}.tar.gz";
    sha256 = "0xg6l6jkzhazii5pzs9pqsbv46ch038zzw81y01s3w3lwa0xbvrs";
 };
 
  
  buildInputs = [  ];
  
  preConfigure = ''
                    cd src
                 '';
                 
                 
  configureScript = [ "sh ./configure" ];
  
  configureFlags = [ "--with-static-lib=yes"
                     "--with-shared-lib=yes" 
                     "--with-shlib" ];
                     
  enableParallelBuilding = true;  
  
  meta = {
    description = "Performance Application Programming Interface";
    longDescription = ''
     PAPI provides the tool designer and application engineer 
     with a consistent interface and methodology 
     for use of the performance counter hardware 
     found in most major microprocessors
    '';
    homepage = http://icl.cs.utk.edu/papi/index.html;
  };
}


