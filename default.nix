{ system ? builtins.currentSystem }:

#
# BBP package mapper 
#



# import std package from Nix Upstream

let 
	std-pkgs = args: (if builtins.pathExists ./std-nixpkgs/default.nix
				then (import ./std-nixpkgs args) 
				else (import (fetchTarball https://github.com/NixOS/nixpkgs-channels/archive/9fe0c23a23507d166d23dede5c3176eadd89e2b6.tar.gz) args));
	patch-pkgs = args: (import ./patch-nixpkgs { std-pkgs = std-pkgs args; } );
	bbp-pkgs = args: (import ./bbp-nixpkgs/all.nix { std-pkgs = patch-pkgs args; } );
in
	bbp-pkgs { }
