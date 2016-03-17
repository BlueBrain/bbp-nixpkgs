{ system ? builtins.currentSystem,
  config ? {}
 }:

#
# BBP package mapper 
#



# import std package from Nix Upstream

let 

	## import all config: blue gene override and others 
	all-config = (import ./bluegene/config.nix) // config ;

	## upstream packages
	std-pkgs = args: (if builtins.pathExists ./std-nixpkgs/default.nix
				then (import ./std-nixpkgs args) 
				else (import (fetchTarball https://github.com/NixOS/nixpkgs-channels/archive/9220f03d08e4ba914605256aa22ef2a67a9a21ac.tar.gz) args));
	
	## upstream patched packages
	patch-pkgs = args: (import ./patch-nixpkgs { std-pkgs = std-pkgs args; } );
	
	## bbp packages
	bbp-pkgs = args: (import ./bbp-nixpkgs/all.nix { std-pkgs = patch-pkgs args; } );
in
	bbp-pkgs { 
	   config = all-config;
	   inherit system;
	}

	
