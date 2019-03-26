{ fetchgitPrivate
, pythonPackages
, bluepy
, config
, version ? "0.6.39"
, rev ? "949526ce737d50346e7c7be146b87ccdcd7ac13b"
, sha256 ? "16ag7y8hch97xxcgyw39k5fp98i5n4s85cq79zcxymsnn8rwfzd7"
}:

pythonPackages.buildPythonPackage rec {
    inherit version;
    name = "bbp-analysis-framework-${version}";

	src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/nse/bbp-analysis-framework";
        inherit rev sha256;
    };

    propagatedBuildInputs = with pythonPackages; [ numpy scipy neurotools bluepy ];
}
