{ system ? builtins.currentSystem }:

#
# BBP package mapper 
#



# import std package from Nix Upstream

let 
	std-pkgs = args: (import ./std-nixpkgs args );
	patch-pkgs = args: (import ./patch-nixpkgs { std-pkgs = std-pkgs args; } );
	bbp-pkgs = args: (import ./bbp-nixpkgs/all.nix { std-pkgs = patch-pkgs args; } );
in
	bbp-pkgs { }
