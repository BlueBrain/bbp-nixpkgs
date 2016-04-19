{ fetchgitPrivate, openssh, cmake, stdenv }: args: derivation ((fetchgitPrivate args).drvAttrs // {
  
  ## The viz team build system use cmake to checkout sub-modules
  ## It's ugly and kill new born cute kitties, but we need to get it to work.
  ## We create a fake build dir, run cmake-git-external to submodule
  ## and destroy it, it should fetch the needed sources
  ##
  NIX_PREFETCH_GIT_CHECKOUT_HOOK= ''
	echo "*** GitExternal HACK ***"
	echo "pre-run CMake for GitExternal checkout";
	mkdir -p build;
	cd build;
	${cmake}/bin/cmake -DDISABLE_SUBPROJECTS=TRUE $out/ || true;
	cd ..;
	rm -rf CMake/common/.git; 		# rip off git repo
	rm -rf build;
	echo "delete build directory, keep only sources";
	echo "*** End GitExternal HACK ***"	
  '';
})
