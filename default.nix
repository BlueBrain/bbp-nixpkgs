{ system ? builtins.currentSystem,
  config ? {}
 }:

#
# BBP package mapper 
#



# import std package from Nix Upstream

let 
	## system
	configSystem =
	let
	 toPath = builtins.toPath;
	 getEnv = x: if builtins ? getEnv then builtins.getEnv x else "";
	 pathExists = name:
		builtins ? pathExists && builtins.pathExists (toPath name);

	 configFile = getEnv "NIXPKGS_CONFIG";
	 homeDir = getEnv "HOME";
	 configFile2 = homeDir + "/.nixpkgs/config.nix";

	 configExpr =
	 if configFile != "" && pathExists configFile then import (toPath configFile)
	 else if homeDir != "" && pathExists configFile2 then import (toPath configFile2)
	 else {};

	in
	   configExpr;

	## import all config: blue gene override and others 
	all-config = (import ./bluegene/config.nix) // configSystem // config ;

	## upstream packages
	std-pkgs = args: (if builtins.pathExists ./std-nixpkgs/default.nix
				then (import ./std-nixpkgs args) 
				else (import (fetchTarball https://github.com/NixOS/nixpkgs-channels/archive/9220f03d08e4ba914605256aa22ef2a67a9a21ac.tar.gz) args));
	
	## upstream patched packages
	patch-pkgs = args: (import ./patch-nixpkgs { std-pkgs = std-pkgs args; } );

	## import BG/Q specific packages
	bgq-pkgs = args: (import ./bluegene { pkgs = patch-pkgs args; config = all-config; });
	
	## bbp packages
	bbp-pkgs = args: (import ./bbp-nixpkgs/all.nix { std-pkgs = bgq-pkgs args; config = all-config; } );
in
	bbp-pkgs { 
	   config = all-config;
	   inherit system;
	}

	
