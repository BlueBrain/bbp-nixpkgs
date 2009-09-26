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
    cat >> config.h << EOF
    #define CONFIG_CMD_REISER
    #define CONFIG_CMD_EXT2
    #define CONFIG_CMD_JFFS2
    #define CONFIG_CMD_SOURCE
    #define CONFIG_CMD_IMI
    #define CONFIG_CMD_RUN
    #define CONFIG_CMD_MMC
    #define CONFIG_AUTO_COMPLETE
    #define CONFIG_CMDLINE_EDITING
    #define CONFIG_SYS_LONGHELP
    EOF
    cat >> config.mk << EOF
    CONFIG_CMD_REISER=y
    CONFIG_CMD_SOURCE=y
    CONFIG_CMD_EXT2=y
    CONFIG_CMD_JFFS2=y
    CONFIG_CMD_IMI=y
    CONFIG_CMD_RUN=y
    CONFIG_CMD_MMC=y
    CONFIG_AUTO_COMPLETE=y
    CONFIG_CMDLINE_EDITING=y
    CONFIG_SYS_LONGHELP=y
    EOF

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
