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
, libbfd
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
            rev = "ab50b065ada2545938abae2c6359c62303fe1588";
            sha256 = "11mykp1pwyvkp9ma00vzvrkv2g8dd5b5n6rx648sni88dcqp6p1k";
         };
         
          nativeBuildInputs = [ cmake file ];
          
          buildInputs = [ stdenv pkgconfig libbfd libxml2 boost xercesc libelf xed ];
          
          configureFlags = [ "--with-xerces=${xercesc}" "--with-xed2=${xed}" ];
          
          dontUseCmakeConfigure = true;

          enableParallelBuilding = true;  
    
        };

in

stdenv.mkDerivation rec {
  name = "hpctoolkit-${version}";
  version = "5.0.1-trunk";  
  
  src = fetchFromGitHub {
    owner = "HPCToolkit";
    repo = "hpctoolkit";
    rev = "09dd2a1be1ab5cbdf5b2b49bab1bc7289229971b";
    sha256 = "1x7nifkyslxfpqspbpkkrdryr44xw1aphw3zjvh9ilf1dxfcdkq3";
 };
 
  nativeBuildInputs = [ perl file ]; 
  
  buildInputs = [ xercesc hpc-externals papi ];
  
  configureFlags = [ "--with-externals=${hpc-externals}"
                     "--with-papi=${papi}" ];

  enableParallelBuilding = false;
  
  hardeningDisable = [ "format" ];

  meta = {
    description = "HPCToolkit: profiling toolkit for HPC applications";
    longDescription = ''
      HPCToolkit: profiling toolkit for HPC applications
    '';
    homepage = http://hpctoolkit.org/software.html;
  };
}

