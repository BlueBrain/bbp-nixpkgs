{ fetchgitPrivate
, pythonPackages
, config
, version ? "0.1.9"
, rev ? "5c4c834ea5f3544378c3fdd846ff24dd4b0e6015"
, sha256 ? "1isxqgwfbm1mfyaigy2j8nfz83f1yli6i5qpivc7qbnhh6rd2f8s"
}:

pythonPackages.buildPythonPackage rec {
    inherit version;
    name = "entity-management-${version}";

	src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/nse/entity-management";
        inherit rev sha256;
    };

    propagatedBuildInputs = with pythonPackages; [ six attrs python-dateutil requests typing ];

    doCheck = false;
}
