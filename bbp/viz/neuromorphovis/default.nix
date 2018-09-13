{ stdenv
, config
, fetchurl
, fetchgit
}:

stdenv.mkDerivation rec {

    name = "neuromorphovis";
    origin_version = "2.79b";
    version = "${origin_version}-nmv";
    src = fetchurl {  url = "http://download.blender.org/release/Blender2.79/blender-2.79b-linux-glibc219-x86_64.tar.bz2";
      sha256 = "0g0q0ibw1laq4n63qvszm4k9zk618kn4w8pz6kxfcv8c1d74m0j3";
    };

   src-nvm = fetchgit {
     url =  "https://github.com/BlueBrain/NeuroMorphoVis.git";
     sha256 = "1p3cw5rk2vd5gkqspqljh15z7qfgk0r27l86paydwd3iinsswdc3";
   };

   deps = fetchurl {
     url = "file:///gpfs/bbp.cscs.ch/home/podhajsk/neuromorphovis-deps2.tar.gz";
     sha256 = "1126wiis918sf68czbdlx99df7as0xf2414pya8b2inhwjxc2m14";
  };

  installPhase = ''
    mkdir -p $out
    rm -rf 2.79/python/lib/python3.5/site-packages/numpy/
    tar xf ${deps} -C 2.79/python/lib/python3.5/site-packages
    cp -rf ${src-nvm}/ 2.79/scripts/addons/NeuroMorphoVis
    cp -rf * $out
  '';
}
