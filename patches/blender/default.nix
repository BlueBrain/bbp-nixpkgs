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


	cmakeFlags= [
	  "-DWITH_MOD_OCEANSIM=ON"
      "-DWITH_CODEC_FFMPEG=ON"
      "-DWITH_CODEC_SNDFILE=ON"
      "-DWITH_INSTALL_PORTABLE=OFF"
      "-DWITH_FFTW3=ON"
      "-DWITH_SDL=ON"
      "-DWITH_GAMEENGINE=ON"
      "-DWITH_OPENCOLORIO=ON"
      "-DWITH_PLAYER=ON"
	  "-DWITH_OPENCOLLADA=ON" ];

    enableParallelBuilding = true;


})
