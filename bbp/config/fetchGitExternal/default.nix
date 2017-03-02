{ fetchgitPrivate, openssh, cmake, stdenv }: args: 

let 
    cmake_external_subdir = if args ? subdir then args.subdir else "";
    
    fetchgit_private_args = stdenv.lib.filterAttrs (k: v: k != "subdir") args;

in 

derivation ((fetchgitPrivate fetchgit_private_args).drvAttrs // {


  inherit cmake_external_subdir;
  
  ## The viz team build system use cmake to checkout sub-modules
  ## It's ugly and kill new born cute kitties, but we need to get it to work.
  ## We create a fake build dir, run cmake-git-external to submodule
  ## and destroy it, it should fetch the needed sources
  ##
  NIX_PREFETCH_GIT_CHECKOUT_HOOK= ''
    echo "*** GitExternal HACK ***"
    echo "pre-run CMake for GitExternal checkout"
    
    ${if (cmake_external_subdir != "") then ''cd ${cmake_external_subdir};'' else ''''}
    
    mkdir -p build;
    cd build;
    ${cmake}/bin/cmake -DDISABLE_SUBPROJECTS=TRUE $out/ || true;
    cd ..;
    rm -rf CMake/common/.git;       # rip off git repo
    rm -rf build;
    echo "delete build directory, keep only sources";
    echo "*** End GitExternal HACK ***" 
  '';
})
