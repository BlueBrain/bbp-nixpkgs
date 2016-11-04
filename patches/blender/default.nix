{ stdenv
, fetchurl
, stdpkgs
}:


stdpkgs.blender.overrideDerivation (oldAttr: rec {
    name = "blender-${version}";
    version = "2.78a";

    src = fetchurl {
        url  = "http://download.blender.org/source/blender-${version}.tar.gz";
        sha256 = "1byf1klrvm8fdw2libx7wldz2i6lblp9nih6y58ydh00paqi8jh1";
    };


    enableParallelBuilding = true;


})
