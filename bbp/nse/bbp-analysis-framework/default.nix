{ fetchgitPrivate
, pythonPackages
, bluepy
, config
, version ? "0.6.39"
, rev ? "10cca2e0799a2f5e80ad798cd2925161dfb8d37c"
, sha256 ? "0m53fgsa1fmjv48gzsdznbrmrg0sdqa5ld1n1z220libzg7aq5iv"
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
