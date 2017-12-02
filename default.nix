{ system ? builtins.currentSystem,
  config ? {}
 }:

#
# BBP nixpkgs
#

let 
	##auto config
	generic-config = (import ./config/all_config.nix);

    #helpers
    toPath = builtins.toPath;
    getEnv = x: if builtins ? getEnv then builtins.getEnv x else "";


    ## system
    configSystem =
    let
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
    std-pkgs = args: (if builtins.pathExists ./base/default.nix
            then (import ./base args) 
            else builtins.abort  
(''

no std nixpkgs found, you did not initialize the std submodule 
please run "git submodule update --recursive --init" in your bbp-nixpkgs directory

''));

    ## proprietary external packages from binaries
    proprietary-pkgs = args: (import ./proprietary { pkgs = std-pkgs args; config = all-config; });

    ## standard packages with generic patches
    patch-pkgs = args: (import ./patches { std-pkgs = proprietary-pkgs args; } );


    ## import BG/Q specific packages
    bgq-pkgs = args: (import ./bluegene { pkgs = patch-pkgs args; config = all-config; });

    ## all the bbp packages
    bbp-pkgs = args: (import ./bbp { std-pkgs = bgq-pkgs args; config = all-config; } );

    # add the inait packages
    inait-pkgs = args: (if ((builtins.pathExists ./inait/proof) == false)
                        then bbp-pkgs args 
                        else (import (builtins.toPath ./inait) { pkgs = bbp-pkgs args; config = all-config; }));
    
in
    inait-pkgs { 
       config = all-config;
       inherit system;
    }

    
