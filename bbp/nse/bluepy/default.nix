{ stdenv
, config
, fetchgitPrivate
, pythonPackages
, buildEnv
}:


let

    bluepy_sources = fetchgitPrivate {
        url = config.bbp_git_ssh + "/analysis/BluePy";
        rev = "c825534e9cc59e7016ad6edeb16f657403da5c32";
        sha256 = "1kcy8cjzj64d7zvr79mvqnj4ykhbia0zg640vpvzjrgsjjf3zd61";
    };

    bluepy_version = "2017.02-c8255";

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


            # downgrade the shapely version requirement
            sed 's@Shapely==1.3.2@Shapely==1.3.1@g' -i requirements.txt
            sed 's@jsonschema==@jsonschema>=@g' -i requirements.txt
            sed 's@ordereddict.*@@g' -i requirements.txt
            sed 's@progressbar==2.3@progressbar==2.2@g' -i requirements.txt
            sed 's@SQLAlchemy==0.8.2@SQLAlchemy>=0.7.0@g' -i requirements.txt
            sed 's@PyYAML==3.10@PyYAML>=3.10@g' -i requirements.txt
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



