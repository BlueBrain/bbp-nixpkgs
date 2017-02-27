{
config
}:

# group all the global overrides of packages

{

    packageOverrides = pkgs: rec {	
	## we want openssh to use system config if we are in shared environment
	openssh = if (config ? is_prefixed && config.is_prefixed) then (pkgs.openssh.overrideDerivation (oldAttr: {
       		installPhase = "make install-nosysconf";		
	})) else pkgs.openssh;

    };

}

