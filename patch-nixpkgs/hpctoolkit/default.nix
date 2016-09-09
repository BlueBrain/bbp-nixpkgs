{ stdenv
, perl
, fetchFromGitHub
, xercesc
, pkgconfig 
, cmake
, file
, unzip
, libelf
, libxml2
, boost
, papi
, libunwind
}:

let
  xed = stdenv.mkDerivation rec {
        name = "xed-${version}";
        version = "2015-09-10";
        
          src = fetchFromGitHub {
            owner = "HPCToolkit";
            repo = "hpctoolkit-externals";
            rev = "3d2953623357bb06e9a4b51eca90a4b039c2710e";
            sha256 = "0b9ha9s2hwhsf1yzzynflj1w6ixw4yadqcyzhb27y6cqqyni20x1";
         };
         
        configurePhase = ''echo "no configure for xed" '';
        
        nativeBuildInputs = [ unzip ];        
        
        dontBuild = true;
        
        installPhase = ''
            mkdir -p $out
            unzip distfiles/xed-install-base-${version}-lin-x86-64.zip
            cp -r kits/xed-install-base-${version}-lin-x86-64/* $out/            
            '';
        
        # hpctoolkit requires xed
        # xed is a free-to-use proprietary blob from Intel
        # This is not portable, need a binary download and should be avoided 
        # but it is currently the only way to install it....
  
  };

  hpc-externals = stdenv.mkDerivation rec {
          name = "hpctolkit-externals-${version}";
          version = "5.0.1";  
          
          src = fetchFromGitHub {
            owner = "HPCToolkit";
            repo = "hpctoolkit-externals";
            rev = "3d2953623357bb06e9a4b51eca90a4b039c2710e";
            sha256 = "0b9ha9s2hwhsf1yzzynflj1w6ixw4yadqcyzhb27y6cqqyni20x1";
         };
         
          nativeBuildInputs = [ cmake file ];
          
          buildInputs = [ stdenv pkgconfig libxml2 boost xercesc libelf xed ];
          
          configureFlags = [ "--with-xerces=${xercesc}"
                 "--with-libxml2=${libxml2}"
                 "--with-boost=${boost.dev}"
                 "--with-libunwind=${libunwind}"
                 "--with-libelf=${libelf}"
                 "--with-xed2=${xed}"  ];
          
          dontUseCmakeConfigure = true;

          enableParallelBuilding = true;  
    
        };

in

stdenv.mkDerivation rec {
  name = "hpctolkit-${version}";
  version = "5.0.1-trunk";  
  
  src = fetchFromGitHub {
    owner = "HPCToolkit";
    repo = "hpctoolkit";
    rev = "78b3a2c66778c7a639c141fde2d19067a88de0ff";
    sha256 = "0qrwnm6ssj41w126r81g0vbikdv0fgfksdv9xcbnk60b04g2ya97";
 };
 
  nativeBuildInputs = [ perl file ]; 
  
  buildInputs = [ xercesc hpc-externals papi ];
  
  configureFlags = [ "--with-externals=${hpc-externals}"
                     "--with-papi=${papi}" ];

  enableParallelBuilding = true;  
  
  meta = {
    description = "HPCToolkit: profiling toolkit for HPC applications";
    longDescription = ''
      HPCToolkit: profiling toolkit for HPC applications
    '';
    homepage = http://hpctoolkit.org/software.html;
  };
}

