{ stdenv
, coreutils
, binutils
, which
, BGQLibc ? "/bgsys/drivers/ppcfloor/gnu-linux/powerpc64-bgq-linux/"
} :


let
	xlcPrefix = if (builtins.pathExists "/soft/compilers/ibmcmp-aug2015" ) then 
			"/soft/compilers/ibmcmp-aug2015" else "/opt/ibmcmp";
	nativePrefix = "${xlcPrefix}/vacpp/bg/12.1";
	nativePrefix_c = "${xlcPrefix}/vac/bg/12.1";

in
stdenv.mkDerivation {
    inherit xlcPrefix nativePrefix nativePrefix_c;

    name = "xlc-bgq-12.1.0";
    
    preferLocalBuild = true;  
    
    default_libc_path = "${BGQLibc}/lib" ;  
    
    default_cxx_stdlib_include_path = "/usr/include/c++/4.4.7/";
    
    buildCommand = ''
    
      ## test if we are on a IBM machine
      if [ ! -d ${nativePrefix} ]; then
        echo "Invalid IBM XLC compiler prefix ${nativePrefix}"
        exit 1
      fi
    
      mkdir -p $out/nix-support
      substituteAll "${./setup-hook.sh}" "$out/nix-support/setup-hook"

      pushd ${nativePrefix}
      
      
      cp -r ${nativePrefix}/. $out

      
      popd
      
      substituteAll ${./compiler-wrapper.sh} $out/bin/compiler-wrapper
      sed -i 's@prefix@${nativePrefix_c}@g' $out/bin/compiler-wrapper   

      substituteAll ${./compiler-wrapper.sh} $out/bin/compiler-wrapper-c++
      sed -i 's@prefix@${nativePrefix}@g' $out/bin/compiler-wrapper-c++
      
      chmod a+x $out/bin/compiler-wrapper* 

# replace incorrect compiler wrapper script requiring gcc & rpm
# by new ones

    pushd $out/bin
    for i in $(ls {*lc,*lc_r,c89*,c99*,cc,cc_r})
    do
        rm -f $i
        ln -s compiler-wrapper $i
    done
 
    for i in $(ls {*lC,*lC_r,*lc++*})
    do
        rm -f $i
        ln -s compiler-wrapper-c++ $i
    done 
    
	# let's add the linker and the bin utils 
	# like xlc use the GNU native ones    

      ln -s ${BGQLibc}/bin/ar $out/bin/ar
      ln -s ${BGQLibc}/bin/as $out/bin/as   
      ln -s ${BGQLibc}/bin/c++filt $out/bin/c++filt 
      ln -s ${BGQLibc}/bin/readelf $out/bin/readelf  
      ln -s ${BGQLibc}/bin/ld     $out/bin/ld
      ln -s ${BGQLibc}/bin/strip  $out/bin/strip 
      
   ## rename the include dir to avoid auto inclusion
   ## we want to use GCC headers, not xlc ones
   mv $out/include $out/xlc-include      
      
      '';
      
  propagatedBuildInputs = [ which ];

}





