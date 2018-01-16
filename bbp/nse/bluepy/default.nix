{ stdenv
, config
, fetchgitPrivate
, pythonPackages
, bluepy_version ? "0.6.1-2017.02-c8255"
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
        sha256 = "0ldn5hmgfyyslpvwyvch27y785jn73mjw15dj7idh1s8dkvacc29";
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
                          ];


    bluepy_config = pythonPackages.buildPythonPackage rec {
	    name = "bluepy-config-${version}";
    	version = bluepy-info.version;

        src = bluepy-src; 

        preConfigure = ''
            cd bluepy_configfile
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

            # downgrade the shapely version requirement
            sed 's@Shapely==1.3.2@Shapely>=1.3.1@i' -i $FILE_NAME
            sed 's@jsonschema==@jsonschema>=@i' -i $FILE_NAME
            sed 's@ordereddict.*@@i' -i $FILE_NAME
            sed 's@progressbar==2.3@progressbar>=2.2@i' -i $FILE_NAME
            sed 's@SQLAlchemy==0.8.2@SQLAlchemy>=0.7.0@i' -i $FILE_NAME
            sed 's@PyYAML==3.10@PyYAML>=3.10@i' -i $FILE_NAME

            # FIXME remove when we have all those available
            sed '/pylru>=1.0/d' -i $FILE_NAME
            sed '/enum34>=1.0/d' -i $FILE_NAME
            sed '/neurom>=1.3.0/d' -i $FILE_NAME
            sed '/pandas>=0.17.0/d' -i $FILE_NAME
            sed '/lazy>=1.0/d' -i $FILE_NAME
            sed '/progressbar2>=3.18/d' -i $FILE_NAME
        '';

        buildInputs = [
                        pythonPackages.pip
                        bluepy_config
                      ] ++ bluepy_runtime_deps;

        propagatedBuildInputs = bluepy_runtime_deps ++ [ bluepy_config ];


    };



in bluepy_core



