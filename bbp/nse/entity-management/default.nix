{ fetchgitPrivate
, pythonPackages
, config
, version ? "0.1.11"
, rev ? "358092005d0b0c6e01170747c0fee41deb83220f"
, sha256 ? "0p6isxw7m6wwp799vlkyqjb6pm59rxw4j31d3fj78cnvmmhnhmii"
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
