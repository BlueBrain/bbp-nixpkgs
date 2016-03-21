 {
	system
 }:
 
let
	platforms = (import ./std-nixpkgs/pkgs/top-level/platforms.nix); 
	bluegene_platforms = (import ./bluegene/platforms.nix) { platformsBase = platforms; };
in
	if system == "armv6l-linux" then platforms.raspberrypi
	else if system == "armv7l-linux" then platforms.armv7l-hf-multiplatform
	else if system == "armv5tel-linux" then platforms.sheevaplug
	else if system == "mips64el-linux" then platforms.fuloong2f_n32
	else if system == "x86_64-linux" then platforms.pc64
	else if system == "i686-linux" then platforms.pc32
	else if system == "powerpc64-linux" then bluegene_platforms.powerpc64_linux
	else platforms.pcBase
