{ stdenv
, bgq-driver
, bgqGlibcPath ? "/bgsys/drivers/toolchain/${bgq-driver}/gnu-linux/powerpc64-bgq-linux/"
} :


stdenv.mkDerivation {
    name = "bgq-glibc-2.12.2";
    
    preferLocalBuild = true;  
    
    
    buildCommand = '' 
        if [ ! -d ${bgqGlibcPath} ]; then
			echo "Impossible to find BG/Q glibc"
			exit 1
		fi
		
		
        mkdir -p $out/nix-support
        		
		pushd $out
		ln -s ${bgqGlibcPath}/lib lib
		ln -s ${bgqGlibcPath}/sys-include include       
    
      '';

}





