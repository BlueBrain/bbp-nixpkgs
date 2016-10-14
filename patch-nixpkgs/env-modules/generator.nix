{
stdenv,
buildEnv,
name,
version ? "",
moduleFilePrefix ? "nix",
moduleFileSuffix ? "",
conflicts ? [] ,
dependencies ? [],
packages ? [],
setRoot ? "",
isLibrary ? false,
isDefault ? false,
description ? "" ,
extraContent ? ""
}:


 let
    pathSuffixExist = suffix:
            let 
                subPathExist = prefix: builtins.pathExists (prefix + suffix);
            in 
                builtins.any subPathExist  packages;
    
    versionString = if version != "" then version 
                    # deduce automatically the version string if precised in the package
                    else if ( packages != [] ) && ( (builtins.head packages).drvAttrs ? version) then (builtins.head packages).drvAttrs.version
                    else "default";
                    
    
    moduleFilePath = ''${name}/${if (moduleFileSuffix != "") then "${moduleFileSuffix}/" else ""}${versionString}'';
                        
    depBuilder = depPrefixString: depList:  
                                          let 
                                             extractName = dep: if (builtins.isString dep) then dep
                                                                else dep.modulename;
                                          in
                                            if depList == [] then ''''
                                              else ''
                                                    ${depPrefixString} ${(extractName (builtins.head (depList)))}
                                                    ${depBuilder depPrefixString (builtins.tail depList)}
                                                    '';
            
                            
 in
stdenv.mkDerivation rec {

    inherit name;
    
    version = versionString;

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
    
## modulefile itself
cat > modulefile << EOF
#%Module1.0#####################################################################
##
## ${moduleFilePath}
##
## modulefiles ${name}/${versionString} ${description}
##

proc ModulesHelp { } {
    puts "\t${description}"
}

module-whatis       "${description}"

set     root        ${targetEnv}


${depBuilder "conflict" conflicts}
${depBuilder "module load" dependencies}
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

${if setRoot != "" then
''
setenv ${setRoot}_ROOT ${targetEnv}
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

'' 
+ (if isDefault then
''

cat > .version << EOF
#%Module1.0
set ModulesVersion "${versionString}"
EOF

'' else '''');
    
    
    installPhase = 
    ''
        mkdir -p $out/share/modulefiles/${moduleFilePrefix}
        install -D modulefile $out/share/modulefiles/${moduleFilePrefix}/${moduleFilePath}
    ''
    + (if isDefault then 
    ''
        install -D .version $out/share/modulefiles/${moduleFilePrefix}/${name}/.version;
    '' else '''');
    
    passthru = { 
        modulename = "${moduleFilePrefix}/${moduleFilePath}";
    };

}
