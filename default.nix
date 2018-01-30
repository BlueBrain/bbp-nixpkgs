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
    configAll =
    let
        pathExists = name:
            builtins ? pathExists && builtins.pathExists (toPath name);

        envConfigFile = getEnv "NIXPKGS_CONFIG";
        homeDir = getEnv "HOME";
        homeConfigFile = homeDir + "/.nixpkgs/config.nix";
        systemConfigFile = "/nix/var/config/config.nix";

        envConfig = if envConfigFile != "" && pathExists envConfigFile then import (toPath envConfigFile) else {};
        homeConfig = if homeDir != "" && pathExists homeConfigFile then import (toPath homeConfigFile) else {};
        systemConfig = if pathExists systemConfigFile then import (toPath systemConfigFile) else {};
        
        configExpr = systemConfig // homeConfig // envConfig;

    in
        configExpr // { allowUnfree = true; };

    ## import all config: blue gene override and others 
    all-config = (import ./bluegene/config.nix) // generic-config // configAll // config ;

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

    
