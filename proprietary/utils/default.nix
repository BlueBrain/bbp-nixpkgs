{ lib }:


with lib; rec {



  makeSearchPath = subDir: packages:
    concatStringsSep ":" (map (path: path + "/" + subDir) packages);

  makeSearchPathOutput = output: subDir: pkgs: makeSearchPath subDir (map (pkg : "${pkg}/output") pkgs);

 makeLibraryPath = makeSearchPathOutput "lib" "lib";



}
