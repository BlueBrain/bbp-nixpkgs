{ fetchgitPrivate
, pythonPackages
, bluepy
, config
, version ? "0.4.3"
, rev ? "b86265dd9acd8b3fdeb380fa9fb82d416f0e4c87"
, sha256 ? "191yprmh7x0g9n43cm6kf0qqi4zn6vka4ma8q0n737h171r6nn7f"
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
