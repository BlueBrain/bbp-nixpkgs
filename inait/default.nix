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
        
        jarvis = callPackage ./jarvis {
        
        };
        
        jarvis-server = jarvis.server;
        pyjarvis = jarvis.pyjarvis;

    };




    # module generator namespace
    # create modules for specified packages
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

	    pyjarvis = pkgs.envModuleGen rec {
                name = "pyjarvis";
                moduleFilePrefix = "nix/infra";
                isLibrary = true;
                description = "Jarvis python bindings module";
                packages = [
                                pkgs.pyjarvis
                           ];
            };


            inait = pkgs.buildEnv {

                name = "inait";
                paths = with pkgs.modules; set.vcs
		            ++ set.dbg
		            ++ set.dev_base_pkgs
		            ++ set.ml_base
		            ++ set.sciences_base
		            ++ set.dev_viz
		            ++ set.compilers
		            ++ set.dev_toolkit_pkgs
		            ++ set.nse_base
            		    ++ set.hpc_base
		            ++ set.hpc_circuit
		            ++ set.hpc_simulators
		            ++ set.python_base
		            ++ set.python3_base
		            ++ set.system_pkgs
		            ++ set.parallel_toolkit
			    ++ [ 
				neuroconnector 
				pyjarvis
				
			];

            };
    };
in
  resultPkgs // { modules = resultPkgs.modules // modules; }
