{
stdenv,
buildEnv,
name,
version ? "",
moduleFilePrefix ? "nix",
conflicts ? [] ,
packages,
isLibrary ? false,
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
    
    moduleFileSuffix = if version != ""
                            then "${name}/${version}" 
                            else "${name}";
                        
     depBuilder = depPrefixString: depList:  if depList == [] 
                                                then ''''
                                                else ''
                                                ${depPrefixString} ${(builtins.head (depList)).modulename}
                                                ${depBuilder depPrefixString (builtins.tail depList)}
                                                     '';
            
                            
 in
stdenv.mkDerivation rec {

    inherit name;
    inherit version;

    unpackPhase = ''echo "no sources needed"'';
    
    targetEnv =  buildEnv {
        name = "generated-env-module-${name}";
        paths = packages;
    };
    
    
    targetEnvBin = "${targetEnv}/bin";
    targetEnvPkgConfig = "${targetEnv}/lib/pkgconfig";
    targetEnvMan = "${targetEnv}/share/man";
    targetEnvPython = "${targetEnv}/lib/python2.7";
    targetEnvPythonInterpret = "${targetEnv}/bin/python";    
    targetEnvHoc = "${targetEnv}/hoc";
    targetModlUnit = "${targetEnv}/share/nrnunits.lib";

 
    
    buildPhase = ''
            cat > modulefile << EOF
#%Module1.0#####################################################################
##
## ${moduleFileSuffix}
##
## modulefiles ${name}/${version} ${description}
##

proc ModulesHelp { } {
    puts "\t${description}"
}

module-whatis       "${description}"

set     root        ${targetEnv}


${depBuilder "conflict" conflicts}

## check if any binaries are available
if { [file exists ${targetEnvBin} ] } {
        prepend-path PATH ${targetEnvBin}

}


${if isLibrary == true then 
''
## necessary var if declared as library
prepend-path CMAKE_PREFIX_PATH ${targetEnv}
'' 
else 
'' ''
}

## check if any pkgs config are available
if { [file exists ${targetEnvPkgConfig} ] } {
        prepend-path PKG_CONFIG_PATH ${targetEnvPkgConfig}

}

## configure MANPATH if necessary
## keep syntax ":/path" if not existing
## to not override system one
if { [file exists ${targetEnvMan} ] } {
        if { [info exists ::env(MANPATH) ] } {
            append-path MANPATH ${targetEnvMan}
        } else {
            setenv MANPATH ":${targetEnvMan}"
        }
}


## check if any python interpreter is present
if { [file exists ${targetEnvPythonInterpret} ] } {
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
        mkdir -p $out/share/modulefiles/${moduleFilePrefix}
        install -D modulefile $out/share/modulefiles/${moduleFilePrefix}/${moduleFileSuffix};
    '';
    
    passthru = { 
        modulename = "${moduleFilePrefix}/${moduleFileSuffix}";
    };

}
