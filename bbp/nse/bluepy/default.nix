{ stdenv
, config
, fetchgitPrivate
, pythonPackages
, buildEnv
, bluepy_version ? "2017.02-c8255"
, bluepy_rev ? "c825534e9cc59e7016ad6edeb16f657403da5c32"
, bluepy_sha256 ? "1kcy8cjzj64d7zvr79mvqnj4ykhbia0zg640vpvzjrgsjjf3zd61"
}:


let

    bluepy_sources = fetchgitPrivate {
        url = config.bbp_git_ssh + "/analysis/BluePy";
        rev = bluepy_rev;
        sha256 = bluepy_sha256;
    };

    bluepy_runtime_deps = [
                            #  core
                            pythonPackages.h5py
                            pythonPackages.numpy
                            pythonPackages.pandas
                            pythonPackages.matplotlib
                            pythonPackages.lxml

                            #  others
                            pythonPackages.shapely
                            pythonPackages.jsonschema
                            pythonPackages.progressbar
                            pythonPackages.sqlalchemy9
                            pythonPackages.pyyaml
                            pythonPackages.ordereddict
                          ];


    bluepy_config = pythonPackages.buildPythonPackage rec {
	    name = "bluepy-config-${version}";
    	version = bluepy_version;

        src = bluepy_sources;

        preConfigure = ''
            cd bluepy_configfile
        '';

        pythonPath = [];

        buildInputs = [
                        pythonPackages.pip
                        pythonPackages.ordereddict
				      ];

        propagatedBuildInputs = [ pythonPackages.ordereddict ];
    };

    bluepy_core = pythonPackages.buildPythonPackage rec {
        name = "bluepy-core-${version}";
        version = bluepy_version;

        src = bluepy_sources;

        preConfigure = ''
            cd bluepy

            # remove useless requirements

            if [ -e "requirements.txt" ]; then
              FILE_NAME="requirements.txt"
            else
              FILE_NAME="setup.py"
            fi

            # downgrade the shapely version requirement
            sed 's@Shapely==1.3.2@Shapely==1.3.1@i' -i $FILE_NAME
            sed 's@jsonschema==@jsonschema>=@i' -i $FILE_NAME
            sed 's@ordereddict.*@@i' -i $FILE_NAME
            sed 's@progressbar==2.3@progressbar==2.2@i' -i $FILE_NAME
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


        passthru = {
            pythonDeps =   (pythonPackages.gatherPythonRecDep bluepy_core);
        };

    };



in bluepy_core



