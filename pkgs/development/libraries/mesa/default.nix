{ stdenv, fetchurl, pkgconfig, x11, xlibs, libdrm, expat }:

if ! stdenv.lib.lists.elem stdenv.system stdenv.lib.platforms.mesaPlatforms then
  throw "unsupported platform for Mesa"
else

stdenv.mkDerivation {
  name = "mesa-7.8.1";
  
  src = fetchurl {
    url = ftp://ftp.freedesktop.org/pub/mesa/7.8.1/MesaLib-7.8.1.tar.bz2;
    sha256 = "1yh717x4qxmild1s15qyv68irkrbm5gi4273052v8pfppxd6xd5h";
  };

  configureFlags = "--disable-gallium";
  
  buildInputs =
    [ pkgconfig expat x11 libdrm xlibs.glproto
      xlibs.libXxf86vm xlibs.libXfixes xlibs.libXdamage xlibs.dri2proto
    ];
  
  passthru = { inherit libdrm; };
  
  meta = {
    description = "An open source implementation of OpenGL";
    homepage = http://www.mesa3d.org/;
    license = "bsd";
  };
}
