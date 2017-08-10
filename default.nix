{ system ? builtins.currentSystem,
  config ? {}
 }:

#
# BBP nixpkgs
#

let 
	##auto config
	generic-config = (import ./config/all_config.nix);

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
        configExpr // { allowUnfree = true; };


    ## import all config: blue gene override and others 
    all-config = (import ./bluegene/config.nix) // generic-config // configSystem // config ;

    ## all standard upstream packages
    std-pkgs = args: (if builtins.pathExists ./std-nixpkgs/default.nix
            then (import ./std-nixpkgs args) 
            else builtins.abort  
(''

no std nixpkgs found, you did not initialize the std submodule 
please run "git submodule update --recursive --init" in your bbp-nixpkgs directory

''));

    ## standard packages with generic patches
    patch-pkgs = args: (import ./patches { std-pkgs = std-pkgs args; } );

    ## proprietary external packages from binaries
    proprietary-pkgs = args: (import ./proprietary { pkgs = patch-pkgs args; config = all-config; });

    ## import BG/Q specific packages
    bgq-pkgs = args: (import ./bluegene { pkgs = proprietary-pkgs args; config = all-config; });

    ## all the bbp packages
    bbp-pkgs = args: (import ./bbp { std-pkgs = bgq-pkgs args; config = all-config; } );
    
in
    bbp-pkgs { 
       config = all-config;
       inherit system;
    }

    
