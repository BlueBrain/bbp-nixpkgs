{ fetchgitPrivate
, pythonPackages
, bluepy
, config
, version ? "0.3.28"
, rev ? "d5f45546d3e6fa312abc07bd16679768b2a8db30"
, sha256 ? "07azkmzp6s8jdzb3vvxplqyasvigpx0k44a2sn5wyw1kma8144v5"
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
