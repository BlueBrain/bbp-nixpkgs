
addMPIBGQVars () {
	
	
	export NIX_CC=@out@
    export CC=@out@/bin/@mpiCompilerC@
    export CXX=@out@/bin/@mpiCompilerCxx@

}

envHooks+=(addMPIBGQVars)


