{
stdenv,
buildEnv,
name,
packages,
prefixDir ? "",
description ? "" ,
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
	targetEnvHoc = "${targetEnv}/hoc";
	targetModlUnit = "${targetEnv}/share/nrnunits.lib";	
 
	
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

## check if any pkgs config are available
if { [file exists ${targetEnvPkgConfig} ] } {
		prepend-path PKG_CONFIG_PATH ${targetEnvPkgConfig}

}


## check if any python interpreter is present
if { [file exists ${targetEnvPython} ] } {
		prepend-path PYTHONHOME ${targetEnv}
}

## check if any python modules are available
foreach pathname [ glob -nocomplain "${targetEnv}/lib*/python*/*-packages/" ]  {
	
	prepend-path PYTHONPATH \$pathname

}

## check if any hoc path is needed
if { [file exists ${targetEnvHoc} ] } {
		prepend-path HOC_LIBRARY_PATH ${targetEnvHoc}
}

## check if any MODLUNIT export path is needed
if { [file exists ${targetModlUnit} ] } {
		prepend-path MODLUNIT ${targetModlUnit}
}


${extraContent}


EOF
	'';
		
		
	installPhase = ''
		install -D modulefile $out/share/modulefiles/${prefixDir}/${name};
	'';

}
