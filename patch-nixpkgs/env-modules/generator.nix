{
stdenv,
buildEnv,
name,
description ? "" ,
packages,
extraContent ? ""
}:

assert builtins.isList packages;
assert builtins.length packages > 0;

 let
	pathSuffixExist = suffix:
			let 
				subPathExist = prefix: builtins.pathExists (prefix + suffix);
			in 
				builtins.any subPathExist  packages;
 in
stdenv.mkDerivation rec {

	inherit name;

	unpackPhase = ''echo "no sources needed"'';
	
	targetEnv =  buildEnv {
		name = "generated-env-module-${name}";
		paths = packages;
	};
	
	
	targetEnvBin = "${targetEnv}/bin";
	targetEnvPkgConfig = "${targetEnv}/lib/pkgconfig";
	targetEnvPython = "${targetEnv}/lib/python2.7";
	 
	
	buildPhase = ''
			cat > modulefile << EOF
#%Module1.0#####################################################################
##
## ${name}
##
## modulefiles/${name}. ${description}
##

proc ModulesHelp { } {
	puts "\t${description}"
}

module-whatis 		"${description}"

set		root		${targetEnv}


## check if any binaries are available
if { [file exists ${targetEnvBin} ] } {
		prepend-path PATH ${targetEnvBin}

}

## check if any pkgs config are availables
if { [file exists ${targetEnvPkgConfig} ] } {
		prepend-path PKG_CONFIG_PATH ${targetEnvPkgConfig}

}


## check if any python modules are available
if { [file exists ${targetEnvPython} ] } {
		prepend-path PYTHONPATH ${targetEnvPython}

}


EOF
	'';
		
		
	installPhase = ''
		install -D modulefile $out/share/modulefiles/${name};
	'';

}
