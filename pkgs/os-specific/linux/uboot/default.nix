{stdenv, fetchgit}:

assert stdenv.system == "armv5tel-linux";

# All this file is made for the Marvell Sheevaplug
   
stdenv.mkDerivation {
  name = "uboot-kw-git-snapshot";
   
  src = fetchgit {
    url = "git://git.marvell.com/u-boot-kw.git";
    rev = "b30fcb020c1465a7f12a2fdb411885965ab90616";
    sha256 = "6593951d5ff9a897bac9d4fd2ade5b283acc540ac96e0015bf0101846df0e251";
  };
 
  patches = [ ./eabi-toolchain.patch ];

  buildPhase = ''
    make mrproper
    make sheevaplug_config
    make u-boot.kwb
  '';

  dontStrip = true;
  NIX_STRIP_DEBUG = false;

  installPhase = ''
    ensureDir $out
    cp u-boot u-boot.bin u-boot.kwb u-boot.map $out

    ensureDir $out/bin
    cp tools/{envcrc,jtagconsole,mkimage,ncb,netconsole} $out/bin
  '';
}
