{ fetchgitPrivate
, pythonPackages
, bluepy
, config
, version ? "0.4.0"
, rev ? "3ae38a5b82c33bfeeac6e292dd3026f0a993ff1e"
, sha256 ? "116hc3a6hczv494x2rxiaqwi5454jni4fs471f3n6riqrxfy3x0c"
}:

pythonPackages.buildPythonPackage rec {
    inherit version;
    name = "simwriter-${version}";

	src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/project/proj1/simwriter";
        inherit rev sha256;
    };

    propagatedBuildInputs = with pythonPackages; [ matplotlib numpy scipy neurotools cheetah bluepy ];
}
