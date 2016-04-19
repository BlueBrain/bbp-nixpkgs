
addMPIBGQVars () {
	
	
	export NIX_CC=@out@
    export CC=@out@/bin/mpixlc_r  
    export CXX=@out@/bin/mpixlcxx_r

}

envHooks+=(addMPIBGQVars)

addToSearchPath PATH @forwardCompiler@/bin

