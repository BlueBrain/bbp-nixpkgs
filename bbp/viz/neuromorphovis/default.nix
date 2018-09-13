{ stdenv
, config
, fetchurl
, fetchgitPrivate
}:

stdenv.mkDerivation rec {

    name = "neuromorphovis";
    origin_version = "2.79b";
    version = "${origin_version}-nmv";
    src = fetchurl {  url = "http://download.blender.org/release/Blender2.79/blender-2.79b-linux-glibc219-x86_64.tar.bz2";
      sha256 = "0g0q0ibw1laq4n63qvszm4k9zk618kn4w8pz6kxfcv8c1d74m0j3";
    };

   src-nvm = fetchgitPrivate {
	url =   config.bbp_git_ssh + "/user/abdellah/NeuroMorphoVis";
        sha256 = "083vy2mw7rwiwbr7ybcv637s0hk648pv8qj1ydch3bkafhldjw3n";
        rev = "474dd9caa322d0d59116c8922ba911ad34e58055";
  };

  #unpackPhase = ''
  #  ls -lah ${src}
  #'';

  installPhase = ''
    mkdir -p $out
#    ls ${src-nvm}
    ls .
    ls ${src}
    cp -rf ${src-nvm}/ 2.79/scripts/addons/NeuroMorphoVis
    echo "after copy:"
    ls -lah  2.79/scripts/addons/

    cp -rf * $out
    echo "after mv 2:"
    ls $out
  '';




}
