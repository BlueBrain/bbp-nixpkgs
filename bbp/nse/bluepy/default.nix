{ stdenv
, config
, fetchgitPrivate
, pythonPackages
, bluepy_version ? "0.6.1-2017.02-c8255"
, neurom
, pybinreports
}:


let
    
    info-version-legacy = {
        version = "0.6.1-2017.02-c8255";
        rev = "c825534e9cc59e7016ad6edeb16f657403da5c32";
        sha256 = "0ipchbw8igax6ni26cg7k1zchcv8xvnazmlvx2mz08blz43jbp1c";
    };

    info-version-0_9_6 = {
        version = "0.9.6";
        rev = "cf80c78ab2a5d6b0c87fcd75c7692b088d0587c6";
        sha256 = "0i80fs37cs8930b1vb86h89f9gp6hpq0xx7cylyak58qq29wyqs8";
    };

    info-version-latest = {
          version = "0.11.12dev1";
          rev = "c3e9e4a4d05de5985d2e2ebcb855e620997b7520";
          sha256 = "08g6wcyz8vif7zvlhwqpid2pnghi7kl151cwvdnr9cimmls7aj28";    
    };


    bluepy-info = if (bluepy_version == "0.6.1-2017.02-c8255") then info-version-legacy
                     else if (bluepy_version == "0.9.6") then info-version-0_9_6
                     else if (bluepy_version == "0.11.2") then info-version-latest
                     else throw ("not valid bluepy version");


    bluepy-src = fetchgitPrivate {
            url = config.bbp_git_ssh + "/analysis/BluePy";
            rev = bluepy-info.rev;
            sha256 = bluepy-info.sha256;
    };

    bluepy_runtime_deps = [
                            #  core
                            pythonPackages.h5py
                            pythonPackages.lazy
                            pythonPackages.numpy
                            pythonPackages.pandas
                            pythonPackages.matplotlib
                            pythonPackages.lxml
                            pythonPackages.future
                            pythonPackages.enum

                            #  others
                            pythonPackages.shapely
                            pythonPackages.jsonschema
                            pythonPackages.progressbar
                            pythonPackages.sqlalchemy
                            pythonPackages.pyyaml
                            pythonPackages.ordereddict
	
			    # tests
			    pythonPackages.nose
			    pythonPackages.nose-exclude
			    pythonPackages.mock

		            # nse
			    neurom
                            pybinreports
                          ];


    bluepy_config = pythonPackages.buildPythonPackage rec {
        name = "bluepy-config-${version}";
    	version = bluepy-info.version;

        src = bluepy-src; 

        preConfigure = ''
            cd bluepy_configfile
	    sed -i 's/==/>=/g' setup.py

        '';

        pythonPath = [];

        buildInputs = [
                        pythonPackages.ordereddict
			pythonPackages.six
			pythonPackages.future
			pythonPackages.jsonschema
       ] ++ bluepy_runtime_deps;

        propagatedBuildInputs = [ pythonPackages.ordereddict ];
    };

    bluepy_core = pythonPackages.buildPythonPackage rec {
        name = "bluepy-core-${version}";
        version = bluepy-info.version;

        src = bluepy-src;

        preConfigure = ''
            cd bluepy

            # remove useless requirements

            if [ -e "requirements.txt" ]; then
              FILE_NAME="requirements.txt"
            else
              FILE_NAME="setup.py"
            fi

	    # use >= deps and not absolute == to avoid conflicts....
	    sed -i 's/==\([^ ]\)/>=\1/g' $FILE_NAME

	    # remove progressbar requirements 
	    sed '/progressbar2>=3.18/d' -i $FILE_NAME
	    sed 's@progressbar.=2.3@progressbar>=2.2@i' -i $FILE_NAME
        '';

        buildInputs = [
                        pythonPackages.pip
                        bluepy_config
                      ] ++ bluepy_runtime_deps;

        propagatedBuildInputs = bluepy_runtime_deps ++ [ bluepy_config ];


    };



in bluepy_core



