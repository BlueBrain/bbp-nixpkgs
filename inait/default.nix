# All BBP related pkgs
{
 pkgs,
 config
}:

let
    oldPkgs = pkgs;
    # we create a new scope where every package exist
    callPackage = oldPkgs.newScope resultPkgs;

    # lets add the inait pkgs to the set of available packages
    resultPkgs = with oldPkgs; pkgs // rec {
        

        neuroconnector = callPackage ./neuroconnector {

        };

    };

    modules = rec {
            pkgs = resultPkgs;

        
            neuroconnector = pkgs.envModuleGen rec {
                name = "neuroconnector";
                moduleFilePrefix = "nix/sim";
                isLibrary = true;
                description = "neuroconnector module";
                packages = [
                                pkgs.neuroconnector
                           ];
            };

            inait = pkgs.buildEnv {

                name = "inait";
                paths = [ 
                        neuroconnector  
                        pkgs.modules.tensorflow
                        pkgs.modules.tensorflow-py3


                ];

            };
    };
in
  resultPkgs // { modules = resultPkgs.modules // modules; }
